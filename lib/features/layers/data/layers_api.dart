import '../../../common/models/stock_reply.dart';
import 'models/models.dart';

abstract class LayersApi {
  Future<StockReply> createLayer(CreateLayerRequest request);

  Future<GetLayersResponse> getLayers();

  Future<GetLayerByIDResponse> getLayerById(int id);
}
