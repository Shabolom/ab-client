import '../../../common/controllers/async_list_controller.dart';
import '../../../common/models/stock_reply.dart';
import '../../../core/network/api_exception.dart';
import '../data/experiments_api.dart';
import '../data/models/request_models.dart';
import '../data/models/response_models.dart';

class ExperimentsController {
  ExperimentsController(this._api)
      : list = AsyncListController<GetExperiment>(() async {
          final response = await _api.getExperiments();
          return response.experiments;
        });

  final ExperimentsApi _api;
  final AsyncListController<GetExperiment> list;

  Future<String?> create(CreateExperimentRequest request) async {
    try {
      final reply = await _api.createExperiment(request);
      if (!reply.isOk) {
        return reply.message.isNotEmpty ? reply.message : 'Не удалось создать эксперимент';
      }
      await list.load();
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  Future<String?> setReady(int experimentId) => _transition(_api.setReadyExperiment, experimentId);

  Future<String?> setStopped(int experimentId) =>
      _transition(_api.setStoppedExperiment, experimentId);

  Future<String?> _transition(
    Future<StockReply> Function(int id) call,
    int experimentId,
  ) async {
    try {
      final reply = await call(experimentId);
      if (!reply.isOk) {
        return reply.message.isNotEmpty ? reply.message : 'Не удалось изменить статус';
      }
      await list.load();
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  void dispose() => list.dispose();
}
