// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:snapping_sheet/snapping_sheet.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:flutter/foundation.dart';
// import 'lib.dart' as lib;

// class CalendarPage extends StatefulWidget {
//   final businessId;

//   CalendarPage({Key key, @required this.businessId}) : super(key: key);

//   @override
//   _CalendarPageState createState() => _CalendarPageState();
// }

// class _CalendarPageState extends State<CalendarPage> {
//   final snapCtrl = SnappingSheetController();
//   bool _loading = false, _loadingInfo = false;
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   var _weekDays = [];
//   String _thisDate = "January 1, 2000";
//   String _image_link = "";
//   DateTime _savedDate = DateTime.now();
//   var _monthArray = [
//     "January",
//     "February",
//     "March",
//     "April",
//     "May",
//     "June",
//     "July",
//     "August",
//     "September",
//     "October",
//     "November",
//     "December"
//   ];
//   var _takenDates = [[]];
//   var _requestedDates = [[]];
//   var _specialDates = [[]];
//   var _takenShows = [];
//   var _requestedShows = [];
//   var _ids = [];
//   DateTime _focusedDay = DateTime.now();
//   DateTime _selectedDay = DateTime.now();
//   String _showArtistName = "", _reqArtistName = "";
//   String _currentPicUrl = "";

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     helperMethod();
//   }

//   Future<void> helperMethod() async {
//     setState(() {
//       _loading = true;
//     });
//     var _businessReference =
//         FirebaseFirestore.instance.collection('businesses');
//     DocumentSnapshot retrieve =
//         await _businessReference.doc(widget.businessId).get();
//     Map _businessData = retrieve.data();
//     var businessDays = _businessData['performanceDays'];
//     if (businessDays.contains("Sunday")) {
//       _weekDays.add(DateTime.sunday);
//     }
//     if (businessDays.contains("Monday")) {
//       _weekDays.add(DateTime.monday);
//     }
//     if (businessDays.contains("Tuesday")) {
//       _weekDays.add(DateTime.tuesday);
//     }
//     if (businessDays.contains("Wednesday")) {
//       _weekDays.add(DateTime.wednesday);
//     }
//     if (businessDays.contains("Thursday")) {
//       _weekDays.add(DateTime.thursday);
//     }
//     if (businessDays.contains("Friday")) {
//       _weekDays.add(DateTime.friday);
//     }
//     if (businessDays.contains("Saturday")) {
//       _weekDays.add(DateTime.saturday);
//     }
//     List dataSpecialDates = _businessData['specialDates'];

//     for (int i = 0; i < dataSpecialDates.length; i++) {
//       _specialDates.add([
//         dataSpecialDates[i].toDate().day,
//         dataSpecialDates[i].toDate().month,
//         dataSpecialDates[i].toDate().year
//       ]);
//     }
//     var showsReference;
//     var _showDays = _businessData['Shows'];
//     showsReference = FirebaseFirestore.instance.collection('shows');
//     for (int i = 0; i < _showDays.length; i++) {
//       DocumentSnapshot retrieveShows =
//           await showsReference.doc(_showDays[i]).get();
//       Map _showData = retrieveShows.data();
//       if (_showData != null) {
//         _takenShows.add(_showData);
//         var showStart = _showData['start time'].toDate();
//         _takenDates.add([showStart.day, showStart.month, showStart.year]);
//       }
//     }
//     var _requestsReference =
//         FirebaseFirestore.instance.collection('showRequests');
//     QuerySnapshot querySnapshot = await _requestsReference.get();
//     List _allData =
//         querySnapshot.docs.map((doc) => [doc.data(), doc.id]).toList();
//     for (int i = 0; i < _allData.length; i++) {
//       if (_allData[i][0]['destId'] == widget.businessId &&
//           _allData[i][0]['status'] == 'Waiting') {
//         _requestedShows.add(_allData[i][0]);
//         var showDate = _allData[i][0]['startHour'].toDate();
//         _requestedDates.add([showDate.day, showDate.month, showDate.year]);
//         _ids.add(_allData[i][1]);
//       }
//     }
//     setState(() {
//       _loading = false;
//     });
//   }

