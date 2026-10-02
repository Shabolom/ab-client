import 'package:dio/dio.dart';

import 'api_client.dart';
import 'api_exception.dart';

/// Shared plumbing for every feature's `*Api` class: turns a [DioException]
/// into an [ApiException] and gives subclasses a one-line way to run a
/// call and decode its body.
abstract class GatewayApiBase {
  const GatewayApiBase(this._client);

  final ApiClient _client;

  Dio get dio => _client.dio;

  /// Runs [call], decodes a non-null response body with [parse], and maps
  /// any [DioException] to an [ApiException].
  ///
  /// The gateway always returns a JSON object on 2xx for the endpoints
  /// this client covers, so a null body here means something upstream is
  /// broken rather than a business error — it is surfaced as-is instead of
  /// being papered over.
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
