import '../../../common/models/stock_reply.dart';
import 'models/models.dart';

abstract class CustomParamsApi {
  Future<StockReply> createCustomParam(CreateCustomParamRequest request);

  Future<GetCustomParamsResponse> getCustomParams();

  Future<GetCustomParamByIDResponse> getCustomParamById(int id);
}
