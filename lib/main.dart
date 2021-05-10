import 'dart:async';
import 'dart:io';
//import 'dart:html';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:vibration/vibration.dart';

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
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Alarm'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

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
  final int _countDownValue = 60 * 1;

  void _incrementCounter() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_running) {
        timer.cancel();
        return;
      }

      if (_counter >= _countDownValue) {
        timer.cancel();
        setState(() {
          _counter = 0;
          _text = 'Sorry count down over!!';
          if (Platform.isAndroid) {
            FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_ABBR_ALERT);
          } else if (Platform.isIOS) {
            FlutterBeep.playSysSound(iOSSoundIDs.AudioToneError);
          }
        });
        return;
      }

      setState(() {
        _text = 'You have got';
        _counter++;
      });

      if (_countDownValue - _counter <= 30) {
        if (!kIsWeb) {
          FlutterBeep.beep();
          Vibration.vibrate();
        }
      }
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
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
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