//   Map dateToShow(DateTime date) {
//     for (int i = 0; i < _takenShows.length; i++) {
//       DateTime thisDate = _takenShows[i]['start time'].toDate();
//       if (thisDate.day == date.day &&
//           thisDate.month == date.month &&
//           thisDate.year == date.year) {
//         return _takenShows[i];
//       }
//     }
//     return null;
//   }

//   Map dateToRequest(DateTime date) {
//     for (int i = 0; i < _requestedShows.length; i++) {
//       DateTime thisDate = _requestedShows[i]['startHour'].toDate();
//       if (thisDate.day == date.day &&
//           thisDate.month == date.month &&
//           thisDate.year == date.year) {
//         return _requestedShows[i];
//       }
//     }
//     return null;
//   }

//   List dateToRequestList(DateTime date) {
//     var requestList = [];
//     for (int i = 0; i < _requestedShows.length; i++) {
//       DateTime thisDate = _requestedShows[i]['startHour'].toDate();
//       if (thisDate.day == date.day &&
//           thisDate.month == date.month &&
//           thisDate.year == date.year) {
//         requestList.add(_requestedShows[i]);
//       }
//     }
//     return requestList;
//   }

//   updateOtherRequests(DateTime date) async {
//     var _requestsReference =
//         FirebaseFirestore.instance.collection('showRequests');
//     QuerySnapshot querySnapshot = await _requestsReference.get();
//     List _allData =
//         querySnapshot.docs.map((doc) => [doc.data(), doc.id]).toList();
//     for (int i = 0; i < _allData.length; i++) {
//       if (_allData[i][0]['destId'] == widget.businessId &&
//           _allData[i][0]['startHour'].toDate().day == date.day &&
//           _allData[i][0]['status'] == 'Waiting') {
//         await FirebaseFirestore.instance
//             .collection("showRequests")
//             .doc(_allData[i][1])
//             .update({"status": "Rejected"});
//       }
//     }
//   }

