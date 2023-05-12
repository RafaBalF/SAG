// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sag/views/create_page.dart';
import 'package:sag/views/historico_page.dart';
import 'package:sag/views/home_page.dart';
import 'package:sag/views/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SAG',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
      routes: <String, WidgetBuilder> {
      '/login': (BuildContext context) => LoginPage(),
      '/home': (BuildContext context) => HomePage(),
      '/historico': (BuildContext context) => HistoricoPage(),
      '/create': (BuildContext context) => CreatePage()
      }
    );
  }
}