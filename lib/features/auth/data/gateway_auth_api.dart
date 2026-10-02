import '../../../core/network/gateway_api_base.dart';
import 'auth_api.dart';
import 'models/auth_reply.dart';
import 'models/login_request.dart';
import 'models/register_request.dart';

class GatewayAuthApi extends GatewayApiBase implements AuthApi {
  const GatewayAuthApi(super.client);

  @override
  Future<AuthReply> register(RegisterRequest request) {
    return execute(
      () => dio.post('/v1/auth/register', data: request.toJson()),
      AuthReply.fromJson,
    );
  }

  @override
  Future<AuthReply> login(LoginRequest request) {
    return execute(
      () => dio.post('/v1/auth/login', data: request.toJson()),
      AuthReply.fromJson,
    );
  }

  @override
  Future<AuthReply> logout() {
    return execute(() => dio.post('/v1/auth/logout'), AuthReply.fromJson);
  }

  @override
  Future<AuthReply> refresh() {
    return execute(() => dio.post('/v1/auth/refresh'), AuthReply.fromJson);
  }
}
