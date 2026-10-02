import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../config/app_config.dart';
import 'auth_headers_interceptor.dart';
import 'cookie_jar_factory.dart';
import 'refresh_on_401_interceptor.dart';

/// Thin wrapper around [Dio] shared by every feature's `*Api` class.
///
/// Owns the pieces that are cross-cutting: base URL, session cookies, and
/// transparent 401 refresh. It deliberately does not know about any
/// endpoint or response shape — that stays in each feature's own API class,
/// so this class has no reason to change when an endpoint's schema does.
class ApiClient {
  ApiClient._(this.dio);

  static Future<ApiClient> create({
    AppConfig config = AppConfig.dev,
  }) async {
    // An empty base URL on web means "same origin as the page", for when the
    // app is served behind a reverse proxy in front of the gateway.
    final baseUrl = config.baseUrl.isEmpty && kIsWeb ? Uri.base.origin : config.baseUrl;
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    final cookieJar = await createCookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
    dio.interceptors.add(AuthHeadersInterceptor());
    dio.interceptors.add(RefreshOn401Interceptor(dio));

    return ApiClient._(dio);
  }

  final Dio dio;
}
