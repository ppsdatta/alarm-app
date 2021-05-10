import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm app',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Alarm'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class TimerPainter extends CustomPainter {
  int _current;
  int _total;

  TimerPainter(int current, int total) {
    _current = current;
    _total = total;
  }
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(Colors.green.shade200.value)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    var paint2 = Paint()
      ..color = Color(Colors.red.shade200.value)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    //draw arc
    canvas.drawArc(
        Offset(50, 50) & Size(100, 100),
        0, //radians
        2 * pi, //radians
        false,
        paint1);

    canvas.drawArc(
        Offset(50, 50) & Size(100, 100),
        -(pi / 2), //radians
        ((2 * pi) / _total) * _current, //radians
        false,
        paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _text = 'You have got';
  bool _running = true;
  final int _countDownValue = 60 * 2;

  void _incrementCounter() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_running) {
        timer.cancel();
        return;
      }

      if (timer.tick >= _countDownValue) {
        timer.cancel();
        setState(() {
          _counter = 0;
          _text = 'Sorry count down over!!';
        });
        return;
      }

      setState(() {
        // This call to setState tells the Flutter framework that something has
        // changed in this State, which causes it to rerun the build method below
        // so that the display can reflect the updated values. If we changed
        // _counter without calling setState(), then the build method would not be
        // called again, and so nothing would appear to happen.
        _counter++;
      });
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      _text = 'You have got';
      _running = true;
    });
  }

  void _stopCounter() {
    setState(() {
      _text = 'Counter stopped';
      _running = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              '$_text',
              style: Theme.of(context).textTheme.headline6,
            ),
            Container(
              width: 200,
              height: 200,
              child:
                  CustomPaint(painter: TimerPainter(_counter, _countDownValue)),
            ),
            Text(
              '${_countDownValue - _counter} s',
              style: Theme.of(context).textTheme.headline3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: _resetCounter,
                  tooltip: 'Reset counter',
                  child: Icon(Icons.replay),
                ),
                FloatingActionButton(
                  onPressed: _incrementCounter,
                  tooltip: 'Start counter',
                  child: Icon(Icons.play_arrow),
                ),
                FloatingActionButton(
                  onPressed: _stopCounter,
                  tooltip: 'Stop counting',
                  child: Icon(Icons.stop),
                )
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
