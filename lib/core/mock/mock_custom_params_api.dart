import '../../common/models/err_info_reason.dart';
import '../../common/models/stock_reply.dart';
import '../../features/custom_params/data/custom_params_api.dart';
import '../../features/custom_params/data/models/models.dart';
import 'mock_backend.dart';

class MockCustomParamsApi implements CustomParamsApi {
  MockCustomParamsApi(this._backend);

  final MockBackend _backend;

  @override
  Future<StockReply> createCustomParam(CreateCustomParamRequest request) async {
    await mockLatency();
    _backend.createCustomParam(
      name: request.name,
      namespaceId: request.namespaceId,
      type: request.type,
    );
    return const StockReply(
      errInfoReason: ErrInfoReason.statusOk,
      message: 'Параметр создан',
    );
  }

  @override
  Future<GetCustomParamsResponse> getCustomParams() async {
    await mockLatency();
    return GetCustomParamsResponse(message: 'OK', customParams: List.of(_backend.customParams));
  }

  @override
  Future<GetCustomParamByIDResponse> getCustomParamById(int id) async {
    await mockLatency();
    final param = _backend.customParams.where((p) => p.id == id).firstOrNull;
    if (param == null) {
      throw StateError('Custom param $id not found');
    }
    return GetCustomParamByIDResponse(message: 'OK', customParam: param);
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
