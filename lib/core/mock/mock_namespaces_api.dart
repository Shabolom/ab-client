import '../../common/models/err_info_reason.dart';
import '../../common/models/stock_reply.dart';
import '../../features/namespaces/data/models/models.dart';
import '../../features/namespaces/data/namespaces_api.dart';
import 'mock_backend.dart';

class MockNamespacesApi implements NamespacesApi {
  MockNamespacesApi(this._backend);

  final MockBackend _backend;

  @override
  Future<StockReply> createNamespace(CreateNamespaceRequest request) async {
    await mockLatency();
    _backend.createNamespace(name: request.name, description: request.description);
    return const StockReply(errInfoReason: ErrInfoReason.statusOk, message: 'Неймспейс создан');
  }

  @override
  Future<GetNamespacesResponse> getNamespaces() async {
    await mockLatency();
    return GetNamespacesResponse(message: 'OK', namespaces: List.of(_backend.namespaces));
  }

  @override
  Future<GetNamespaceByIDResponse> getNamespaceById(int id) async {
    await mockLatency();
    final namespace = _backend.namespaces.where((n) => n.id == id).firstOrNull;
    if (namespace == null) {
      throw StateError('Namespace $id not found');
    }
    return GetNamespaceByIDResponse(message: 'OK', namespace: namespace);
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
