//import 'dart:html';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

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
      body: Center(
          child: Container(
              padding: EdgeInsets.all(10),
              height: 200,
              width: 300,
              child: Stack(children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Sparkline(
                      data: chart_data,
                      lineGradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.red,
                          Colors.lightBlue,
                        ],
                        stops: [
                          0.5,
                          0.5,
                        ],
                      )),
                ),
              ]))),
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
