import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore, QuerySnapshot;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:womens_courtyard/Nationality.dart';
import 'package:charts_flutter/flutter.dart' as charts;

const String NATION_FIELD = "לאום";
const String FIRST_NAME_FIELD = "שם פרטי";
const String LAST_NAME_FIELD = "שם משפחה";


class TaskHomePage extends StatefulWidget {
  @override
  _TaskHomePageState createState() {
    return _TaskHomePageState();
  }
}

class _TaskHomePageState extends State<TaskHomePage> {
  List<charts.Series<String, String>> _seriesPieData;
  // Map<String, int> nationalitiesHist;
  _generateData(Map<String, int> nationalitiesHist) {
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(title: Text('Tasks')),
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
          return _buildChart(context, nationalitiesHist);
        }
      },
    );
  }
  Widget _buildChart(BuildContext context, Map<String, int> nationalitiesHist) {
    // mydata = nationalitiesHist;
    _generateData(nationalitiesHist);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'התפלגות מוצא של צעירות',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
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
            ],
          ),
        ),
      ),
    );
  }
}