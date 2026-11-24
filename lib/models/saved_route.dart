class SavedRoute {
  final String id;
  final String origin;
  final String destination;
  final String originCode;
  final String destinationCode;
  final DateTime savedAt;

  const SavedRoute({
    required this.id,
    required this.origin,
    required this.destination,
    required this.originCode,
    required this.destinationCode,
    required this.savedAt,
  });
}
