import 'package:flutter/material.dart';

Map<String, Color> roomColor = {
  "room1": Color(0xFF0F8644),
  "room2": Color(0x884432EF)
};
List<String> rooms = ["room1", "room2"];

class Meeting {
  String eventName;
  String room;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  Meeting(this.eventName, this.room, this.from, this.to, this.isAllDay) {
    this.background = roomColor[room];
  }
}