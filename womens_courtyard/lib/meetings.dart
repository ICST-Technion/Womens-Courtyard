import 'meeting.dart';
import 'package:flutter/material.dart';

final DateTime today = DateTime.now();
final DateTime startTime =
    DateTime(today.year, today.month, today.day, 9, 0, 0);
final DateTime endTime = startTime.add(const Duration(hours: 2));

List<Meeting> meetings = [
  Meeting('Conference', 'room1', startTime, endTime, false)
];
