import 'core/config/app_config.dart';
import 'core/mock/mock_auth_api.dart';
import 'core/mock/mock_backend.dart';
import 'core/mock/mock_custom_params_api.dart';
import 'core/mock/mock_experiments_api.dart';
import 'core/mock/mock_feature_toggles_api.dart';
import 'core/mock/mock_layers_api.dart';
import 'core/mock/mock_namespaces_api.dart';
import 'core/mock/mock_users_api.dart';
import 'core/network/api_client.dart';
import 'features/auth/data/auth_api.dart';
import 'features/auth/data/gateway_auth_api.dart';
import 'features/custom_params/data/custom_params_api.dart';
import 'features/custom_params/data/gateway_custom_params_api.dart';
import 'features/experiments/data/experiments_api.dart';
import 'features/experiments/data/gateway_experiments_api.dart';
import 'features/feature_toggles/data/feature_toggles_api.dart';
import 'features/feature_toggles/data/gateway_feature_toggles_api.dart';
import 'features/layers/data/gateway_layers_api.dart';
import 'features/layers/data/layers_api.dart';
import 'features/namespaces/data/gateway_namespaces_api.dart';
import 'features/namespaces/data/namespaces_api.dart';
import 'features/users/data/gateway_users_api.dart';
import 'features/users/data/users_api.dart';

class GatewayClient {
  GatewayClient._(
    this.auth,
    this.users,
    this.experiments,
    this.namespaces,
    this.layers,
    this.customParams,
    this.featureToggles, {
    required this.isMock,
  });

  static Future<GatewayClient> create({AppConfig config = AppConfig.dev}) async {
    if (AppConfig.useMockApi) {
      final backend = MockBackend();
      return GatewayClient._(
        MockAuthApi(backend),
        MockUsersApi(backend),
        MockExperimentsApi(backend),
        MockNamespacesApi(backend),
        MockLayersApi(backend),
        MockCustomParamsApi(backend),
        MockFeatureTogglesApi(backend),
        isMock: true,
      );
    }

    final apiClient = await ApiClient.create(config: config);
    return GatewayClient._(
      GatewayAuthApi(apiClient),
      GatewayUsersApi(apiClient),
      GatewayExperimentsApi(apiClient),
      GatewayNamespacesApi(apiClient),
      GatewayLayersApi(apiClient),
      GatewayCustomParamsApi(apiClient),
      GatewayFeatureTogglesApi(apiClient),
      isMock: false,
    );
  }

  final AuthApi auth;
  final UsersApi users;
  final ExperimentsApi experiments;
  final NamespacesApi namespaces;
  final LayersApi layers;
  final CustomParamsApi customParams;
  final FeatureTogglesApi featureToggles;

  final bool isMock;
}
