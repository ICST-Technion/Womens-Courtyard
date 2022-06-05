import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:womens_courtyard/main.dart';

/// This file contains every attribute needed for a personal file.
/// We define here several classes with multiple fields, including:
/// * Appointment
/// * Attendance
/// * Personal file
///
/// We get all information needed for the personal file of a certain user
/// from the database and fill up the classes presented above using it.
///

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
      required this.attendances});

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
          []));
}
