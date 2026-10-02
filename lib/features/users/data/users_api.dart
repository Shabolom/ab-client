import 'models/delete_users_reply.dart';
import 'models/get_user_reply.dart';
import 'models/get_users_reply.dart';
import 'models/update_user.dart';
import 'models/update_users_reply.dart';

abstract class UsersApi {
  Future<GetUsersReply> getUsersList();

  Future<GetUserReply> getCurrentUser();

  Future<UpdateUsersReply> updateCurrentUser(UpdateUser updatedUser);

  Future<DeleteUsersReply> deleteCurrentUser();
}
