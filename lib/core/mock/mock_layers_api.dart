import '../../common/models/err_info_reason.dart';
import '../../common/models/stock_reply.dart';
import '../../features/layers/data/layers_api.dart';
import '../../features/layers/data/models/models.dart';
import 'mock_backend.dart';

class MockLayersApi implements LayersApi {
  MockLayersApi(this._backend);

  final MockBackend _backend;

  @override
  Future<StockReply> createLayer(CreateLayerRequest request) async {
    await mockLatency();
    _backend.createLayer(
      namespaceId: request.namespaceId,
      name: request.name,
      description: request.description,
    );
    return const StockReply(errInfoReason: ErrInfoReason.statusOk, message: 'Слой создан');
  }

  @override
  Future<GetLayersResponse> getLayers() async {
    await mockLatency();
    return GetLayersResponse(message: 'OK', layers: List.of(_backend.layers));
  }

  @override
  Future<GetLayerByIDResponse> getLayerById(int id) async {
    await mockLatency();
    final layer = _backend.layers.where((l) => l.id == id).firstOrNull;
    if (layer == null) {
      throw StateError('Layer $id not found');
    }
    return GetLayerByIDResponse(message: 'OK', layer: layer);
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
