// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({
    super.key,
    // required this.matinal,
    // required this.preAlmoco,
    // required this.posAlmoco,
    // required this.preJanta,
    // required this.posJanta,
    // required this.noturna,
  });

  // final int matinal;
  // final int preAlmoco;
  // final int posAlmoco;
  // final int preJanta;
  // final int posJanta;
  // final int noturna;

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
    final data = ModalRoute.of(context)?.settings.arguments as Map;

    var id = data["id"];
    var matinalValue = data["matinal"];
    var preAlmocoValue = data["preAlmoco"];
    var posAlmocoValue = data["posAlmoco"];
    var preJantaValue = data["preJanta"];
    var posJantaValue = data["posJanta"];
    var noturnaValue = data["noturna"];

    return Scaffold(
      appBar: AppBar(
        title: Text('Atualizar'),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 150,
          child: Form(
            key: formKey1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                bolinhaDosValores(context, matinal(matinalValue),
                    'Glicemia Matinal', 'Ao acordar'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    bolinhaDosValores(context, preAlmoco(preAlmocoValue),
                        'Glicemia pré-prandial', 'Almoço'),
                    bolinhaDosValores(context, posAlmoco(posAlmocoValue),
                        'Glicemia pós-prandial', 'Almoço'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    bolinhaDosValores(context, preJanta(preJantaValue),
                        'Glicemia pré-prandial', 'Jantar'),
                    bolinhaDosValores(context, posJanta(posJantaValue),
                        'Glicemia pós-prandial', 'Jantar'),
                  ],
                ),
                bolinhaDosValores(context, noturna(noturnaValue),
                    'Glicemia Noturna', 'Antes de dormir'),
                ElevatedButton(
                    onPressed: () {
                      update(id);
                    },
                    child: Text('Atualizar'))
              ],
            ),
          ),
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
        color: Colors.green,
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

  SizedBox matinal(matinalValue) {
    return SizedBox(
      height: 50,
      width: 50,
      child: TextFormField(
          initialValue: matinalValue.toStringAsFixed(0),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value == null || value.isEmpty) {
              value = '0';
            }
            glicemiaMatinal = int.parse(value);
          }),
    );
  }

  SizedBox preAlmoco(preAlmocoValue) {
    return SizedBox(
      height: 50,
      width: 50,
      child: TextFormField(
          initialValue: preAlmocoValue.toStringAsFixed(0),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value == null || value.isEmpty) {
              value = '0';
            }
            glicemiaPreAlmoco = int.parse(value);
          }),
    );
  }

  SizedBox posAlmoco(posAlmocoValue) {
    return SizedBox(
      height: 50,
      width: 50,
      child: TextFormField(
          initialValue: posAlmocoValue.toStringAsFixed(0),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value == null || value.isEmpty) {
              value = '0';
            }
            glicemiaPosAlmoco = int.parse(value);
          }),
    );
  }

  SizedBox preJanta(preJantaValue) {
    return SizedBox(
      height: 50,
      width: 50,
      child: TextFormField(
          initialValue: preJantaValue.toStringAsFixed(0),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value == null || value.isEmpty) {
              value = '0';
            }
            glicemiaPreJanta = int.parse(value);
          }),
    );
  }

  SizedBox posJanta(posJantaValue) {
    return SizedBox(
      height: 50,
      width: 50,
      child: TextFormField(
          initialValue: posJantaValue.toStringAsFixed(0),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value == null || value.isEmpty) {
              value = '0';
            }
            glicemiaPosJanta = int.parse(value);
          }),
    );
  }

  SizedBox noturna(noturnaValue) {
    return SizedBox(
      height: 50,
      width: 50,
      child: TextFormField(
          initialValue: noturnaValue.toStringAsFixed(0),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value == null || value.isEmpty) {
              value = '0';
            }
            glicemiaNoturna = int.parse(value);
          }),
    );
  }
}
