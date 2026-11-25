import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../features/watch/data/watch_repository.dart';
import '../models/flight_watch.dart';

class WatchProvider extends ChangeNotifier {
  WatchProvider({required this._repository});

  final WatchRepository _repository;
  final List<FlightWatch> _watches = [];

  bool _isLoading = false;
  bool _isCreating = false;
  String? _error;

  List<FlightWatch> get watches => List.unmodifiable(_watches);

  List<FlightWatch> get activeWatches =>
      _watches.where((watch) => watch.isActive).toList();

  bool get isLoading => _isLoading;

  bool get isCreating => _isCreating;

  String? get error => _error;

  Future<bool> loadWatches() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.getWatches();

      _watches
        ..clear()
        ..addAll(result);

      return true;
    } catch (e) {
      _error = _messageFromError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createWatch({
    required String origin,
    required String destination,
    required String originCode,
    required String destinationCode,
    required DateTime startDate,
    required DateTime endDate,
    required double targetPrice,
    required String tripType,
  }) async {
    _isCreating = true;
    _error = null;
    notifyListeners();

    try {
      final request = FlightWatch(
        id: '',
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

      final created = await _repository.createWatch(request);
      _watches.insert(0, created);

      return true;
    } catch (e) {
      _error = _messageFromError(e);
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  Future<bool> deleteWatch(String id) async {
    _error = null;

    try {
      await _repository.deleteWatch(id);
      _watches.removeWhere((watch) => watch.id == id);
      return true;
    } catch (e) {
      _error = _messageFromError(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> pauseWatch(String id) async {
    final index = _watches.indexWhere((watch) => watch.id == id);

    if (index == -1) return false;

    final watch = _watches[index];
    final newStatus = !watch.isActive;

    _error = null;

    try {
      await _repository.updateWatchStatus(id: id, isActive: newStatus);

      _watches[index] = watch.copyWith(isActive: newStatus);
      return true;
    } catch (e) {
      _error = _messageFromError(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  String _messageFromError(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;

      if (statusCode == 401) {
        return 'Please sign in again to continue.';
      }

      if (statusCode == 400) {
        return 'Please check the flight watch details.';
      }

      if (statusCode == 404) {
        return 'Flight watch not found.';
      }

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError) {
        return 'Unable to connect to the server. Please try again.';
      }
    }

    return 'Something went wrong. Please try again.';
  }
}
