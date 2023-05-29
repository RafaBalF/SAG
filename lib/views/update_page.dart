// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  var formKey1 = GlobalKey<FormState>();

  int glicemiaMatinal = 0;
  int glicemiaPreAlmoco = 0;
  int glicemiaPosAlmoco = 0;
  int glicemiaPreJanta = 0;
  int glicemiaPosJanta = 0;
  int glicemiaNoturna = 0;

  bool? controleRegistroHoje;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  final glicemiaTextController = TextEditingController();

  DateTime date = DateTime.now();

  void update(id) {
    if (formKey1.currentState!.validate()) {
      formKey1.currentState!.save();
      firestore.collection('Glicemia').doc(id).update({
        'matinal': glicemiaMatinal,
        'preAlmoco': glicemiaPreAlmoco,
        'posAlmoco': glicemiaPosAlmoco,
        'preJanta': glicemiaPreJanta,
        'posJanta': glicemiaPosJanta,
        'noturna': glicemiaNoturna,
        'uid': auth.currentUser!.uid,
      });
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Object? data = ModalRoute.of(context)?.settings.arguments;

    var id = data;

    print(id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Atualizar'),
      ),
      body: Form(
        key: formKey1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            bolinhaDosValores(
                context, matinal(), 'Glicemia Matinal', 'Ao acordar'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                bolinhaDosValores(
                    context, preAlmoco(), 'Glicemia pré-prandial', 'Almoço'),
                bolinhaDosValores(
                    context, posAlmoco(), 'Glicemia pós-prandial', 'Almoço'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                bolinhaDosValores(
                    context, preJanta(), 'Glicemia pré-prandial', 'Jantar'),
                bolinhaDosValores(
                    context, posJanta(), 'Glicemia pós-prandial', 'Jantar'),
              ],
            ),
            bolinhaDosValores(
                context, noturna(), 'Glicemia Noturna', 'Antes de dormir'),
            ElevatedButton(
                onPressed: () {
                  update(id);
                  controleRegistroHoje = true;
                },
                child: Text('Atualizar'))
          ],
        ),
      ),
    );
  }

  Container bolinhaDosValores(context, SizedBox glicemia, rotina, refeicao) {
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
            glicemia,
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

  SizedBox matinal() {
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
        onSaved: (value) => glicemiaMatinal = int.parse(value!),
      ),
    );
  }

  SizedBox preAlmoco() {
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
        onSaved: (value) => glicemiaPreAlmoco = int.parse(value!),
      ),
    );
  }

  SizedBox posAlmoco() {
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
        onSaved: (value) => glicemiaPosAlmoco = int.parse(value!),
      ),
    );
  }

  SizedBox preJanta() {
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
        onSaved: (value) => glicemiaPreJanta = int.parse(value!),
      ),
    );
  }

  SizedBox posJanta() {
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
        onSaved: (value) => glicemiaPosJanta = int.parse(value!),
      ),
    );
  }

  SizedBox noturna() {
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
        onSaved: (value) => glicemiaNoturna = int.parse(value!),
      ),
    );
  }
}
