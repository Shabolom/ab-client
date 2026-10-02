
class AppConfig {
  const AppConfig({required this.baseUrl});

  final String baseUrl;

  static const AppConfig dev = AppConfig(
    baseUrl: String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8086'),
  );

  static const bool useMockApi = bool.fromEnvironment('USE_MOCK_API');

  static const bool hideDemoHints = bool.fromEnvironment('HIDE_DEMO_HINTS');
}
