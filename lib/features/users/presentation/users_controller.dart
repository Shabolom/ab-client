import '../../../common/controllers/async_list_controller.dart';
import '../../../core/network/api_exception.dart';
import '../data/models/update_user.dart';
import '../data/models/user.dart';
import '../data/users_api.dart';

class UsersController {
  UsersController(this._api)
      : list = AsyncListController<User>(() async {
          final response = await _api.getUsersList();
          return response.users;
        });

  final UsersApi _api;
  final AsyncListController<User> list;

  Future<String?> updateProfile(UpdateUser update) async {
    try {
      await _api.updateCurrentUser(update);
      await list.load();
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  void dispose() => list.dispose();
}
