// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sag/views/historico_page.dart';
import 'package:sag/views/home_page.dart';
import 'package:sag/views/login_page.dart';
import 'package:sag/views/register_page.dart';

const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyAPmJJWkb6eUKr5ZOPEJbibwrq3wMC32B8",
  authDomain: "sagv2-2b1b6.firebaseapp.com",
  projectId: "sagv2-2b1b6",
  storageBucket: "sagv2-2b1b6.appspot.com",
  messagingSenderId: "1020318080893",
  appId: "1:1020318080893:web:353f38d18b050cfd29f614",
);

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //faz a o aplicativo esperar conectar com firebase
  await Firebase.initializeApp(
      options: firebaseConfig); //conecta o app com o firebase
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
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => LoginPage(),
          '/home': (BuildContext context) => HomePage(),
          '/historico': (BuildContext context) => HistoricoPage(),
          '/cadastro': (BuildContext context) => RegisterPage(),
        });
  }
}
