import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../../users/data/models/user.dart';
import '../../users/data/users_api.dart';
import '../data/auth_api.dart';
import '../data/models/auth_reply.dart';
import '../data/models/login_request.dart';
import '../data/models/register_request.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// The single source of truth for "are we logged in". The gateway's
/// session lives in a cookie the [ApiClient] already attaches to every
/// request, so the only way to know whether it's still valid is to ask an
/// authenticated endpoint — [bootstrap] does that with `GET /v1/users/me`
/// on app start instead of guessing from local state.
class AuthController extends ChangeNotifier {
  AuthController(this._authApi, this._usersApi);

  final AuthApi _authApi;
  final UsersApi _usersApi;

  AuthStatus status = AuthStatus.unknown;
  User? currentUser;
  bool isSubmitting = false;
  String? errorMessage;

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> bootstrap() async {
    try {
      final reply = await _usersApi.getCurrentUser();
      if (_isDisposed) return;
      currentUser = reply.user;
      status = AuthStatus.authenticated;
    } on ApiException {
      if (_isDisposed) return;
      status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login({required String mail, required String password}) {
    return _submit(() => _authApi.login(LoginRequest(mail: mail, password: password)));
  }

  Future<bool> register({
    required String mail,
    required String password,
    required String name,
    required int age,
  }) {
    return _submit(() => _authApi.register(
          RegisterRequest(mail: mail, password: password, name: name, age: age),
        ));
  }

  Future<bool> _submit(Future<AuthReply> Function() call) async {
    if (isSubmitting) return false;
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();
    try {
      final reply = await call();
      if (_isDisposed) return false;
      if (!reply.isOk) {
        errorMessage = reply.message.isNotEmpty ? reply.message : 'Не удалось выполнить запрос';
        isSubmitting = false;
        notifyListeners();
        return false;
      }
      await bootstrap();
      if (_isDisposed) return true;
      isSubmitting = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      if (_isDisposed) return false;
      errorMessage = e.message;
      isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authApi.logout();
    } on ApiException {
      // Cookie is client-side and gets dropped regardless of whether the
      // server-side logout call itself succeeded, so a failed request here
      // shouldn't strand the user on the logged-in screen.
    }
    if (_isDisposed) return;
    currentUser = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
