import '../../../common/models/stock_reply.dart';
import 'models/request_models.dart';
import 'models/response_models.dart';

abstract class ExperimentsApi {
  Future<ExperimentsReply> userExperiment(ExperimentRequest request);

  Future<StockReply> createExperiment(CreateExperimentRequest request);

  Future<GetExperimentsResponse> getExperiments();

  Future<GetExperimentByIDResponse> getExperimentById(int id);

  Future<StockReply> setReadyExperiment(int experimentId);

  Future<StockReply> setStoppedExperiment(int experimentId);
}
