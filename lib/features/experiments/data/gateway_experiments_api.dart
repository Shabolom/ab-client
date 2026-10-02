import '../../../common/models/stock_reply.dart';
import '../../../core/network/gateway_api_base.dart';
import 'experiments_api.dart';
import 'models/request_models.dart';
import 'models/response_models.dart';

class GatewayExperimentsApi extends GatewayApiBase implements ExperimentsApi {
  const GatewayExperimentsApi(super.client);

  @override
  Future<ExperimentsReply> userExperiment(ExperimentRequest request) {
    return execute(
      () => dio.post('/v1/experiments/user', data: request.toJson()),
      ExperimentsReply.fromJson,
    );
  }

  @override
  Future<StockReply> createExperiment(CreateExperimentRequest request) {
    return execute(
      () => dio.post('/v1/experiments', data: request.toJson()),
      StockReply.fromJson,
    );
  }

  @override
  Future<GetExperimentsResponse> getExperiments() {
    return execute(() => dio.get('/v1/experiments'), GetExperimentsResponse.fromJson);
  }

  @override
  Future<GetExperimentByIDResponse> getExperimentById(int id) {
    return execute(
      () => dio.get('/v1/experiments/$id'),
      GetExperimentByIDResponse.fromJson,
    );
  }

  @override
  Future<StockReply> setReadyExperiment(int experimentId) {
    return execute(
      () => dio.post('/v1/experiments/$experimentId/ready'),
      StockReply.fromJson,
    );
  }

  @override
  Future<StockReply> setStoppedExperiment(int experimentId) {
    return execute(
      () => dio.post('/v1/experiments/$experimentId/stopped'),
      StockReply.fromJson,
    );
  }
}
