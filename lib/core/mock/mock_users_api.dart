import '../../common/models/err_info_reason.dart';
import '../../core/network/api_exception.dart';
import '../../features/users/data/models/delete_users_reply.dart';
import '../../features/users/data/models/get_user_reply.dart';
import '../../features/users/data/models/get_users_reply.dart';
import '../../features/users/data/models/update_user.dart';
import '../../features/users/data/models/update_users_reply.dart';
import '../../features/users/data/users_api.dart';
import 'mock_backend.dart';

class MockUsersApi implements UsersApi {
  MockUsersApi(this._backend);

  final MockBackend _backend;

  @override
  Future<GetUsersReply> getUsersList() async {
    await mockLatency();
    return GetUsersReply(
      errInfoReason: ErrInfoReason.statusOk,
      users: _backend.allUsers,
    );
  }

  @override
  Future<GetUserReply> getCurrentUser() async {
    await mockLatency();
    final user = _backend.currentUser;
    if (!_backend.isAuthenticated || user == null) {
      throw ApiException(message: 'Не авторизован', statusCode: 401);
    }
    return GetUserReply(errInfoReason: ErrInfoReason.statusOk, user: user);
  }

  @override
  Future<UpdateUsersReply> updateCurrentUser(UpdateUser updatedUser) async {
    await mockLatency();
    if (!_backend.isAuthenticated) {
      throw ApiException(message: 'Не авторизован', statusCode: 401);
    }
    final user = _backend.updateCurrentUser(
      mail: updatedUser.mail,
      name: updatedUser.name,
      age: updatedUser.age,
    );
    return UpdateUsersReply(
      errInfoReason: ErrInfoReason.statusOk,
      user: user,
      message: 'Профиль обновлён',
    );
  }

  @override
  Future<DeleteUsersReply> deleteCurrentUser() async {
    await mockLatency();
    if (!_backend.isAuthenticated) {
      throw ApiException(message: 'Не авторизован', statusCode: 401);
    }
    final user = _backend.deleteCurrentUser();
    return DeleteUsersReply(
      errInfoReason: ErrInfoReason.statusOk,
      user: user,
      message: 'Аккаунт удалён',
    );
  }
}