//   Future<List> audienceTokens(String artistId) async {
//     var showsReference = FirebaseFirestore.instance.collection('users');
//     var tokenList = [];
//     QuerySnapshot querySnapshot =
//         await showsReference.where('type', isEqualTo: 'Audience').get();
//     List _allAudience = querySnapshot.docs.map((doc) => doc.data()).toList();
//     var audienceReference = FirebaseFirestore.instance.collection('audience');
//     for (int i = 0; i < _allAudience.length; i++) {
//       DocumentSnapshot retrieve =
//           await audienceReference.doc(_allAudience[i]['ref']).get();
//       Map audienceData = retrieve.data();
//       print("HERE");
//       print(audienceData['favoriteArtists']);
//       if (audienceData['favoriteArtists'].contains(artistId)) {
//         tokenList = tokenList + _allAudience[i]['tokens'];
//       }
//     }
//     print(tokenList);
//     return tokenList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: generalAppBar(title: 'הזמנות'),
//         body: (_loading)
//             ? Center(child: CircularProgressIndicator())
//             : SnappingSheet(
//                 controller: snapCtrl,
//                 child: Directionality(
//                   textDirection: TextDirection.ltr,
//                   child: getCalendar(),
//                 ),
//                 grabbingHeight: MediaQuery.of(context).size.height * 0.042,
//                 grabbing: GestureDetector(
//                   onTap: () {
//                     snapCtrl.currentSnappingPosition ==
//                             SnappingPosition.factor(positionFactor: 0.5)
//                         ? snapCtrl.snapToPosition(SnappingPosition.factor(
//                             positionFactor: 0.0,
//                             grabbingContentOffset: GrabbingContentOffset.top,
//                           ))
//                         : snapCtrl.snapToPosition(
//                             SnappingPosition.factor(positionFactor: 0.5));
//                   },
//                   child: Container(
//                       decoration: BoxDecoration(
//                           color: lib.btnColor,
//                           borderRadius:
//                               BorderRadius.vertical(top: Radius.circular(20)),
//                           boxShadow: [
//                             BoxShadow(blurRadius: 25, color: Colors.black26)
//                           ]),
//                       height: MediaQuery.of(context).size.height * 0.042,
//                       child: Center(child: Icon(Icons.arrow_drop_up))),
//                 ),
//                 snappingPositions: [
//                   SnappingPosition.factor(
//                     positionFactor: 0.0,
//                     grabbingContentOffset: GrabbingContentOffset.top,
//                   ),
//                   SnappingPosition.factor(positionFactor: 0.5)
//                 ],
//                 sheetBelow: SnappingSheetContent(
//                   draggable: true,
//                   child: Container(
//                     height: MediaQuery.of(context).size.height,
//                     decoration: lib.gradientBG,
//                     child: SingleChildScrollView(
//                       child: (_loadingInfo)
//                           ? LinearProgressIndicator()
//                           : Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: <Widget>[
//                                   getDateContainer(context),
//                                   !(_weekDays.contains(_savedDate.weekday)) &&
//                                           !(_specialDates.any((d) => listEquals(
//                                                   d, [
//                                                 _savedDate.day,
//                                                 _savedDate.month,
//                                                 _savedDate.year
//                                               ])))
//                                       ? Container()
//                                       : (_takenDates.any((d) => listEquals(d, [
//                                                 _savedDate.day,
//                                                 _savedDate.month,
//                                                 _savedDate.year
//                                               ]))
//                                           ? getReservationList()
//                                           : _requestedDates.any((d) =>
//                                                   listEquals(d, [
//                                                     _savedDate.day,
//                                                     _savedDate.month,
//                                                     _savedDate.year
//                                                   ]))
//                                               ? ListView(
//                                                   shrinkWrap: true,
//                                                   padding: EdgeInsets.all(10.0),
//                                                   children: List.generate(
//                                                       dateToRequestList(
//                                                               _savedDate)
//                                                           .length,
//                                                       (index) =>
//                                                           getRequestListTile(
//                                                               index)),
//                                                 )
//                                               : Text("אין הזמנות היום",
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       color: Colors.white,
//                                                       fontSize: 24)))
//                                 ]),
//                     ),
//                   ),
//                 )),
//       ),
//     );
//   }

//   Container getDateContainer(BuildContext context) {
//     return Container(
//         padding:
//             EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
//         alignment: Alignment.center,
//         child: (Text(_thisDate,
//             style: TextStyle(color: Colors.white, fontSize: 26))));
//   }

