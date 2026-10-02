import '../../common/models/err_info_reason.dart';
import '../../core/network/api_exception.dart';
import '../../features/auth/data/auth_api.dart';
import '../../features/auth/data/models/auth_reply.dart';
import '../../features/auth/data/models/login_request.dart';
import '../../features/auth/data/models/register_request.dart';
import 'mock_backend.dart';

class MockAuthApi implements AuthApi {
  MockAuthApi(this._backend);

  final MockBackend _backend;

  @override
  Future<AuthReply> register(RegisterRequest request) async {
    await mockLatency();
    _backend.register(
      mail: request.mail,
      password: request.password,
      name: request.name,
      age: request.age,
    );
    return const AuthReply(errInfoReason: ErrInfoReason.statusOk, message: 'Регистрация выполнена');
  }

  @override
  Future<AuthReply> login(LoginRequest request) async {
    await mockLatency();
    final user = _backend.login(request.mail, request.password);
    if (user == null) {
      return const AuthReply(
        errInfoReason: ErrInfoReason.invalidRequest,
        message: 'Неверная почта или пароль',
      );
    }
    return const AuthReply(errInfoReason: ErrInfoReason.statusOk, message: 'OK');
  }

  @override
  Future<AuthReply> logout() async {
    await mockLatency();
    _backend.logout();
    return const AuthReply(errInfoReason: ErrInfoReason.statusOk, message: 'OK');
  }

  @override
  Future<AuthReply> refresh() async {
    await mockLatency();
    if (!_backend.isAuthenticated) {
      throw ApiException(message: 'Сессия истекла', statusCode: 401);
    }
    return const AuthReply(errInfoReason: ErrInfoReason.statusOk, message: 'OK');
  }
}
