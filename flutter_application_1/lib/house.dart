class House {
  final String name;
  final String region;
  final String coatOfArms;
  final String words;
  final List<dynamic> titles;

  const House({
    required this.name,
    required this.region,
    required this.coatOfArms,
    required this.words,
    required this.titles
  });

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      name: json['name'],
      region: json['region'],
      coatOfArms: json['coatOfArms'],
      words: json['words'],
      titles: json['titles'],
    );
  }
}