//   TableCalendar<dynamic> getCalendar() {
//     return TableCalendar(
//       firstDay: DateTime.utc(2010, 10, 16),
//       lastDay: DateTime.utc(2030, 3, 14),
//       focusedDay: _focusedDay,
//       weekendDays: [DateTime.friday, DateTime.saturday],
//       selectedDayPredicate: (day) {
//         return isSameDay(_selectedDay, day);
//       },
//       calendarFormat: _calendarFormat,
//       onFormatChanged: (format) {
//         setState(() {
//           _calendarFormat = format;
//         });
//       },
//       calendarStyle: CalendarStyle(
//           todayDecoration: BoxDecoration(color: Colors.orange),
//           selectedDecoration: BoxDecoration(color: Colors.amber),
//           todayTextStyle: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18.0,
//               color: Colors.white)),
//       headerStyle: HeaderStyle(
//         titleCentered: true,
//         formatButtonDecoration: BoxDecoration(
//           color: Colors.orange,
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//         formatButtonTextStyle: TextStyle(color: Colors.white),
//         formatButtonShowsNext: false,
//       ),
//       startingDayOfWeek: StartingDayOfWeek.sunday,
//       onPageChanged: (focusedDay) {
//         _focusedDay = focusedDay;
//       },
//       onDaySelected: (date, focusedDay) async {
//         setState(() {
//           _loadingInfo = true;
//         });
//         _thisDate = _monthArray[date.month - 1] +
//             " " +
//             date.day.toString() +
//             ", " +
//             date.year.toString();
//         _savedDate = date;
//         _focusedDay = date;
//         _selectedDay = date;
//         if (dateToShow(_savedDate) != null) {
//           _showArtistName = "";
//           if (dateToShow(_savedDate)['artists'].length > 0) {
//             _showArtistName =
//                 await getUserNameByRefID(dateToShow(_savedDate)['artists'][0]);
//             _currentPicUrl =
//                 await getImageURLByRef(dateToShow(_savedDate)['srcId']);
//           }
//         }
//         if (dateToRequest(_savedDate) != null) {
//           _reqArtistName =
//               await getUserNameByRefID(dateToRequest(_savedDate)['srcId']);
//           _currentPicUrl =
//               await getImageURLByRef(dateToRequest(_savedDate)['srcId']);
//         }
//         snapCtrl.snapToPosition(SnappingPosition.factor(positionFactor: 0.5));
//         setState(() {
//           _loadingInfo = false;
//         });
//       },
//       calendarBuilders: CalendarBuilders(
//         defaultBuilder: (context, date, events) =>
//             _weekDays.contains(date.weekday) ||
//                     _specialDates.any(
//                         (d) => listEquals(d, [date.day, date.month, date.year]))
//                 ? Container(
//                     margin: const EdgeInsets.all(4.0),
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         color: getDateColor(date), shape: BoxShape.circle),
//                     child: Text(
//                       date.day.toString(),
//                       style: TextStyle(color: Colors.white),
//                     ))
//                 : Container(
//                     margin: const EdgeInsets.all(4.0),
//                     alignment: Alignment.center,
//                     child: Text(date.day.toString(),
//                         style: TextStyle(color: Colors.black))),
//         selectedBuilder: (context, date, events) => Container(
//             margin: const EdgeInsets.all(4.0),
//             alignment: Alignment.center,
//             decoration: myBoxDecoration(Colors.black, getDateColor(date)),
//             child: Text(
//               date.day.toString(),
//               style: TextStyle(color: Colors.black),
//             )),
//         todayBuilder: (context, date, events) => Container(
//             margin: const EdgeInsets.all(4.0),
//             alignment: Alignment.center,
//             decoration: myBoxDecoration(Colors.orange, getDateColor(date)),
//             child: Text(
//               date.day.toString(),
//               style: TextStyle(color: Colors.black),
//             )),
//       ),
//     );
//   }

//   ListTile getRequestListTile(int index) {
//     return ListTile(
//       leading: Container(
//         width: 50,
//         height: 50,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           image: DecorationImage(
//               image: NetworkImage(
//                   'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png'),
//               fit: BoxFit.fill),
//         ),
//       ),
//       title: Center(
//         child:
//             Text(_reqArtistName, //dateToRequestList(_savedDate)[index]['name'],
//                 style: TextStyle(color: Colors.white, fontSize: 26)),
//       ),
//       subtitle: Center(
//         child: Text(
//             dateToRequest(_savedDate)['startHour']
//                     .toDate()
//                     .toString()
//                     .substring(11, 16) +
//                 ' - ' +
//                 dateToRequest(_savedDate)['endHour']
//                     .toDate()
//                     .toString()
//                     .substring(11, 16),
//             style: TextStyle(color: Colors.white70, fontSize: 20)),
//       ),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//               height: 40,
//               width: 40,
//               margin: EdgeInsets.all(4),
//               child: IconButton(
//                 icon:
//                     Icon(Icons.check, color: Colors.lightGreenAccent, size: 25),
//                 onPressed: () async {
//                   await acceptRequest(index);
//                 },
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.black26,
//                 borderRadius: BorderRadius.all(Radius.circular(100.0)),
//               )),
//           Container(
//               height: 40,
//               width: 40,
//               margin: EdgeInsets.all(4),
//               child: IconButton(
//                 icon: Icon(Icons.close, color: Colors.red, size: 25),
//                 onPressed: () async {
//                   await rejectRequest(index);
//                 },
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.white70,
//                 borderRadius: BorderRadius.all(Radius.circular(100.0)),
//               )),
//         ],
//       ),
//     );
//   }

