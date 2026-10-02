/// Runtime configuration for talking to the gateway.
///
/// The gateway has no versioned base path beyond `/v1`, which each API
/// class appends itself, so [baseUrl] should be scheme+host+port only.
class AppConfig {
  const AppConfig({required this.baseUrl});

  final String baseUrl;

  /// Gateway URL, overridable at build time with
  /// `--dart-define=API_BASE_URL=...`. The default matches ab-gate-way's
  /// `APP_PORT` in `build/local/.env`. An empty value on web means "same
  /// origin as the page" (app served behind a proxy to the gateway).
  static const AppConfig dev = AppConfig(
    baseUrl: String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8086'),
  );

  /// Feature flag: when true, [GatewayClient] wires up in-memory mock
  /// implementations of every `*Api` instead of talking to the real
  /// gateway over HTTP. Set at build/run time, since Dart env values are
  /// compile-time constants:
  ///
  /// ```
  /// flutter run -d chrome --dart-define=USE_MOCK_API=true
  /// flutter build web --dart-define=USE_MOCK_API=true
  /// ```
  ///
  /// Defaults to false (talk to the real backend) when not passed.
  static const bool useMockApi = bool.fromEnvironment('USE_MOCK_API');

  /// Hides the mock-mode hints (the "DEMO" corner ribbon and the demo
  /// credentials card on the login screen) while keeping the mock backend,
  /// e.g. for recording product demos: `--dart-define=HIDE_DEMO_HINTS=true`.
  static const bool hideDemoHints = bool.fromEnvironment('HIDE_DEMO_HINTS');
}
