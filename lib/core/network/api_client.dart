import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../config/app_config.dart';
import 'auth_headers_interceptor.dart';
import 'cookie_jar_factory.dart';
import 'refresh_on_401_interceptor.dart';


class ApiClient {
  ApiClient._(this.dio);

  static Future<ApiClient> create({
    AppConfig config = AppConfig.dev,
  }) async {
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
