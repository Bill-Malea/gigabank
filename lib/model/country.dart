class Country {
  final String name;
  final String flagUrl;

  Country({required this.name, required this.flagUrl});

  @override
  String toString() {
    return name;
  }
}
