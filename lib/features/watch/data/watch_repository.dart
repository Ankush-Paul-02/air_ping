import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../models/flight_watch.dart';

class WatchRepository {
  WatchRepository({required ApiClient apiClient}) : _dio = apiClient.dio;

  final Dio _dio;

  Future<List<FlightWatch>> getWatches() async {
    final response = await _dio.get('/api/v1/watches');

    final data = response.data;

    if (data is! List) {
      throw const FormatException('Invalid watches response.');
    }

    return data
        .map(
          (item) =>
              FlightWatch.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<FlightWatch> createWatch(FlightWatch watch) async {
    final response = await _dio.post(
      '/api/v1/watches',
      data: watch.toCreateJson(),
    );

    if (response.data is! Map) {
      throw const FormatException('Invalid watch response.');
    }

    return FlightWatch.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<void> updateWatchStatus({
    required String id,
    required bool isActive,
  }) async {
    await _dio.patch('/api/v1/watches/$id', data: {'active': isActive});
  }

  Future<void> deleteWatch(String id) async {
    await _dio.delete('/api/v1/watches/$id');
  }
}
