//import 'dart:html';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';

class StatisticsWidget extends StatefulWidget {
  final List<Message> messages;
  const StatisticsWidget({Key? key, required this.messages}) : super(key: key);

  @override
  _StatisticsWidgetState createState() => _StatisticsWidgetState();
}

class _StatisticsWidgetState extends State<StatisticsWidget> {
  int _selectedIndex = 1;
  DateTime _date = DateTime.now();
  bool _visibledate = false;

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

/*
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
*/
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

  void _showdate() async {
    /// Εμφάνιση του time picker [showTimePicker] και αποθήκευση του αποτελέσμα-
    /// τος στην μεταβλητή [result] (τύπου [TimeOfDay]). Καθώς ο χρήστης μπορεί
    /// να πατήσει cancel, η μεταβλητή αυτή μπορεί να γίνει και null
    final DateTime? result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023, 1),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color.fromARGB(255, 230, 201, 235), // <-- SEE HERE
              onPrimary: Colors.pink, // <-- SEE HERE
              onSurface: Colors.grey, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary:
                    Color.fromARGB(255, 219, 161, 229), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    /// Στην περίπτωση που ο χρήστης έχει επιλέξει ώρα alarm, ενημέρωσε την
    /// κατάσταση του [Widget], θέτοντας την ώρα στη μεταβλητή [_alarmTime]
    /// και θέτοντας το boolean flag [_visibleAlarmTime] σε true
    if (result != null) {
      setState(() {
        _date = result;
        _date = DateTime(_date.year, _date.month, _date.day);
        _visibledate = true;
      });
    }
  }

  /*

  List<double> _calculateDailyAverages(List<Message> messages) {
    // calculate daily averages
    Map<DateTime, List<double>> dailyValues = {};
    for (Message message in messages) {
      DateTime date = message.date;
      double value = message.value;
      dailyValues.update(date, (values) => [...values, value],
          ifAbsent: () => [value]);
    }
    List<double> dailyAverages = [];
    for (DateTime date in dailyValues.keys) {
      List<double> values = dailyValues[date]!;
      double average = values.reduce((a, b) => a + b) / values.length;
      dailyAverages.add(average);
    }
    return dailyAverages;
  }

  List<dynamic> _formatChartData(List<double> dailyAverages) {
    // format data for chart
    List<String> xValues = [];
    List<double> yValues = [];
    for (int i = 0; i < dailyAverages.length; i++) {
      DateTime date = widget.messages[i].date;
      String dateString = '${date.year}-${date.month}-${date.day}';
      xValues.add(dateString);
      yValues.add(dailyAverages[i]);
    }
    return [xValues, yValues];
  }
  */

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Messager',
    ),
    Text(
      'Statistics',
    ),
  ];

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<Message> messagesWithDateOnly = widget.messages.map((message) {
      DateTime dateOnly =
          DateTime(message.date.year, message.date.month, message.date.day);
      return Message(message.text, message.type, dateOnly, message.value);
    }).toList();

    final dayAverages = calculateDayAverages(widget.messages);
    messagesWithDateOnly = messagesWithDateOnly.reversed.toList();
    List<Message> filteredMessages =
        messagesWithDateOnly.where((message) => message.date == _date).toList();
    List<DayAverage> reversedAverages = dayAverages.reversed.toList();

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
      body: Column(children: [
        Padding(
            padding: EdgeInsets.all(10),
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: reversedAverages.length,
                itemBuilder: (BuildContext context, int index) {
                  String subtitleText = '';

                  if (reversedAverages[index].average > 0.5) {
                    subtitleText = 'Above average';
                  } else {
                    subtitleText = 'Below average';
                  }

                  return ListTile(
                    title: Text(
                        '${reversedAverages[index].date.day}/${reversedAverages[index].date.month}/${reversedAverages[index].date.year}'),
                    subtitle: Text(subtitleText),
                  );
                },
              ),
            )),
        Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Select a date... How were you feeling back then?',
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _showdate,
                      icon: Icon(Icons.calendar_month),
                      tooltip: 'Add date',
                    ),
                    Visibility(
                        visible: _visibledate,
                        child: Text(_date != null
                            ? '${_date.day}/${_date.month}/${_date.year}'
                            : '')),
                  ],
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    reverse: false,
                    controller: _scrollController1,
                    itemCount: filteredMessages.length,
                    itemBuilder: (context, index) {
                      final message = filteredMessages[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Align(
                          alignment: message.type == "A"
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: message.type == "A"
                                  ? Colors.blue
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8.0),
                            child: Text(message.text),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
      ]),
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
