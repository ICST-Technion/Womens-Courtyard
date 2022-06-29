import 'package:cloud_firestore/cloud_firestore.dart'
    show QueryDocumentSnapshot;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:womens_courtyard/FirestoreQueryObjects.dart';
import 'package:womens_courtyard/personal_file.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:excel/excel.dart';
import 'package:womens_courtyard/statistics_logic.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:html';

/// In this page we build the graphs and charts used for the visual presentation
/// of the calculated and collected statistics.

const String NATION_FIELD = "לאום";
const String FIRST_NAME_FIELD = "שם פרטי";
const String LAST_NAME_FIELD = "שם משפחה";
const String VISITS_FIELD = "ביקורים";
const String EXCEL_NAME = "womens_courtyard_report";

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

  /// A function generating data about nationalities using pie charts.

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

  /// A function generating data about weekday attendance using bar charts.

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
    return FutureBuilder(
        future: getPersonalFileDocs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final docs = (snapshot.data ?? [])
                as List<QueryDocumentSnapshot<Map<String, Object?>>>;
            var pfList = docs.map((doc) => PersonalFile.fromDoc(doc)).toList();
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
                      _buildBarChart(context, visitsHist, pfList),
                      // _buildExcelButton(context, givenSnapshots)
                    ],
                  ),
                ),
              ],
            );
          }
          return Text("Failed");
        });
  }

  /// Building the pie chart visually.

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

  /// Building the bar chart visually.

  Widget _buildBarChart(BuildContext context, Map<String, int> weekdaysHist,
      List<PersonalFile> pf) {
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
            ),
            ElevatedButton(
                child: Text("ייצוא לאקסל"),
                onPressed: () {
                  var myExcel = createExcel(pf);
                  download(myExcel.encode() ?? [],
                      downloadName: "courtyard_data.xlsx");
                },
                style: ElevatedButton.styleFrom(
                    elevation: 4,
                    primary: Colors.purple,
                    padding: EdgeInsets.all(4),
                    minimumSize: Size(180, 60),
                    textStyle: TextStyle(color: Colors.white, fontSize: 22),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))))
          ],
        ),
      ),
    );
  }

  // Widget _buildExcelButton(BuildContext context, List<QueryDocumentSnapshot<Object>> snapshots){
  //
  // }
}

const Map<int, String> WEEKDAYS = <int, String>{
  1: 'שני',
  2: 'שלישי',
  3: 'רביעי',
  4: 'חמישי',
  5: 'שישי',
  6: 'שבת',
  7: 'ראשון',
};

List<Visit> createExcelMap(List<PersonalFile> pf) {
  List<Visit> res = [
    Visit(
        date: "תאריך",
        nationality: "אוכלוסיה",
        weekDay: "יום בשבוע",
        description: "משפט יומי",
        pName: "שם פרטי",
        lName: "שם משפחה",
        idNo: "תעודת זהות")
  ];
  for (PersonalFile personalFile in pf) {
    for (Attendance att in personalFile.attendances) {
      res.add(Visit(
          date: att.date.year.toString() +
              "/" +
              att.date.month.toString() +
              "/" +
              att.date.day.toString(),
          nationality: personalFile.nationality,
          weekDay: WEEKDAYS[att.date.weekday] ?? "ראשון",
          description: att.comment,
          pName: personalFile.firstName,
          lName: personalFile.lastName,
          idNo: personalFile.idNo));
    }
  }

  return res;
}

class Visit {
  final String date;
  final String nationality;
  final String weekDay;
  final String description;
  final String pName;
  final String lName;
  final String? idNo;

  Visit(
      {required this.date,
      required this.nationality,
      required this.weekDay,
      required this.description,
      required this.pName,
      required this.lName,
      required this.idNo});
}

Excel createExcel(List<PersonalFile> pf) {
  List<Visit> visitList = createExcelMap(pf);
  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];
  List<String> column = ["A", "B", "C", "D", "E", "F", "G"];
  for (int i = 0; i < visitList.length; i++) {
    for (int j = 0; j < column.length; j++) {
      var cell = sheetObject
          .cell(CellIndex.indexByString(column[j] + (i + 1).toString()));
      if (j == 0) {
        cell.value = visitList[i].date;
      } else if (j == 1) {
        cell.value = visitList[i].nationality;
      } else if (j == 2) {
        cell.value = visitList[i].weekDay;
      } else if (j == 3) {
        cell.value = visitList[i].description;
      } else if (j == 4) {
        cell.value = visitList[i].pName;
      } else if (j == 5) {
        cell.value = visitList[i].lName;
      } else if (j == 6) {
        cell.value = visitList[i].idNo ?? "";
      }
    }
  }

  return excel;
}

void download(
  List<int> bytes, {
  String? downloadName,
}) {
  // Encode our file in base64
  final _base64 = base64Encode(bytes);
  // Create the link with the file
  final anchor =
      AnchorElement(href: 'data:application/octet-stream;base64,$_base64')
        ..target = 'blank';
  // add the name
  if (downloadName != null) {
    anchor.download = downloadName;
  }
  // trigger download
  document.body!.append(anchor);
  anchor.click();
  anchor.remove();
  return;
}
