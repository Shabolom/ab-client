import '../../../common/controllers/async_list_controller.dart';
import '../../../core/network/api_exception.dart';
import '../data/feature_toggles_api.dart';
import '../data/models/feature_toggle_status.dart';
import '../data/models/request_models.dart';
import '../data/models/response_models.dart';

class FeatureTogglesController {
  FeatureTogglesController(this._api)
      : list = AsyncListController<GetFeatureToggle>(() async {
          final response = await _api.getFeatureToggles();
          return response.featureToggles;
        });

  final FeatureTogglesApi _api;
  final AsyncListController<GetFeatureToggle> list;

  Future<String?> create(CreateFeatureToggleRequest request) async {
    try {
      final reply = await _api.createFeatureToggle(request);
      if (!reply.isOk) {
        return reply.message.isNotEmpty ? reply.message : 'Не удалось создать фичу';
      }
      await list.load();
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  Future<String?> updateRollout(
    int featureToggleId,
    UpdateFeatureToggleRolloutRequest request,
  ) async {
    try {
      final reply = await _api.updateFeatureToggleRollout(featureToggleId, request);
      if (!reply.isOk) {
        return reply.message.isNotEmpty ? reply.message : 'Не удалось обновить rollout';
      }
      await list.load();
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  Future<String?> setStatus(int featureToggleId, FeatureToggleStatus status) async {
    try {
      final reply = await _api.setFeatureToggleStatus(
        featureToggleId,
        SetFeatureToggleStatusRequest(status: status),
      );
      if (!reply.isOk) {
        return reply.message.isNotEmpty ? reply.message : 'Не удалось изменить статус';
      }
      await list.load();
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  Future<IsUserInFeatureReply> isUserInFeature(IsUserInFeatureRequest request) {
    return _api.isUserInFeature(request);
  }

  void dispose() => list.dispose();
}
