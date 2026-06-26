import 'package:flutter/material.dart';

import '../core/config/app_env.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'auth/web_auth_state.dart';
import 'constants/admin_routes.dart';
import 'pages/admin_login_page.dart';
import 'shell/admin_navigation_shell.dart';
import 'state/admin_navigation_state.dart';

/// Role-aware web portal application.
///
/// Now serves two roles from one app: [UserRole.admin] (fleet console) and
/// [UserRole.user] (single personal device). Starts at the login screen; the
/// shell branches by role after authentication.
class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WebAuthProvider(
      authState: WebAuthState(),
      child: AdminNavigationProvider(
        navigationState: AdminNavigationState(),
        child: MaterialApp(
          title: '${AppEnv.displayName} Web',
          debugShowCheckedModeBanner: false,

          // Initial route - start at login (role resolved there)
          initialRoute: AdminRoutes.login,

          // Named routes for all admin pages
          routes: _buildRoutes(),

          // Theme configuration
          theme: _buildTheme(),

          // Error handler for unknown routes
          onUnknownRoute: _buildUnknownRouteHandler,

          // Builder for global error handling and navigation setup
          builder: (context, child) {
            return _NavigationErrorHandler(child: child ?? const SizedBox.shrink());
          },
        ),
      ),
    );
  }

  /// Build named routes for navigation
  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      // Login (entry point for the portal)
      AdminRoutes.login: (context) => const AdminLoginPage(),
      // All shell routes point to the same shell with IndexedStack.
      // The shell internally manages which page is displayed and branches by role.
      AdminRoutes.root: (context) => const AdminNavigationShell(),
      AdminRoutes.overview: (context) => const AdminNavigationShell(),
      AdminRoutes.devices: (context) => const AdminNavigationShell(),
      AdminRoutes.surveillance: (context) => const AdminNavigationShell(),
      AdminRoutes.location: (context) => const AdminNavigationShell(),
      AdminRoutes.logs: (context) => const AdminNavigationShell(),
      AdminRoutes.security: (context) => const AdminNavigationShell(),
      AdminRoutes.sms: (context) => const AdminNavigationShell(),
      AdminRoutes.battery: (context) => const AdminNavigationShell(),
      AdminRoutes.settings: (context) => const AdminNavigationShell(),
    };
  }

  /// Build theme configuration
  ThemeData _buildTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.danger,
      ),

      // Text theme
      textTheme: _buildTextTheme(),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        titleTextStyle: AppTextStyles.headlineMedium,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.surfaceElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// Build text theme
  TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      headlineSmall: AppTextStyles.headlineSmall,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    );
  }

  /// Handler for unknown routes
  Route<dynamic>? _buildUnknownRouteHandler(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => _AdminErrorPage(route: settings.name),
    );
  }
}

// ── Error Handling Widget ─────────────────────────────────────────────────────────

/// Error handler widget that catches navigation errors
class _NavigationErrorHandler extends StatefulWidget {
  final Widget child;

  const _NavigationErrorHandler({required this.child});

  @override
  State<_NavigationErrorHandler> createState() => _NavigationErrorHandlerState();
}

class _NavigationErrorHandlerState extends State<_NavigationErrorHandler> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check if the current route is valid
    final route = ModalRoute.of(context)?.settings.name;
    if (route != null && !AdminRoutes.isValidRoute(route)) {
      _handleInvalidRoute(route);
    }
  }

  void _handleInvalidRoute(String route) {
    debugPrint('[AdminApp] Invalid route detected: $route');

    // Show error message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid route: $route. Redirecting to overview.'),
            backgroundColor: AppColors.danger,
            duration: const Duration(seconds: 3),
          ),
        );

        // Redirect to overview after a delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed(AdminRoutes.overview);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// ── Error Page Widget ────────────────────────────────────────────────────────────

/// Error page displayed when navigating to unknown routes
class _AdminErrorPage extends StatelessWidget {
  final String? route;

  const _AdminErrorPage({this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.danger.withOpacity(0.3),
                  ),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 40,
                  color: AppColors.danger,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Page Not Found',
                style: AppTextStyles.headlineLarge,
              ),
              const SizedBox(height: 12),
              Text(
                route != null
                    ? 'The route "$route" does not exist in the admin module.'
                    : 'The requested page could not be found.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                    AdminRoutes.overview,
                  );
                },
                icon: const Icon(Icons.home_rounded),
                label: const Text('Return to Overview'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
