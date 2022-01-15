class PersonalFile {
  final int id;
  final String name;
  final String info;
  PersonalFile({this.id, this.name, this.info});

  factory PersonalFile.fromJson(Map<String, dynamic> json) =>
      PersonalFile(id: json['id'], name: json['name'], info: json['info']);
}
