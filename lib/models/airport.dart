class Airport {
  final String code;
  final String name;
  final String city;
  final String state;

  const Airport({
    required this.code,
    required this.name,
    required this.city,
    required this.state,
  });

  String get displayName => '$city ($code)';

  String get searchText => '$city $name $code $state'.toLowerCase();
}
