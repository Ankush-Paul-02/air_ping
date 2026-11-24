class PriceAlert {
  final String id;
  final String origin;
  final String destination;
  final String originCode;
  final String destinationCode;
  final double previousPrice;
  final double currentPrice;
  final double targetPrice;
  final DateTime detectedAt;

  const PriceAlert({
    required this.id,
    required this.origin,
    required this.destination,
    required this.originCode,
    required this.destinationCode,
    required this.previousPrice,
    required this.currentPrice,
    required this.targetPrice,
    required this.detectedAt,
  });

  double get savings => previousPrice - currentPrice;

  double get percentageDrop {
    if (previousPrice <= 0) return 0;
    return (savings / previousPrice) * 100;
  }

  bool get targetReached => currentPrice <= targetPrice;
}
