//import 'dart:html';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatisticsWidget extends StatefulWidget {
  final List<Message> messages;
  const StatisticsWidget({Key? key, required this.messages}) : super(key: key);

  @override
  _StatisticsWidgetState createState() => _StatisticsWidgetState();
}

class _StatisticsWidgetState extends State<StatisticsWidget> {
  int _selectedIndex = 1;

  List<double> chart_data = [0.2, 0.5, 0.8, 0.3, 0.6, 0.9, 0.1, 0.4, 0.7];

/*
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
*/

  void _onItemTapped(int index) async {
    if (index == 0) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MessagerWidget()),
      );
    }
  }

  List<charts.Series<DayAverage, DateTime>> createChartData(
      List<DayAverage> dayAverages) {
    return [
      charts.Series<DayAverage, DateTime>(
        id: 'DayAverages',
        colorFn: (dayAverage, _) => dayAverage.average > 0.5
            ? charts.MaterialPalette.red.shadeDefault
            : charts.MaterialPalette.blue.shadeDefault,
        domainFn: (dayAverage, _) => dayAverage.date,
        measureFn: (dayAverage, _) => dayAverage.average,
        data: dayAverages,
      ),
    ];
  }

  List<DayAverage> calculateDayAverages(List<Message> messages) {
    final Map<DateTime, List<Message>> messagesByDay = {};
    for (final message in messages) {
      final date =
          DateTime(message.date.year, message.date.month, message.date.day);
      if (!messagesByDay.containsKey(date)) {
        messagesByDay[date] = [];
      }
      messagesByDay[date]?.add(message);
    }
    return messagesByDay.entries.map((entry) {
      final date = entry.key;
      final messages = entry.value;
      final totalValue =
          messages.fold(0.0, (sum, message) => sum + message.value);
      final average = totalValue / messages.length;
      return DayAverage(date, average);
    }).toList();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Messager',
    ),
    Text(
      'Statistics',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final dayAverages = calculateDayAverages(widget.messages);
    final chartData = createChartData(dayAverages);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        leading: IconButton(
            onPressed: () {
              launch('https://igem.org/');
              print(widget.messages);
            },
            icon: Icon(Icons.local_hospital)),
        title: Text('Depretect'),
      ),
      body: charts.TimeSeriesChart(
        chartData,
        animate: true,
        behaviors: [
          charts.SeriesLegend(
            position: charts.BehaviorPosition.bottom,
            horizontalFirst: false,
            cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
            showMeasures: true,
            legendDefaultMeasure: charts.LegendDefaultMeasure.average,
            //measureFormatter: (num ?value) => value.toStringAsFixed(2),
            entryTextStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.black,
              fontSize: 12,
              fontFamily: 'Roboto',
              fontWeight: 'light',
            ),
          ),
        ],
        primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec:
              charts.BasicNumericTickProviderSpec(desiredTickCount: 5),
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.gray.shade400,
              fontSize: 12,
              fontFamily: 'Roboto',
              fontWeight: 'light',
            ),
            lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shade200,
            ),
          ),
        ),
        domainAxis: charts.DateTimeAxisSpec(
          tickProviderSpec: charts.DayTickProviderSpec(increments: [1]),
          renderSpec: charts.SmallTickRendererSpec<DateTime>(
            labelStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.gray.shade400,
              fontSize: 12,
              fontFamily: 'Roboto',
              fontWeight: 'light',
            ),
            lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shade200,
            ),
          ),
        ),
        defaultRenderer: charts.LineRendererConfig(
          includePoints: true,
          includeArea: true,
          stacked: true,
        ),
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        selectionModels: [
          charts.SelectionModelConfig(
            changedListener: (charts.SelectionModel model) {
              if (model.hasDatumSelection) {
                print(model.selectedSeries[0]
                    .measureFn(model.selectedDatum[0].index));
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 2, 2, 2),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Messager',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Statistics',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.white,
        selectedItemColor: Color.fromARGB(255, 177, 57, 216),
        onTap: _onItemTapped,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DayAverage {
  final DateTime date;
  final double average;

  DayAverage(this.date, this.average);
}
