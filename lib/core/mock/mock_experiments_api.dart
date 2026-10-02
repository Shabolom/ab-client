import '../../common/models/err_info_reason.dart';
import '../../common/models/stock_reply.dart';
import '../../features/experiments/data/experiments_api.dart';
import '../../features/experiments/data/models/request_models.dart';
import '../../features/experiments/data/models/response_models.dart' as resp;
import 'mock_backend.dart';

class MockExperimentsApi implements ExperimentsApi {
  MockExperimentsApi(this._backend);

  final MockBackend _backend;

  @override
  Future<resp.ExperimentsReply> userExperiment(ExperimentRequest request) async {
    await mockLatency();
    final assignments = _backend.resolveUserExperiment(
      deviceId: request.deviceId,
      namespace: request.namespace,
    );
    return resp.ExperimentsReply(
      errInfoReason: ErrInfoReason.statusOk,
      message: assignments.isEmpty ? 'Нет активных экспериментов' : 'OK',
      experimentsReply: assignments,
    );
  }

  @override
  Future<StockReply> createExperiment(CreateExperimentRequest request) async {
    await mockLatency();
    _backend.createExperiment(
      name: request.name,
      rolloutPercentage: request.rolloutPercentage,
      startDate: request.startDate,
      endDate: request.endDate,
      layersId: request.layersId,
      groups: request.groups
          .map((g) => resp.GetGroup(
                id: g.id ?? 0,
                name: g.name,
                rollingPercentage: g.rollingPercentage,
                deviceId: g.deviceId,
              ))
          .toList(),
      passingCities: request.passingCities,
      excludedCities: request.excludedCities,
      passingStores: request.passingStores,
      excludedStores: request.excludedStores,
    );
    return const StockReply(errInfoReason: ErrInfoReason.statusOk, message: 'Эксперимент создан');
  }

  @override
  Future<resp.GetExperimentsResponse> getExperiments() async {
    await mockLatency();
    return resp.GetExperimentsResponse(message: 'OK', experiments: List.of(_backend.experiments));
  }

  @override
  Future<resp.GetExperimentByIDResponse> getExperimentById(int id) async {
    await mockLatency();
    final experiment = _backend.experiments.where((e) => e.id == id).firstOrNull;
    if (experiment == null) {
      throw StateError('Experiment $id not found');
    }
    return resp.GetExperimentByIDResponse(message: 'OK', experiment: experiment);
  }

  @override
  Future<StockReply> setReadyExperiment(int experimentId) async {
    await mockLatency();
    final updated = _backend.setReadyExperiment(experimentId);
    if (updated == null) {
      return const StockReply(
        errInfoReason: ErrInfoReason.invalidRequest,
        message: 'Эксперимент не найден',
      );
    }
    return const StockReply(errInfoReason: ErrInfoReason.statusOk, message: 'Эксперимент запущен');
  }

  @override
  Future<StockReply> setStoppedExperiment(int experimentId) async {
    await mockLatency();
    final updated = _backend.setStoppedExperiment(experimentId);
    if (updated == null) {
      return const StockReply(
        errInfoReason: ErrInfoReason.invalidRequest,
        message: 'Эксперимент не найден',
      );
    }
    return const StockReply(
      errInfoReason: ErrInfoReason.statusOk,
      message: 'Эксперимент остановлен',
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
