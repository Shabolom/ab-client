import '../../common/models/err_info_reason.dart';
import '../../common/models/stock_reply.dart';
import '../../features/feature_toggles/data/feature_toggles_api.dart';
import '../../features/feature_toggles/data/models/request_models.dart';
import '../../features/feature_toggles/data/models/response_models.dart';
import 'mock_backend.dart';

class MockFeatureTogglesApi implements FeatureTogglesApi {
  MockFeatureTogglesApi(this._backend);

  final MockBackend _backend;

  @override
  Future<StockReply> createFeatureToggle(CreateFeatureToggleRequest request) async {
    await mockLatency();
    _backend.createFeatureToggle(
      name: request.name,
      namespaceId: request.namespaceId,
      iosRolloutPercentage: request.iosRolloutPercentage,
      androidRolloutPercentage: request.androidRolloutPercentage,
      webRolloutPercentage: request.webRolloutPercentage,
      rolloutPercentage: request.rolloutPercentage,
    );
    return const StockReply(errInfoReason: ErrInfoReason.statusOk, message: 'Фича создана');
  }

  @override
  Future<GetFeatureTogglesResponse> getFeatureToggles() async {
    await mockLatency();
    return GetFeatureTogglesResponse(message: 'OK', featureToggles: List.of(_backend.featureToggles));
  }

  @override
  Future<GetFeatureToggleByIDResponse> getFeatureToggleById(int id) async {
    await mockLatency();
    final toggle = _backend.featureToggles.where((f) => f.id == id).firstOrNull;
    if (toggle == null) {
      throw StateError('Feature toggle $id not found');
    }
    return GetFeatureToggleByIDResponse(message: 'OK', featureToggle: toggle);
  }

  @override
  Future<StockReply> updateFeatureToggleRollout(
    int featureToggleId,
    UpdateFeatureToggleRolloutRequest request,
  ) async {
    await mockLatency();
    final updated = _backend.updateFeatureToggleRollout(
      featureToggleId,
      iosRolloutPercentage: request.iosRolloutPercentage,
      androidRolloutPercentage: request.androidRolloutPercentage,
      webRolloutPercentage: request.webRolloutPercentage,
      rolloutPercentage: request.rolloutPercentage,
    );
    if (updated == null) {
      return const StockReply(
        errInfoReason: ErrInfoReason.invalidRequest,
        message: 'Фича не найдена',
      );
    }
    return const StockReply(errInfoReason: ErrInfoReason.statusOk, message: 'Rollout обновлён');
  }

  @override
  Future<StockReply> setFeatureToggleStatus(
    int featureToggleId,
    SetFeatureToggleStatusRequest request,
  ) async {
    await mockLatency();
    final updated = _backend.setFeatureToggleStatus(featureToggleId, request.status);
    if (updated == null) {
      return const StockReply(
        errInfoReason: ErrInfoReason.invalidRequest,
        message: 'Фича не найдена',
      );
    }
    return const StockReply(errInfoReason: ErrInfoReason.statusOk, message: 'Статус обновлён');
  }

  @override
  Future<StockReply> isFeatureEnabled(int featureToggleId) async {
    await mockLatency();
    final enabled = _backend.isFeatureEnabledFor(featureToggleId);
    return StockReply(
      errInfoReason: ErrInfoReason.statusOk,
      message: enabled ? 'enabled' : 'disabled',
    );
  }

  @override
  Future<IsUserInFeatureReply> isUserInFeature(IsUserInFeatureRequest request) async {
    await mockLatency();
    return _backend.isUserInFeature(
      userId: request.userId,
      namespace: request.namespace,
      platform: request.platform,
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
