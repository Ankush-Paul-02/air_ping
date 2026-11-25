import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/airping_app.dart';
import 'core/network/api_client.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/watch/data/watch_repository.dart';
import 'firebase_options.dart';
import 'providers/airport_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/saved_provider.dart';
import 'providers/watch_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final apiClient = ApiClient();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => AirportProvider()),
        ChangeNotifierProvider(
          create: (_) =>
              WatchProvider(repository: WatchRepository(apiClient: apiClient))
                ..loadWatches(),
        ),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => SavedProvider()),
      ],
      child: const AirPingApp(),
    ),
  );
}
