import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:womens_courtyard/main.dart';

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
  final Timestamp date;
  final String comment;

  Attendance({required this.date, required this.comment});
}

class PersonalFile {
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

  PersonalFile(
      {required this.firstName,
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
      required this.attendances});

  factory PersonalFile.fromDoc(QueryDocumentSnapshot<Map> doc) => PersonalFile(
      firstName: doc.data()['firstName'],
      lastName: doc.data()['lastName'],
      idNo: doc.data()['idNo'],
      age: doc.data()['age'],
      address: doc.data()['address'] ?? 'לא ידועה',
      phoneNo: doc.data()['phoneNo'] ?? 'לא ידוע',
      nationality: doc.data()['nationality'] ?? 'לא ידועה',
      clientNotes: doc.data()['clientNotes'] ?? [],
      inAssignment: doc.data()['inAssignment'],
      processes: doc.data()['processes'] ?? [],
      appointments: doc.data()['appointments'] ?? [],
      attendances: doc.data()['attendances'] ?? []);
}
