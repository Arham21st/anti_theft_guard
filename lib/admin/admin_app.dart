import 'package:flutter/material.dart';

import '../core/config/app_env.dart';
import '../core/theme/app_colors.dart';
import 'admin_shell.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppEnv.displayName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.surface,
          error: AppColors.danger,
        ),
      ),
      home: const AdminShell(),
    );
  }
}
