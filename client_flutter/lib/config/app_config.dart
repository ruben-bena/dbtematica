class AppConfig {
  AppConfig._();

  static const String serverBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
    // defaultValue: 'https://rbellidonavarro.ieti.site',
  );
}
