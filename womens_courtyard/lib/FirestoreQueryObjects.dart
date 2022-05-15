import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
// collection name
const PERSONAL_FILE_COLLECTION_NAME = "clients";
// personal file fields
const FIRST_NAME_FIELD = "firstName";
const LAST_NAME_FIELD = "lastName";
const ID_FIELD = "firstName";
const AGE_FIELD = "age";
const ADDR_FIELD = "address";
const PHONE_FIELD = "phoneNo";
const NATIONALITY_FIELD = "nationality";
const CLIENT_NOTES_FIELD = "clientNotes";
const IN_ASSIGNMENT_FIELD = "inAssignment";
const PROCESS_FIELD = "processes";
const HISTORY_FIELD = "appointmentHistory";
const ATTENDANCE_FIELD = "attendances";
// attendance fields
const DATE_FIELD = "date";
const COMMENT_FIELD = "comment";
// appointment fields
const DESCRIPTION_FIELD = "description";
const LOCATION_FIELD = "location";
const STAFF_FIELD = "staffInCharge";
// const DATE_FIELD = "date";



class PersonalFile {
  final String firstName;
  final String lastName	;
  final String idNo;
  final int age;
  final String address;
  final String phoneNo;
  final String nationality;
  final List clientNotes;
  final bool inAssignment;
  final List processes;
  final List appointmentHistory;
  final List attendances;
  PersonalFile(this.firstName,
    this.lastName,
    this.idNo,
    this.age,
    this.address,
    this.phoneNo,
    this.nationality,
    this.clientNotes,
    this.inAssignment,
    this.processes,
    this.appointmentHistory,
    this.attendances);
  //
  // factory PersonalFile.fromJson(Map<String, dynamic> json) => PersonalFile(
  //     id: json['id'],
  //     firstName: json['name'],
  //     lastName: json['name'],
  //     info: json['info']);
  
  factory PersonalFile.fromDoc(QueryDocumentSnapshot<Map> doc) {
    // assumes a single client document is received
    final String firstName = doc[FIRST_NAME_FIELD];
    final String lastName	= doc[LAST_NAME_FIELD];
    final String idNo = doc[ID_FIELD];
    final int age = doc[AGE_FIELD];
    final String address = doc[ADDR_FIELD];
    final String phoneNo = doc[PHONE_FIELD];
    final String nationality = doc[NATIONALITY_FIELD];
    final List clientNotes = doc[CLIENT_NOTES_FIELD];
    final bool inAssignment = doc[IN_ASSIGNMENT_FIELD];
    final List processes = doc[PROCESS_FIELD].toList();
    final List appointmentHistory = doc[HISTORY_FIELD].map((e) => Appointment.fromDoc(e)).toList();
    final List attendances = doc[ATTENDANCE_FIELD].map((e) => Attendance.fromDoc(e)).toList();
    return PersonalFile(firstName, lastName, idNo, age, address, phoneNo, nationality, clientNotes, inAssignment, processes, appointmentHistory, attendances);
  }
}

class Appointment {
  final String description;
  final DateTime date;
  final String location;
  final bool staffInCharge;
  Appointment(this.description, this.date, this.location, this.staffInCharge);

  factory Appointment.fromDoc(QueryDocumentSnapshot<Map> doc) => Appointment(
    doc[DESCRIPTION_FIELD],
    doc[DATE_FIELD].toDate(),
    doc[LOCATION_FIELD],
    doc[STAFF_FIELD]
  );
}

class Attendance {
  final DateTime date;
  final String comment;
  Attendance(this.date, this.comment);

  factory Attendance.fromDoc(QueryDocumentSnapshot<Map> doc) => Attendance(
      doc[DATE_FIELD].toDate(),
      doc[COMMENT_FIELD]
  );
}