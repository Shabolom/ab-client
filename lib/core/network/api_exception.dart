import 'package:dio/dio.dart';

import '../../common/models/err_info_reason.dart';

/// A normalized failure for every call made through [ApiClient].
///
/// The gateway reports business errors two ways: a non-2xx HTTP status, or
/// a 200 response whose body carries `err_info_reason != STATUS_OK`. Both
/// are surfaced through this single type so callers don't need to know
/// which one happened.
class ApiException implements Exception {
  ApiException({
    required this.message,
    this.statusCode,
    this.errInfoReason,
    this.cause,
  });

  factory ApiException.fromDioException(DioException e) {
    return ApiException(
      message: _messageFor(e),
      statusCode: e.response?.statusCode,
      cause: e,
    );
  }

  /// HTTP status code, when the failure came from a non-2xx response.
  final int? statusCode;

  /// Business error reason, when the failure came from a 2xx response body.
  final ErrInfoReason? errInfoReason;

  final String message;

  final Object? cause;

  bool get isUnauthorized => statusCode == 401;

  static String _messageFor(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'The request timed out.';
      case DioExceptionType.connectionError:
        return 'Could not reach the server.';
      default:
        return e.message ?? 'Unexpected network error.';
    }
  }

  @override
  String toString() => 'ApiException(statusCode: $statusCode, '
      'errInfoReason: $errInfoReason, message: $message)';
}
