import 'package:flutter/foundation.dart';

import '../models/saved_route.dart';

class SavedProvider extends ChangeNotifier {
  final List<SavedRoute> _savedRoutes = [];

  List<SavedRoute> get savedRoutes => List.unmodifiable(_savedRoutes);

  int get count => _savedRoutes.length;

  bool isSaved(String originCode, String destinationCode) {
    return _savedRoutes.any(
      (route) =>
          route.originCode == originCode &&
          route.destinationCode == destinationCode,
    );
  }

  void toggleSaved({
    required String origin,
    required String destination,
    required String originCode,
    required String destinationCode,
  }) {
    final existingIndex = _savedRoutes.indexWhere(
      (route) =>
          route.originCode == originCode &&
          route.destinationCode == destinationCode,
    );

    if (existingIndex != -1) {
      _savedRoutes.removeAt(existingIndex);
    } else {
      _savedRoutes.insert(
        0,
        SavedRoute(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          origin: origin,
          destination: destination,
          originCode: originCode,
          destinationCode: destinationCode,
          savedAt: DateTime.now(),
        ),
      );
    }

    notifyListeners();
  }

  void removeSaved(String id) {
    _savedRoutes.removeWhere((route) => route.id == id);
    notifyListeners();
  }

  void clearAll() {
    _savedRoutes.clear();
    notifyListeners();
  }
}
