import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';

/// Builds the cookie store used to hold the session cookies the gateway
/// sets on login/refresh (`AuthReply` carries no token in its body — the
/// gate-way's auth adapter reads/writes tokens as cookies, see
/// `pkg/utils/parse_token.go` and `replase-metadata.go` on the backend).
///
/// On web, the browser already owns cookies for same-origin requests, so a
/// [Dio]-level jar would just duplicate (and could fight with) it; a plain
/// in-memory jar is used there purely to satisfy the interceptor's API and
/// is never actually relied on.
Future<CookieJar> createCookieJar() async {
  if (kIsWeb) {
    return CookieJar();
  }
  final dir = await getApplicationSupportDirectory();
  return PersistCookieJar(storage: FileStorage('${dir.path}/.cookies/'));
}
