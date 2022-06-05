import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, QueryDocumentSnapshot, QuerySnapshot, Timestamp;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:womens_courtyard/FirestoreQueryObjects.dart';
import 'package:womens_courtyard/personal_file.dart';
import 'package:womens_courtyard/Nationality.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
// import 'package:excel/excel.dart';
import 'StatisticsLogic.dart';
import 'dart:ui' as ui;


/// THis page is in charge of building the visual statistic needed for the
/// queries send to the database.

const String NATION_FIELD = "לאום";
const String FIRST_NAME_FIELD = "שם פרטי";
const String LAST_NAME_FIELD = "שם משפחה";
const String VISITS_FIELD = "ביקורים";
const String EXCEL_NAME = "womens_courtyard_report";

// const Map<int, String> WEEKDAYS = <int, String>{
//   1: 'שני',
//   2: 'שלישי',
//   3: 'רביעי',
//   4: 'חמישי',
//   5: 'שישי',
//   6: 'שבת',
//   7: 'ראשון',
// };
class TaskHomePage extends StatefulWidget {
  @override
  _TaskHomePageState createState() {
    return _TaskHomePageState();
  }
}

class _TaskHomePageState extends State<TaskHomePage> {
  List<charts.Series<String, String>> _seriesPieData = [];
  List<charts.Series<String, String>> _seriesBarData = [];
  // Map<String, int> nationalitiesHist;
  _generatePieChartData(Map<String, int> nationalitiesHist) {
    // List<Nationality> nationatilies = Nationality.makeNationalitiesList(nationalitiesHist);
    _seriesPieData = [];
    _seriesPieData.add(
      charts.Series(
        domainFn: (String nat, _) => nat,
        measureFn: (String nat, _) {
          return nationalitiesHist[nat];
        },
        colorFn: (String nat, _) => charts.ColorUtil.fromDartColor(
            Color((nat.hashCode * 0xFFFFFF)).withOpacity(1.0)),
        id: 'התפלגות אוכלוסיה',
        data: nationalitiesHist.keys.toList(),
        labelAccessorFn: (String row, _) => "$row",
      ),
    );
  }

  /// This function generates a bar chart of the information.

  _generateBarChartData(Map<String, int> weekdaysHist) {
    // List<Nationality> nationatilies = Nationality.makeNationalitiesList(nationalitiesHist);
    _seriesBarData = [];
    _seriesBarData.add(
      charts.Series(
        domainFn: (String weekday, _) => weekday,
        measureFn: (String weekday, _) => weekdaysHist[weekday],
        colorFn: (String nat, _) => charts.ColorUtil.fromDartColor(
            Color((nat.hashCode * 0xFFFFFF)).withOpacity(1.0)),
        id: 'התפלגות ביקורים',
        data: ["ראשון", "שני", "שלישי", "רביעי", "חמישי", "שישי", "שבת"],
        labelAccessorFn: (String row, _) => "$row",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          return Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(title: Text('סטטיסטיקה')),
              body: _buildBody(context),
            ),
          );
        });
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('clients').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          print("got snapshot");
          var pfList = snapshot.data!.docs
              .map((doc) =>
                  PersonalFile.fromDoc(doc as QueryDocumentSnapshot<Map>))
              .toList();
          print("finished personal files processing");
          var nationalitiesHist = makeNationalitiesHist(pfList);
          print(
              "nationalities: $nationalitiesHist, type: ${nationalitiesHist.runtimeType}");
          var visitsHist = makeVisitsHist(pfList);
          print("visits histogram: $visitsHist");
          // return _buildPieChart(context, nationalitiesHist);
          // return _buildBarChart(context, visitsHist);
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: <Widget>[
                    _buildPieChart(context, nationalitiesHist),
                    _buildBarChart(context, visitsHist),
                    // _buildExcelButton(context, givenSnapshots)
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

  /// This function generates a pie chart of the information.

  Widget _buildPieChart(
      BuildContext context, Map<String, int> nationalitiesHist) {
    // mydata = nationalitiesHist;
    _generatePieChartData(nationalitiesHist);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              'התפלגות על בסיס סוג אוכלוסיה',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 200.0,
              child: charts.PieChart(_seriesPieData,
                  animate: true,
                  animationDuration: Duration(seconds: 1),
                  behaviors: [
                    new charts.DatumLegend(
                      outsideJustification:
                          charts.OutsideJustification.endDrawArea,
                      horizontalFirst: false,
                      desiredMaxRows: 2,
                      cellPadding: new EdgeInsets.only(
                          right: 4.0, bottom: 4.0, top: 4.0),
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 18),
                    )
                  ],
                  defaultRenderer: new charts.ArcRendererConfig(
                      arcWidth: 100,
                      arcRendererDecorators: [
                        new charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.inside)
                      ])),
            ),
            SizedBox(
              height: 10.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, Map<String, int> weekdaysHist) {
    // mydata = nationalitiesHist;
    _generateBarChartData(weekdaysHist);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              'מספר הגעות בכל יום',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 200.0,
              child: charts.BarChart(
                _seriesBarData,
                animate: true,
                animationDuration: Duration(seconds: 1),
                behaviors: [
                  // new charts.DatumLegend(
                  //   entryTextStyle: charts.TextStyleSpec(
                  //       color: charts.MaterialPalette.purple.shadeDefault,
                  //       fontFamily: 'Georgia',
                  //       fontSize: 5
                  //   ),
                  // )
                ],
              ),
            ),
            // Text(
            //   'מספר הגעות בכל יום',
            //   style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            // ),
            SizedBox(
              height: 10.0,
            )
          ],
        ),
      ),
    );
  }

  // Widget _buildExcelButton(BuildContext context, List<QueryDocumentSnapshot<Object>> snapshots){
  //
  // }
}
