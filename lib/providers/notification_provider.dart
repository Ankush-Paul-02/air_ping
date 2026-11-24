import 'package:flutter/foundation.dart';

import '../models/price_alert.dart';

class NotificationProvider extends ChangeNotifier {
  final List<PriceAlert> _alerts = [];

  List<PriceAlert> get alerts => List.unmodifiable(_alerts);

  int get alertCount => _alerts.length;

  int get targetReachedCount =>
      _alerts.where((alert) => alert.targetReached).length;

  void addAlert(PriceAlert alert) {
    _alerts.insert(0, alert);
    notifyListeners();
  }

  void clearAlerts() {
    _alerts.clear();
    notifyListeners();
  }

  void removeAlert(String id) {
    _alerts.removeWhere((alert) => alert.id == id);
    notifyListeners();
  }
}
