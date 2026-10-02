import 'package:dio/dio.dart';

class AuthHeadersInterceptor extends Interceptor {
  static const _accessHeader = 'authorization';
  static const _refreshHeader = 'refresh-token';

  String? _accessToken;
  String? _refreshToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final access = _accessToken;
    final refresh = _refreshToken;
    if (access != null) options.headers['Authorization'] = access;
    if (refresh != null) options.headers['Refresh-Token'] = refresh;
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.path == '/v1/auth/logout') {
      _accessToken = null;
      _refreshToken = null;
    } else {
      _capture(response.headers);
    }
    handler.next(response);
  }

  void _capture(Headers headers) {
    final access = headers.value(_accessHeader);
    final refresh = headers.value(_refreshHeader);
    if (access != null && access.isNotEmpty) _accessToken = access;
    if (refresh != null && refresh.isNotEmpty) _refreshToken = refresh;
  }
}
