import '../../../common/models/stock_reply.dart';
import 'models/request_models.dart';
import 'models/response_models.dart';

abstract class FeatureTogglesApi {
  Future<StockReply> createFeatureToggle(CreateFeatureToggleRequest request);

  Future<GetFeatureTogglesResponse> getFeatureToggles();

  Future<GetFeatureToggleByIDResponse> getFeatureToggleById(int id);

  Future<StockReply> updateFeatureToggleRollout(
    int featureToggleId,
    UpdateFeatureToggleRolloutRequest request,
  );

  Future<StockReply> setFeatureToggleStatus(
    int featureToggleId,
    SetFeatureToggleStatusRequest request,
  );

  /// The gateway replies with a [StockReply] here rather than a typed
  /// boolean — `err_info_reason`/`message` is where the enabled/disabled
  /// result actually lives, so check the backend's real payload before
  /// wiring this into UI logic.
  Future<StockReply> isFeatureEnabled(int featureToggleId);

  Future<IsUserInFeatureReply> isUserInFeature(IsUserInFeatureRequest request);
}
