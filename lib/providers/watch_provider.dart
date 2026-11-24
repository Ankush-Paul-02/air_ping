import 'package:flutter/material.dart';

import '../models/flight_watch.dart';

class WatchProvider extends ChangeNotifier {
  final List<FlightWatch> _watches = [];

  List<FlightWatch> get watches => List.unmodifiable(_watches);

  List<FlightWatch> get activeWatches =>
      _watches.where((watch) => watch.isActive).toList();

  void createWatch({
    required String origin,
    required String destination,
    required String originCode,
    required String destinationCode,
    required DateTime startDate,
    required DateTime endDate,
    required double targetPrice,
    required String tripType,
  }) {
    final watch = FlightWatch(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      origin: origin,
      destination: destination,
      originCode: originCode,
      destinationCode: destinationCode,
      startDate: startDate,
      endDate: endDate,
      targetPrice: targetPrice,
      currentPrice: 0,
      tripType: tripType,
    );

    _watches.add(watch);
    notifyListeners();
  }

  void deleteWatch(String id) {
    _watches.removeWhere((watch) => watch.id == id);
    notifyListeners();
  }

  void pauseWatch(String id) {
    final index = _watches.indexWhere((watch) => watch.id == id);

    if (index == -1) return;

    final watch = _watches[index];

    _watches[index] = FlightWatch(
      id: watch.id,
      origin: watch.origin,
      destination: watch.destination,
      originCode: watch.originCode,
      destinationCode: watch.destinationCode,
      startDate: watch.startDate,
      endDate: watch.endDate,
      targetPrice: watch.targetPrice,
      currentPrice: watch.currentPrice,
      tripType: watch.tripType,
      isActive: !watch.isActive,
    );

    notifyListeners();
  }
}
