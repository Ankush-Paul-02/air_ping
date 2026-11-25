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

  factory FlightWatch.fromJson(Map<String, dynamic> json) {
    return FlightWatch(
      id: json['id'].toString(),
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      originCode: json['originCode'] as String,
      destinationCode: json['destinationCode'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      targetPrice: (json['targetPrice'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num?)?.toDouble() ?? 0.0,
      tripType: json['tripType'] as String,
      isActive: (json['isActive'] ?? json['active'] ?? true) as bool,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'origin': origin,
      'destination': destination,
      'originCode': originCode,
      'destinationCode': destinationCode,
      'startDate': _formatDate(startDate),
      'endDate': _formatDate(endDate),
      'targetPrice': targetPrice,
      'tripType': tripType,
    };
  }

  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

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
