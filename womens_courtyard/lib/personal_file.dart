import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalFile {
  final int id;
  final String firstName;
  final String lastName;
  final String info;
  PersonalFile(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.info});

  factory PersonalFile.fromJson(Map<String, dynamic> json) => PersonalFile(
      id: json['id'],
      firstName: json['name'],
      lastName: json['name'],
      info: json['info']);

  factory PersonalFile.fromDoc(QueryDocumentSnapshot<Map> doc) => PersonalFile(
      id: int.parse(doc.data()['idNo']),
      firstName: doc.data()['firstName'],
      lastName: doc.data()['lastName'],
      info: doc.data()['personalFile']['clientNotes'][0]);
}
