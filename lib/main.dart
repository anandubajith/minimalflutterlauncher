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
        launchApp(packageName);
      },
      onLongPress:() { launchApp("com.google.android.contacts"); },
      child: Container(
        padding: EdgeInsets.all(12.0),
        child:Text(title,
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 30.0,
                )
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 0.7],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.black,
              Colors.indigo[600]
            ],
          ),
        ),
        // padding: EdgeInsets.all(25.0),
        child: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 100, bottom: 160),
                child: Text(
                    _timeString ?? 'broken',
                    
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 50.0,
                        color: Colors.white),
                  ),
              ),

              buttonForPackage("com.google.android.dialer", "call"),
              buttonForPackage("com.google.android.gm", "gmail"),
              buttonForPackage("org.telegram.messenger", "telegram")
            ])));
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

  void launchApp(String packageName) {
    LauncherAssist.launchApp(packageName);
  }
}
