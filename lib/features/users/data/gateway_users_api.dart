import '../../../core/network/gateway_api_base.dart';
import 'models/delete_users_reply.dart';
import 'models/get_user_reply.dart';
import 'models/get_users_reply.dart';
import 'models/update_user.dart';
import 'models/update_users_reply.dart';
import 'users_api.dart';

class GatewayUsersApi extends GatewayApiBase implements UsersApi {
  const GatewayUsersApi(super.client);

  @override
  Future<GetUsersReply> getUsersList() {
    return execute(() async {
      final response = await dio.get<dynamic>('/v1/users');
      // The gateway returns a bare JSON array here rather than the
      // `{"users": [...]}` object the openapi spec describes.
      if (response.data is List) response.data = {'users': response.data};
      return response;
    }, GetUsersReply.fromJson);
  }

  @override
  Future<GetUserReply> getCurrentUser() {
    return execute(() => dio.get('/v1/users/me'), GetUserReply.fromJson);
  }

  @override
  Future<UpdateUsersReply> updateCurrentUser(UpdateUser updatedUser) {
    return execute(
      () => dio.patch(
        '/v1/users',
        data: {'updated_user': updatedUser.toJson()},
      ),
      UpdateUsersReply.fromJson,
    );
  }

  @override
  Future<DeleteUsersReply> deleteCurrentUser() {
    return execute(() => dio.delete('/v1/users'), DeleteUsersReply.fromJson);
  }
}
