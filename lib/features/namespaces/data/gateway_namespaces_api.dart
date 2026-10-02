import '../../../common/models/stock_reply.dart';
import '../../../core/network/gateway_api_base.dart';
import 'models/models.dart';
import 'namespaces_api.dart';

class GatewayNamespacesApi extends GatewayApiBase implements NamespacesApi {
  const GatewayNamespacesApi(super.client);

  @override
  Future<StockReply> createNamespace(CreateNamespaceRequest request) {
    return execute(
      () => dio.post('/v1/namespaces', data: request.toJson()),
      StockReply.fromJson,
    );
  }

  @override
  Future<GetNamespacesResponse> getNamespaces() {
    return execute(() => dio.get('/v1/namespaces'), GetNamespacesResponse.fromJson);
  }

  @override
  Future<GetNamespaceByIDResponse> getNamespaceById(int id) {
    return execute(
      () => dio.get('/v1/namespaces/$id'),
      GetNamespaceByIDResponse.fromJson,
    );
  }
}
