import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/app_bottom_nav.dart';
import '../../../providers/navigation_provider.dart';
import '../../alerts/presentation/alerts_screen.dart';
import '../../explore/presentation/explore_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../saved/presentation/saved_screen.dart';
import '../../tracking/presentation/tracking_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const List<Widget> _screens = [
    ExploreScreen(),
    TrackingScreen(),
    AlertsScreen(),
    SavedScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigation, _) {
        return Scaffold(
          body: IndexedStack(
            index: navigation.currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: AppBottomNav(
            currentIndex: navigation.currentIndex,
            onTap: navigation.setIndex,
          ),
        );
      },
    );
  }
}
