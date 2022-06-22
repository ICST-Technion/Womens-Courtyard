import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:womens_courtyard/user.dart';

List<String> nonHQBranches = ['נתניה', 'יפו', 'חיפה'];

class Appointment {
  final String description;
  final Timestamp date;
  final String location;
  final String staffInCharge;

  Appointment(
      {required this.description,
      required this.date,
      required this.location,
      required this.staffInCharge});
}

class Attendance {
  final DateTime date;
  final String comment;

  Attendance({required this.date, required this.comment});
}

List<String>? strfy(List<dynamic>? dynamicList) {
  return dynamicList?.map((e) => e.toString()).toList();
}

class ContactFile {
  final String key;
  final String firstName;
  final String lastName;
  final String field;
  final String phoneNo;
  final String? email;
  final String info;

  ContactFile(
      {required this.key,
      required this.firstName,
      required this.lastName,
      required this.field,
      required this.phoneNo,
      required this.email,
      required this.info});

  factory ContactFile.fromDoc(QueryDocumentSnapshot<Map> doc) => ContactFile(
      key: doc.id,
      firstName: doc.data()['firstName'],
      lastName: doc.data()['lastName'],
      field: doc.data()['field'],
      phoneNo: doc.data()['phoneNo'],
      email: doc.data()['email'] ?? 'no email',
      info: doc.data()['info']);

  factory ContactFile.fromDocNoQuery(DocumentSnapshot<Map> doc) => ContactFile(
      key: doc.id,
      firstName: doc.data()?['firstName'],
      lastName: doc.data()?['lastName'],
      field: doc.data()?['field'],
      phoneNo: doc.data()?['phoneNo'],
      email: doc.data()?['email'] ?? 'no email',
      info: doc.data()?['info']);
}

class PersonalFile {
  final String key;
  final String firstName;
  final String lastName;
  final String? idNo;
  final int? age;
  final String address;
  final String phoneNo;
  final String nationality;
  final List<String> clientNotes;
  final bool? inAssignment;
  final List<String> processes;
  final List<Appointment> appointments;
  final List<Attendance> attendances;
  final List<String> contactKeys;

  PersonalFile(
      {required this.key,
      required this.firstName,
      required this.lastName,
      required this.idNo,
      required this.age,
      required this.address,
      required this.phoneNo,
      required this.nationality,
      required this.clientNotes,
      required this.inAssignment,
      required this.processes,
      required this.appointments,
      required this.attendances,
      required this.contactKeys});

  factory PersonalFile.fromDoc(QueryDocumentSnapshot<Map> doc) => PersonalFile(
      key: doc.id,
      firstName: doc.data()['firstName'],
      lastName: doc.data()['lastName'],
      idNo: doc.data()['idNo'],
      age: doc.data()['age'],
      address: doc.data()['address'] ?? 'לא ידועה',
      phoneNo: doc.data()['phoneNo'] ?? 'לא ידוע',
      nationality: doc.data()['nationality'] ?? 'לא ידועה',
      clientNotes: strfy(doc.data()['clientNotes']) ?? List<String>.empty(),
      inAssignment: doc.data()['inAssignment'],
      processes: strfy(doc.data()['processes']) ?? List<String>.empty(),
      // appointments: doc.data()['appointments'] as List<Appointment> ??
      //     List<Appointment>.empty(),
      // attendances: doc.data()['attendances'] as List<Attendance> ??
      //     List<Attendance>.empty());
      appointments: doc
              .data()['appointments']
              ?.map((app) => Appointment(
                  description: app['description'],
                  date: app['date'].toDate(),
                  location: app['location'],
                  staffInCharge: app['staffInCharge']))
              ?.toList() ??
          List<Appointment>.empty(),
      attendances: List<Attendance>.from(doc.data()['attendances']?.map((att) =>
              Attendance(
                  date: att['date']!.toDate(), comment: att['comment']!)) ??
          []),
      contactKeys: List<String>.from(doc.data()['contacts'] ?? []));
}

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
    getPersonalFileDocs() async {
  final branches = FirebaseFirestore.instance.collection('branches');
  if (!isHQ()) {
    final branchClients = branches.doc(AppUser().branch).collection('clients');
    var res = await branchClients.get();
    return res.docs;
  } else {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs = [];
    for (String branch in nonHQBranches) {
      final branchClients = branches.doc(branch).collection('clients');
      var currClients = await branchClients.get();
      allDocs.addAll(currClients.docs);
    }
    return allDocs;
  }
}

Future<void> updatePersonalFile(String key, Map<String, Object?> value) async {
  CollectionReference branchRef =
      FirebaseFirestore.instance.collection('branches');
  CollectionReference clientsRef =
      branchRef.doc(AppUser().branch).collection('clients');

  clientsRef.doc(key).update(value);
}

Future<void> putPersonalFile(Map<String, Object?> value) async {
  CollectionReference branchRef =
      FirebaseFirestore.instance.collection('branches');
  CollectionReference clientsRef =
      branchRef.doc(AppUser().branch).collection('clients');

  clientsRef.add(value);
}

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
    getContactsDocs() async {
  final branches = FirebaseFirestore.instance.collection('branches');
  if (!isHQ()) {
    final branchContacts =
        branches.doc(AppUser().branch).collection('contacts');
    var res = await branchContacts.get();
    return res.docs;
  } else {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs = [];
    for (String branch in nonHQBranches) {
      final branchContacts = branches.doc(branch).collection('contacts');
      var currContacts = await branchContacts.get();
      allDocs.addAll(currContacts.docs);
    }
    return allDocs;
  }
}

CollectionReference getContactsCollection() {
  CollectionReference branchRef =
      FirebaseFirestore.instance.collection('branches');
  return branchRef.doc(AppUser().branch).collection('contacts');
}

Future<void> updateContact(String key, Map<String, Object?> value) async {
  CollectionReference branchRef =
      FirebaseFirestore.instance.collection('branches');
  CollectionReference contactsRef =
      branchRef.doc(AppUser().branch).collection('contacts');

  contactsRef.doc(key).update(value);
}

Future<void> putContact(Map<String, Object?> value) async {
  CollectionReference branchRef =
      FirebaseFirestore.instance.collection('branches');
  CollectionReference contactsRef =
      branchRef.doc(AppUser().branch).collection('contacts');

  contactsRef.add(value);
}

bool isHQ() {
  return AppUser().branch == 'מטה';
}
