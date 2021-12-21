class PersonalFile {
  final int id;
  final String name;
  PersonalFile({this.id, this.name});

  factory PersonalFile.fromJson(Map<String, dynamic> json) =>
      PersonalFile(id: json['id'], name: json['name']);
}
