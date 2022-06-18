import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

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

Future<QuerySnapshot<Map<String, dynamic>>> getContactDocs() async {
  final branches = FirebaseFirestore.instance.collection('branches');
  final branchClients = branches.doc(AppUser().branch).collection('contacts');
  return branchClients.get();
}
