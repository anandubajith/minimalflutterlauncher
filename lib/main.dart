import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:launcher_assist/launcher_assist.dart';

void main() => runApp(new MyApp());

// TODO: split the date and day?

class MyApp extends StatefulWidget {
  MyApp({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _timeString;

  @override
  void initState() {
    // hide status bar and navbar
    SystemChrome.setEnabledSystemUIOverlays([]);
    // force potrait orientation
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 10), (Timer t) => _getTime());
    super.initState();
  }

  Widget buttonForPackage(String packageName, String title) {
    return GestureDetector(
      onTap: () {
        _launchApp(packageName);
      },
      // onLongPress:() { _launchApp("com.google.android.contacts"); },
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Text(title,
            style: TextStyle(
              fontFamily: 'Comfortaa',
              fontSize: 30.0,
            )),
      ),
    );
  }

  Widget dateTimeWidget() {
    return GestureDetector(
        onTap: () {
          _launchApp("com.google.android.deskclock");
        },
        onLongPress: () {
          _launchApp("com.google.android.calendar");
        },
        child: Padding(
          padding: EdgeInsets.only(top: 100, bottom: 160),
          child: Text(
            _timeString ?? 'broken',
            style: TextStyle(
                fontFamily: 'Comfortaa', fontSize: 50.0, color: Colors.white),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.7],
            colors: [Colors.black, Colors.indigo[600]],
          ),
        ),
        child: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(children: <Widget>[
              dateTimeWidget(),
              buttonForPackage("com.google.android.dialer", "call"),
              buttonForPackage("com.google.android.gm", "gmail"),
              buttonForPackage("org.telegram.messenger", "telegram")
            ])
            ));
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return intl.DateFormat('kk:mm \nEEE d MMM').format(dateTime).toLowerCase();
  }

  void _launchApp(String packageName) {
    LauncherAssist.launchApp(packageName);
  }
}
