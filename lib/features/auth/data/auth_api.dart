import 'models/auth_reply.dart';
import 'models/login_request.dart';
import 'models/register_request.dart';

/// Session/account endpoints. Implemented by [GatewayAuthApi] (real
/// backend) and `MockAuthApi` (in-memory, for `USE_MOCK_API`) — see
/// [GatewayClient.create].
abstract class AuthApi {
  Future<AuthReply> register(RegisterRequest request);

  Future<AuthReply> login(LoginRequest request);

  /// Clears the session cookie server-side. Callers should also drop any
  /// locally-cached user state after this resolves.
  Future<AuthReply> logout();

  /// Exchanges the refresh cookie for a fresh session. Most callers won't
  /// need to call this directly — [RefreshOn401Interceptor] already does
  /// it automatically when a request comes back 401.
  Future<AuthReply> refresh();
}
