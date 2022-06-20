class Nationality {
  final String name;
  final int count;
  Nationality(this.name, this.count);

  Nationality.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        assert(map['count'] != null),
        name = map['name'],
        count = map['count'];

  @override
  String toString() => "Record<$name:$count>";

  static List<Nationality> makeNationalitiesList(Map<String, int> hist) {
    List<Nationality> nationalities = [];
    hist.forEach((key, value) {
      nationalities.add(Nationality(key, value));
    });
    return nationalities;
  }
}
