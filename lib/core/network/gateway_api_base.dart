import 'package:dio/dio.dart';

import 'api_client.dart';
import 'api_exception.dart';

abstract class GatewayApiBase {
  const GatewayApiBase(this._client);

  final ApiClient _client;

  Dio get dio => _client.dio;

  Future<T> execute<T>(
    Future<Response<dynamic>> Function() call,
    T Function(Map<String, dynamic> json) parse,
  ) async {
    try {
      final response = await call();
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw ApiException(
          message: 'Gateway returned an unexpected response body.',
          statusCode: response.statusCode,
        );
      }
      return parse(data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
