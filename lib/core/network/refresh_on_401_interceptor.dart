import 'dart:async';

import 'package:dio/dio.dart';

class RefreshOn401Interceptor extends Interceptor {
  RefreshOn401Interceptor(this._dio);

  static const _retriedKey = '__retried_after_refresh';

  static const _exemptPaths = <String>{
    '/v1/auth/login',
    '/v1/auth/register',
    '/v1/auth/refresh',
    '/v1/auth/logout',
  };

  final Dio _dio;
  Completer<bool>? _refreshing;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    final alreadyRetried = request.extra[_retriedKey] == true;

    if (!isUnauthorized ||
        alreadyRetried ||
        _exemptPaths.contains(request.path)) {
      return handler.next(err);
    }

    final refreshed = await _refreshOnce();
    if (!refreshed) {
      return handler.next(err);
    }

    try {
      final retryOptions = request.copyWith(extra: {
        ...request.extra,
        _retriedKey: true,
      });
      final response = await _dio.fetch(retryOptions);
      return handler.resolve(response);
    } on DioException catch (retryError) {
      return handler.next(retryError);
    }
  }

  Future<bool> _refreshOnce() {
    final inFlight = _refreshing;
    if (inFlight != null) {
      return inFlight.future;
    }

    final completer = Completer<bool>();
    _refreshing = completer;
    _dio.post<void>('/v1/auth/refresh').then((_) {
      completer.complete(true);
    }).catchError((_) {
      completer.complete(false);
    }).whenComplete(() {
      _refreshing = null;
    });
    return completer.future;
  }
}
