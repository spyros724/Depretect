import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'statistics.dart';
import 'package:url_launcher/url_launcher.dart';
import 'statistics.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    //initializing commands
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Depretect',
      home: const MessagerWidget(),
    );
  }
}

class MessagerWidget extends StatefulWidget {
  const MessagerWidget({Key? key}) : super(key: key);

  @override
  _MessagerWidgetState createState() => _MessagerWidgetState();
}

class _MessagerWidgetState extends State<MessagerWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) async {
    if (index == 1) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StatisticsWidget()),
        //TO DO: parkingspots: widget.parkingspots
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
            },
            icon: Icon(Icons.local_hospital)),
        title: Text('Depretect'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 50),
        child: Text(
          'You idiot cat :<|',
          style: TextStyle(color: Colors.black, fontSize: 20.0),
        ),
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
