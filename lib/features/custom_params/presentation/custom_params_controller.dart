import '../../../common/controllers/async_list_controller.dart';
import '../../../core/network/api_exception.dart';
import '../data/custom_params_api.dart';
import '../data/models/models.dart';

class CustomParamsController {
  CustomParamsController(this._api)
      : list = AsyncListController<GetCustomParam>(() async {
          final response = await _api.getCustomParams();
          return response.customParams;
        });

  final CustomParamsApi _api;
  final AsyncListController<GetCustomParam> list;

  Future<String?> create(CreateCustomParamRequest request) async {
    try {
      final reply = await _api.createCustomParam(request);
      if (!reply.isOk) {
        return reply.message.isNotEmpty ? reply.message : 'Не удалось создать параметр';
      }
      await list.load();
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  void dispose() => list.dispose();
}
