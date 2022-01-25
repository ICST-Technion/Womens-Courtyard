import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore, QuerySnapshot, Timestamp;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:womens_courtyard/Nationality.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

const String NATION_FIELD = "לאום";
const String FIRST_NAME_FIELD = "שם פרטי";
const String LAST_NAME_FIELD = "שם משפחה";
const String VISITS_FIELD = "ביקורים";
const Map<int, String> WEEKDAYS = <int, String>{
  1: 'שני',
  2: 'שלישי',
  3: 'רביעי',
  4: 'חמישי',
  5: 'שישי',
  6: 'שבת',
  7: 'ראשון',
};
class TaskHomePage extends StatefulWidget {
  @override
  _TaskHomePageState createState() {
    return _TaskHomePageState();
  }
}

class _TaskHomePageState extends State<TaskHomePage> {
  List<charts.Series<String, String>> _seriesPieData;
  List<charts.Series<String, String>> _seriesBarData;
  // Map<String, int> nationalitiesHist;
  _generatePieChartData(Map<String, int> nationalitiesHist) {
    // List<Nationality> nationatilies = Nationality.makeNationalitiesList(nationalitiesHist);
    _seriesPieData = [];
    _seriesPieData.add(
      charts.Series(
        domainFn: (String nat, _) => nat,
        measureFn: (String nat, _){
          return nationalitiesHist[nat];
        },
        colorFn: (String nat, _) =>
            charts.ColorUtil.fromDartColor(Color((nat.hashCode * 0xFFFFFF)).withOpacity(1.0)),
        id: 'התפלגות אוכלוסיה',
        data: nationalitiesHist.keys.toList(),
        labelAccessorFn: (String row, _) => "$row",
      ),
    );
  }
  _generateBarChartData(Map<String, int> weekdaysHist) {
    // List<Nationality> nationatilies = Nationality.makeNationalitiesList(nationalitiesHist);
    _seriesBarData = [];
    _seriesBarData.add(
      charts.Series(
        domainFn: (String weekday, _) => weekday,
        measureFn: (String weekday, _) => weekdaysHist[weekday],
        colorFn: (String nat, _) =>
            charts.ColorUtil.fromDartColor(Color((nat.hashCode * 0xFFFFFF)).withOpacity(1.0)),
        id: 'התפלגות ביקורים',
        data: weekdaysHist.keys.toList(),
        labelAccessorFn: (String row, _) => "$row",
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(title: Text('סטטיסטיקה')),
          body: _buildBody(context),
        );
      }
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          var givenSnapshots = snapshot.data.docs.toList();

          var nationalitiesHist = Map<String,int>();
          print("starting to generate nationalities");
          givenSnapshots.map<String>((documentSnapshot) => documentSnapshot.get(NATION_FIELD)).forEach((nationality) {
            if(!nationalitiesHist.containsKey(nationality)) {
              nationalitiesHist[nationality] = 1;
            } else {
              nationalitiesHist[nationality] +=1;
            }
          }
        );
          print("nationalities: $nationalitiesHist, type: ${nationalitiesHist.runtimeType}");

          var visitsHist = Map<String, int>();
          WEEKDAYS.entries.forEach((dayMap) {
            visitsHist[dayMap.value] = 0;
          });
          print("finished initializing maps");
          givenSnapshots.map<List<Timestamp>>((documentSnapshot) {
            print("type: ${documentSnapshot.get(VISITS_FIELD).runtimeType}");
            return List.from(documentSnapshot.get(VISITS_FIELD));
          }).forEach((visits) {
            visits.forEach((timeStamp) {
                visitsHist[WEEKDAYS[timeStamp.toDate().weekday]] +=1;
            });
          });
          // return _buildPieChart(context, nationalitiesHist);
          // return _buildBarChart(context, visitsHist);
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: <Widget>[
                    _buildPieChart(context, nationalitiesHist),
                    _buildBarChart(context, visitsHist)
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
  Widget _buildPieChart(BuildContext context, Map<String, int> nationalitiesHist) {
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
                      cellPadding:
                      new EdgeInsets.only(right: 4.0, bottom: 4.0,top:4.0),
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
              child: charts.BarChart(_seriesBarData,
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

}