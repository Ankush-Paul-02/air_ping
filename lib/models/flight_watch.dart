class FlightWatch {
  final String id;
  final String origin;
  final String destination;
  final String originCode;
  final String destinationCode;
  final DateTime startDate;
  final DateTime endDate;
  final double targetPrice;
  final double currentPrice;
  final String tripType;
  final bool isActive;

  const FlightWatch({
    required this.id,
    required this.origin,
    required this.destination,
    required this.originCode,
    required this.destinationCode,
    required this.startDate,
    required this.endDate,
    required this.targetPrice,
    required this.currentPrice,
    required this.tripType,
    this.isActive = true,
  });

  FlightWatch copyWith({
    String? id,
    String? origin,
    String? destination,
    String? originCode,
    String? destinationCode,
    DateTime? startDate,
    DateTime? endDate,
    double? targetPrice,
    double? currentPrice,
    String? tripType,
    bool? isActive,
  }) {
    return FlightWatch(
      id: id ?? this.id,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      originCode: originCode ?? this.originCode,
      destinationCode: destinationCode ?? this.destinationCode,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      targetPrice: targetPrice ?? this.targetPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      tripType: tripType ?? this.tripType,
      isActive: isActive ?? this.isActive,
    );
  }
}
