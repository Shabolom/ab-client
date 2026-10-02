import '../../../common/models/stock_reply.dart';
import '../../../core/network/gateway_api_base.dart';
import 'layers_api.dart';
import 'models/models.dart';

class GatewayLayersApi extends GatewayApiBase implements LayersApi {
  const GatewayLayersApi(super.client);

  @override
  Future<StockReply> createLayer(CreateLayerRequest request) {
    return execute(
      () => dio.post('/v1/layers', data: request.toJson()),
      StockReply.fromJson,
    );
  }

  @override
  Future<GetLayersResponse> getLayers() {
    return execute(() => dio.get('/v1/layers'), GetLayersResponse.fromJson);
  }

  @override
  Future<GetLayerByIDResponse> getLayerById(int id) {
    return execute(() => dio.get('/v1/layers/$id'), GetLayerByIDResponse.fromJson);
  }
}
