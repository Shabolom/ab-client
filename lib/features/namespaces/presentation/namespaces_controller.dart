import '../../../common/controllers/async_list_controller.dart';
import '../../../core/network/api_exception.dart';
import '../data/models/models.dart';
import '../data/namespaces_api.dart';

class NamespacesController {
  NamespacesController(this._api)
      : list = AsyncListController<GetNamespace>(() async {
          final response = await _api.getNamespaces();
          return response.namespaces;
        });

  final NamespacesApi _api;
  final AsyncListController<GetNamespace> list;

  /// Returns an error message on failure, or `null` on success.
  Future<String?> create(CreateNamespaceRequest request) async {
    try {
      final reply = await _api.createNamespace(request);
      if (!reply.isOk) {
        return reply.message.isNotEmpty ? reply.message : 'Не удалось создать неймспейс';
      }
      await list.load();
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  void dispose() => list.dispose();
}
