class AppEnv {
  AppEnv._();

  static const String environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static const String variant = String.fromEnvironment(
    'APP_VARIANT',
    defaultValue: 'app',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  static const String adminApiBaseUrl = String.fromEnvironment(
    'ADMIN_API_BASE_URL',
    defaultValue: 'https://admin-api.example.com',
  );

  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Anti-Theft Guard',
  );

  static const String adminAppName = String.fromEnvironment(
    'ADMIN_APP_NAME',
    defaultValue: 'Anti-Theft Guard Admin',
  );

  static const bool isAdmin = variant == 'admin';
  static const bool isProduction = environment == 'production';
  static const String displayName = isAdmin ? adminAppName : appName;
}
