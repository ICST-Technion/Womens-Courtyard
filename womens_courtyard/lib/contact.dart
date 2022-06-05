import 'package:cloud_firestore/cloud_firestore.dart';

/// This file indicates the structure of the contact listing in our database.
/// It contains the following fields:
/// * Name.
/// * Phone number.
/// * Occupation
/// * Info.

class Contact {
  final String name;
  final String phoneNumber;
  final String occupation;
  final String info;
  Contact(
      {required this.name,
      required this.phoneNumber,
      required this.occupation,
      required this.info});

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      occupation: json['occupation'],
      info: json['info']);

  factory Contact.fromDoc(QueryDocumentSnapshot<Map> doc) => Contact(
      name: doc.data()['firstName'] + ' ' + doc.data()['lastName'],
      phoneNumber: doc.data()['phoneNo'],
      occupation: doc.data()['field'],
      info: doc.data()['info']);
}
