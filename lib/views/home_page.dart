// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var formKey = GlobalKey<FormState>();

  int? glicemiaMatinal;
  int? glicemiaPreAlmoco;
  int? glicemiaPosAlmoco;
  int? glicemiaPreJanta;
  int? glicemiaPosJanta;
  int? glicemiaNoturna;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  DateTime date = DateTime.now();

  void salvar(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      firestore.collection('Glicemia').add({
        'dia': date.day,
        'mes': date.month,
        'ano': date.year ,
        'matinal': glicemiaMatinal,
        'preAlmoco': glicemiaPreAlmoco,
        'posAlmoco': glicemiaPosAlmoco,
        'preJanta': glicemiaPreJanta,
        'posJanta': glicemiaPosJanta,
        'noturna': glicemiaNoturna,
        // 'uid': auth.currentUser!.uid,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Image.asset(
            'assets/logo_sag.jpg',
            width: 5,
            height: 5,
          ),
          automaticallyImplyLeading: false,
          title: Text('Glicemia de hoje'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                heroTag: 'btnX',
                onPressed: () => Navigator.of(context).pushNamed('/login'),
                // backgroundColor: Colors.black26,
                elevation: 0,
                child: Icon(Icons.logout),
              ),
            ),
          ],
        ),
        body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              bolinhaDosValores(
                  context, glicemiaMatinal, 'Glicemia Matinal', 'Ao acordar'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  bolinhaDosValores(context, glicemiaPreAlmoco,
                      'Glicemia pré-prandial', 'Almoço'),
                  bolinhaDosValores(context, glicemiaPosAlmoco,
                      'Glicemia pós-prandial', 'Almoço'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  bolinhaDosValores(context, glicemiaPreJanta,
                      'Glicemia pré-prandial', 'Jantar'),
                  bolinhaDosValores(context, glicemiaPosJanta,
                      'Glicemia pós-prandial', 'Jantar'),
                ],
              ),
              bolinhaDosValores(context, glicemiaNoturna, 'Glicemia Noturna',
                  'Antes de dormir'),
              ElevatedButton(onPressed: () => salvar(context), child: Text('Registrar'))
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 50,
          width: 10,
          color: Colors.blue[50],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.today),
                tooltip: 'Hoje',
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/historico');
                },
                icon: Icon(Icons.history),
                tooltip: 'Histórico',
              ),
            ],
          ),
        ));
  }
}

Container bolinhaDosValores(context, glicemia, rotina, refeicao) {
  return Container(
    height: 120,
    width: 120,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.lightBlue,
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          valoresGlicemia(glicemia),
          SizedBox(
            height: 10,
          ),
          sumarioRotina(rotina),
          SizedBox(
            height: 5,
          ),
          prandial(refeicao),
        ],
      ),
    ),
  );
}

RichText prandial(refeicao) {
  return RichText(
    text: TextSpan(
      text: refeicao,
      style: TextStyle(
        fontSize: 10,
        color: Colors.white,
      ),
    ),
  );
}

RichText sumarioRotina(rotina) {
  return RichText(
    text: TextSpan(
      text: rotina,
      style: TextStyle(
        fontSize: 10,
        color: Colors.white,
      ),
    ),
  );
}

SizedBox valoresGlicemia(glicemia) {
  return SizedBox(
    height: 50,
    width: 50,
    child: TextFormField(
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
        color: Colors.white,
      ),
      keyboardType: TextInputType.number,
      onSaved: (value) => glicemia = value!,
    ),
  );
}

// RichText valoresGlicemia(glicemia) {
//   return RichText(
//     text: TextSpan(
//       text: glicemia,
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 40,
//         color: Colors.white,
//       ),
//     ),
//   );
// }
