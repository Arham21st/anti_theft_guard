import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'admin_app.dart';

void main() {
  // Use path URL strategy on web (removes the leading '#' from URLs) so routes
  // are clean (e.g. /admin/login) and deep links/refreshes work on hosts like
  // Vercel when paired with an SPA rewrite.
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AdminApp());
}