//   Future<void> acceptRequest(int index) async {
//     var request = dateToRequestList(_savedDate)[index];
//     var artistId = request['srcId'];
//     var busReference = FirebaseFirestore.instance.collection('businesses');
//     var retrieve = await busReference.doc(widget.businessId).get();
//     var currBus = retrieve.data();
//     var shows = FirebaseFirestore.instance.collection('shows');
//     var temp = await shows.add(({
//       'about': request['description'],
//       'name': request['name'],
//       'artists': [artistId],
//       'location': currBus['location'],
//       'start time': request['startHour'],
//       'end time': request['endHour']
//     }));
//     _takenDates.add([_savedDate.day, _savedDate.month, _savedDate.year]);
//     var currShow = await shows.doc(temp.id).get();
//     _takenShows.add(currShow.data());
//     var businessData = FirebaseFirestore.instance.collection('businesses');
//     var currBusiness = await businessData.doc(widget.businessId).get();
//     List businessShowsList = currBusiness.data()['Shows'];
//     businessShowsList.add(temp.id);
//     businessData.doc(widget.businessId).update({'Shows': businessShowsList});
//     await FirebaseFirestore.instance
//         .collection("showRequests")
//         .doc(_ids[index])
//         .update({"status": "Accepted"});
//     updateOtherRequests(request['endHour'].toDate());
//     var showsReference = FirebaseFirestore.instance.collection('users');
//     QuerySnapshot querySnapshot =
//         await showsReference.where('ref', isEqualTo: artistId).get();
//     List _allData = querySnapshot.docs.map((doc) => doc.data()).toList();
//     var tokenList = _allData[0]['tokens'];
//     var artistName = _allData[0]['name'];
//     querySnapshot =
//         await showsReference.where('ref', isEqualTo: widget.businessId).get();
//     _allData = querySnapshot.docs.map((doc) => doc.data()).toList();
//     String businessName = _allData[0]['name'];
//     for (int i = 0; i < tokenList.length; i++) {
//       String requestBody;
//       Uri url;
//       String message = "Someone accepted your show request!";
//       Map<String, String> headers;
//       requestBody = '   {  ' +
//           '       "title": "Received a message from ' +
//           businessName +
//           '",  ' +
//           '       "message": "' +
//           message +
//           '",  ' +
//           '       "tokens": [  ' +
//           '           "' +
//           tokenList[i] +
//           '"  ' +
//           '       ]  ' +
//           '  }  ';
//       url = Uri.parse(
//           'https://us-central1-crack-root-314018.cloudfunctions.net/sendBroadcastNotification');
//       headers = {"Content-type": "application/json"};
//       // make POST request
//       await post(url, headers: headers, body: requestBody);
//     }
//     tokenList = await _CalendarPageState().audienceTokens(artistId);
//     for (int i = 0; i < tokenList.length; i++) {
//       print(tokenList[i]);
//       String requestBody;
//       Uri url;
//       Map<String, String> headers;
//       String title = "" + artistName + " has a new show";
//       String message = "The show's location will be at: " + businessName;
//       requestBody = '   {  ' +
//           '       "title": "' +
//           title +
//           '",  ' +
//           '       "message": "' +
//           message +
//           '",  ' +
//           '       "tokens": [  ' +
//           '           "' +
//           tokenList[i] +
//           '"  ' +
//           '       ]  ' +
//           '  }  ';
//       url = Uri.parse(
//           'https://us-central1-crack-root-314018.cloudfunctions.net/sendBroadcastNotification');
//       headers = {"Content-type": "application/json"};
//       // make POST request
//       await post(url, headers: headers, body: requestBody);
//     }
//     setState(() {});
//   }

