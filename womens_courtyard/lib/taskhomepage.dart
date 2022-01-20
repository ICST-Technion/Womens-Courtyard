import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore, QuerySnapshot;
import 'package:flutter/material.dart';
import 'package:womens_courtyard/task.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TaskHomePage extends StatefulWidget {
  @override
  _TaskHomePageState createState() {
    return _TaskHomePageState();
  }
}

class _TaskHomePageState extends State<TaskHomePage> {
  List<charts.Series<String, String>> _seriesPieData;
  List<String> mydata;
  _generateData(mydata) {
    _seriesPieData = [];
    _seriesPieData.add(
      charts.Series(
        domainFn: (String task, _) => task,
        measureFn: (String task, _) => 1,
        colorFn: (String task, _) =>
            charts.ColorUtil.fromDartColor(Color((task.hashCode * 0xFFFFFF)).withOpacity(1.0)),
        id: 'tasks',
        data: mydata,
        labelAccessorFn: (String row, _) => "$row",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tasks')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<String> last_names = snapshot.data.docs
              .map((documentSnapshot) => documentSnapshot.get("last_name"))
              .toList();
          return _buildChart(context, last_names);
        }
      },
    );
  }
  Widget _buildChart(BuildContext context, List<String> last_names) {
    mydata = last_names;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Time spent on daily tasks',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.PieChart(_seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 5),
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