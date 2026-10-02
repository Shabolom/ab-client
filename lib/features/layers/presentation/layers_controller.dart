import '../../../common/controllers/async_list_controller.dart';
import '../../../core/network/api_exception.dart';
import '../data/layers_api.dart';
import '../data/models/models.dart';

class LayersController {
  LayersController(this._api)
      : list = AsyncListController<GetLayer>(() async {
          final response = await _api.getLayers();
          return response.layers;
        });

  final LayersApi _api;
  final AsyncListController<GetLayer> list;

  Future<String?> create(CreateLayerRequest request) async {
    try {
      final reply = await _api.createLayer(request);
      if (!reply.isOk) {
        return reply.message.isNotEmpty ? reply.message : 'Не удалось создать слой';
      }
      await list.load();
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  void dispose() => list.dispose();
}