//   Future<void> rejectRequest(int index) async {
//     print('i am here');
//     var request = dateToRequestList(_savedDate)[index];
//     var artistId = request['srcId'];
//     await FirebaseFirestore.instance
//         .collection("showRequests")
//         .doc(_ids[index])
//         .update({"status": "Rejected"});
//     var usersRef = FirebaseFirestore.instance.collection('users');
//     QuerySnapshot querySnapshot =
//         await usersRef.where('ref', isEqualTo: artistId).get();
//     List _allData = querySnapshot.docs.map((doc) => doc.data()).toList();
//     var tokenList = _allData[0]['tokens'];
//     querySnapshot =
//         await usersRef.where('ref', isEqualTo: widget.businessId).get();
//     _allData = querySnapshot.docs.map((doc) => doc.data()).toList();
//     String businessName = _allData[0]['name'];
//     for (int i = 0; i < tokenList.length; i++) {
//       String requestBody;
//       Uri url;
//       String message = "Someone rejected your show request!";
//       Map<String, String> headers;
//       requestBody = '   {  ' +
//           '       "title": "Received a message from ' +
//           businessName +
//           '",  ' +
//           '       "message": "' +
//           message +
//           '",  ' +
//           '       "tokens": [  ' +
//           '           "' +
//           tokenList[i] +
//           '"  ' +
//           '       ]  ' +
//           '  }  ';
//       url = Uri.parse(
//           'https://us-central1-crack-root-314018.cloudfunctions.net/sendBroadcastNotification');
//       headers = {"Content-type": "application/json"};
//       // make POST request
//       await post(url, headers: headers, body: requestBody);
//     }
//     setState(() {});
//   }

//   ListView getReservationList() {
//     return ListView(shrinkWrap: true, children: [
//       getShowTimeListTile(),
//       Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Container(
//           margin: EdgeInsets.only(left: 8),
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             image: DecorationImage(
//                 image: NetworkImage(
//                     'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png'),
//                 fit: BoxFit.fill),
//           ),
//         ),
//         Center(
//             child: Text(_showArtistName,
//                 style: TextStyle(color: Colors.white, fontSize: 24)))
//       ]),
//       ListTile(
//         title: Center(
//             child: Text(dateToShow(_savedDate)['name'],
//                 style: TextStyle(fontSize: 23, color: Colors.white))),
//       ),
//       ListTile(
//           title: Center(
//               child: Text(dateToShow(_savedDate)['about'],
//                   style: TextStyle(fontSize: 20, color: Colors.white)))),
//     ]);
//   }

//   ListTile getShowTimeListTile() {
//     return ListTile(
//       contentPadding: EdgeInsets.only(top: 20.0),
//       title: new Center(
//           child: Text(getShowTimeString(),
//               style: TextStyle(color: Colors.white, fontSize: 25))),
//     );
//   }

//   String getShowTimeString() {
//     return "" +
//         dateToShow(_savedDate)['start time']
//             .toDate()
//             .toString()
//             .substring(11, 16) +
//         ' - ' +
//         dateToShow(_savedDate)['end time']
//             .toDate()
//             .toString()
//             .substring(11, 16);
//   }

//   Color getDateColor(DateTime date) {
//     if (_takenDates
//         .any((d) => listEquals(d, [date.day, date.month, date.year])))
//       return Colors.red.withOpacity(0.64);
//     else if (_requestedDates
//         .any((d) => listEquals(d, [date.day, date.month, date.year])))
//       return Colors.yellow.withOpacity(0.64);
//     else if (_weekDays.contains(date.weekday) ||
//         _specialDates
//             .any((d) => listEquals(d, [date.day, date.month, date.year])))
//       return Colors.green.withOpacity(0.64);
//     else
//       return Colors.transparent;
//   }

//   BoxDecoration myBoxDecoration(Color borderColor, Color bgColor) {
//     return BoxDecoration(
//         border: Border.all(color: borderColor, width: 1.2),
//         color: bgColor,
//         shape: BoxShape.circle);
//   }
// }
