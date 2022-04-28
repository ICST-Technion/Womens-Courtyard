import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalFile {
  final int id;
  final String name;
  final String info;
  PersonalFile({required this.id, required this.name, required this.info});

  factory PersonalFile.fromJson(Map<String, dynamic> json) =>
      PersonalFile(id: json['id'], name: json['name'], info: json['info']);

  factory PersonalFile.fromDoc(QueryDocumentSnapshot<Map> doc) => PersonalFile(
      id: int.parse(doc.data()['idNo']),
      name: doc.data()['firstName'] + " " + doc.data()['lastName'],
      info: doc.data()['personalFile']['clientNotes'][0]);
}
