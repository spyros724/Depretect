import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'statistics.dart';
import 'package:url_launcher/url_launcher.dart';
import 'statistics.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

final List<Message> _messages = [
  Message("Hi, nice to meet you! Text me anything to start a conversation!",
      "Q", DateTime(2012, 12, 12), 0.0)
];

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
  List<Message> get messages => _messages;
}

class _MessagerWidgetState extends State<MessagerWidget> {
  int _selectedIndex = 0;

  final List<Message> _questions = [
    Message("Q1", "Q", DateTime(2012, 12, 12), 0.0),
    Message("Q2", "Q", DateTime(2012, 12, 12), 0.0),
    Message("Q3", "Q", DateTime(2012, 12, 12), 0.0),
    Message("Q4", "Q", DateTime(2012, 12, 12), 0.0),
    Message("Q5", "Q", DateTime(2012, 12, 12), 0.0),
    Message("Q6", "Q", DateTime(2012, 12, 12), 0.0),
    Message("Q7", "Q", DateTime(2012, 12, 12), 0.0),
    Message("Q8", "Q", DateTime(2012, 12, 12), 0.0),
    Message("Q9", "Q", DateTime(2012, 12, 12), 0.0),
    Message("Q10", "Q", DateTime(2012, 12, 12), 0.0),
    Message("Q11", "Q", DateTime(2012, 12, 12), 0.0),
    Message("Q12", "Q", DateTime(2012, 12, 12), 0.0),
    Message("Q13", "Q", DateTime(2012, 12, 12), 0.0),
    Message("Q14", "Q", DateTime(2012, 12, 12), 0.0),
    Message("Q15", "Q", DateTime(2012, 12, 12), 0.0),
    Message("Q16", "Q", DateTime(2012, 12, 12), 0.0),
  ];

  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage(String message) {
    _scrollToBottom();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(Message(message, "A", DateTime.now(), getRandomFloat()));
        _messages.add(_questions[
            (((_messages.length / 2) - 1).toInt()) % _questions.length]);
        _scrollToBottom();
      });

      /* simulate a response from the chatbot
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _messages.add(Message(
              "I'm sorry, I can't help with that", MessageType.received));
          _scrollToBottom();
        });
        _scrollToBottom();
      }); */

      _textEditingController.clear();
    }
  }

  double getRandomFloat() {
    Random random = new Random();
    return random.nextDouble();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _onItemTapped(int index) async {
    if (index == 1) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => StatisticsWidget(
                  messages: widget.messages,
                )),
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Align(
                    alignment: message.type == "A"
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: message.type == "A"
                            ? Colors.blue
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      child: Text(message.text),
                    ),
                  ),
                );
              },
            ),
          ),
          /*
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          ),*/
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      onSubmitted: (message) {
                        _sendMessage(message);
                        _scrollToBottom();
                      }),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_textEditingController.text);
                    _scrollToBottom();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollController.jumpTo(_scrollController.position
                          .maxScrollExtent); // Jump to the end of the list
                    });
                  },
                ),
              ],
            ),
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
/*
enum MessageType {
  sent,
  received,
}*/

class Message {
  final String text;
  final String type;
  final DateTime date;
  final double value;

  Message(this.text, this.type, this.date, this.value);
}
