import '../../../common/models/stock_reply.dart';
import 'models/models.dart';

abstract class NamespacesApi {
  Future<StockReply> createNamespace(CreateNamespaceRequest request);

  Future<GetNamespacesResponse> getNamespaces();

  Future<GetNamespaceByIDResponse> getNamespaceById(int id);
}
