import '../../../common/models/stock_reply.dart';
import '../../../core/network/gateway_api_base.dart';
import 'feature_toggles_api.dart';
import 'models/request_models.dart';
import 'models/response_models.dart';

class GatewayFeatureTogglesApi extends GatewayApiBase implements FeatureTogglesApi {
  const GatewayFeatureTogglesApi(super.client);

  @override
  Future<StockReply> createFeatureToggle(CreateFeatureToggleRequest request) {
    return execute(
      () => dio.post('/v1/feature-toggles', data: request.toJson()),
      StockReply.fromJson,
    );
  }

  @override
  Future<GetFeatureTogglesResponse> getFeatureToggles() {
    return execute(
      () => dio.get('/v1/feature-toggles'),
      GetFeatureTogglesResponse.fromJson,
    );
  }

  @override
  Future<GetFeatureToggleByIDResponse> getFeatureToggleById(int id) {
    return execute(
      () => dio.get('/v1/feature-toggles/$id'),
      GetFeatureToggleByIDResponse.fromJson,
    );
  }

  @override
  Future<StockReply> updateFeatureToggleRollout(
    int featureToggleId,
    UpdateFeatureToggleRolloutRequest request,
  ) {
    return execute(
      () => dio.patch(
        '/v1/feature-toggles/$featureToggleId/rollout',
        data: request.toJson(),
      ),
      StockReply.fromJson,
    );
  }

  @override
  Future<StockReply> setFeatureToggleStatus(
    int featureToggleId,
    SetFeatureToggleStatusRequest request,
  ) {
    return execute(
      () => dio.post(
        '/v1/feature-toggles/$featureToggleId/status',
        data: request.toJson(),
      ),
      StockReply.fromJson,
    );
  }

  @override
  Future<StockReply> isFeatureEnabled(int featureToggleId) {
    return execute(
      () => dio.get('/v1/feature-toggles/$featureToggleId/enabled'),
      StockReply.fromJson,
    );
  }

  @override
  Future<IsUserInFeatureReply> isUserInFeature(IsUserInFeatureRequest request) {
    return execute(
      () => dio.post('/v1/feature-toggles/user', data: request.toJson()),
      IsUserInFeatureReply.fromJson,
    );
  }
}
