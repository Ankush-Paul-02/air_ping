import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/airping_app.dart';
import 'providers/airport_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/saved_provider.dart';
import 'providers/watch_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => AirportProvider()),
        ChangeNotifierProvider(create: (_) => WatchProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => SavedProvider()),
      ],
      child: const AirPingApp(),
    ),
  );
}
