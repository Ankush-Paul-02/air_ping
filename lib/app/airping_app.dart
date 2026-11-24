import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'router.dart';

class AirPingApp extends StatelessWidget {
  const AirPingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AirPing',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
