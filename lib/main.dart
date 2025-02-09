import 'package:flutter/material.dart';
import 'package:on_duty/Login.dart';
import 'package:on_duty/test.dart';
import 'package:on_duty/lol.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Login()
    );
  }
}

