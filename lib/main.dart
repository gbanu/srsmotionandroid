import 'package:flutter/material.dart';

import 'package:untitled/session_screen/session_screen.dart';
import 'package:untitled/task3.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context)=>Task3(title: 'SRS Motion'),
      },
    );
  }
}

