import '../../../common/models/stock_reply.dart';
import '../../../core/network/gateway_api_base.dart';
import 'custom_params_api.dart';
import 'models/models.dart';

class GatewayCustomParamsApi extends GatewayApiBase implements CustomParamsApi {
  const GatewayCustomParamsApi(super.client);

  @override
  Future<StockReply> createCustomParam(CreateCustomParamRequest request) {
    return execute(
      () => dio.post('/v1/custom-params', data: request.toJson()),
      StockReply.fromJson,
    );
  }

  @override
  Future<GetCustomParamsResponse> getCustomParams() {
    return execute(
      () => dio.get('/v1/custom-params'),
      GetCustomParamsResponse.fromJson,
    );
  }

  @override
  Future<GetCustomParamByIDResponse> getCustomParamById(int id) {
    return execute(
      () => dio.get('/v1/custom-params/$id'),
      GetCustomParamByIDResponse.fromJson,
    );
  }
}
