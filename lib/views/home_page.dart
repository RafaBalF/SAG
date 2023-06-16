// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var formKey1 = GlobalKey<FormState>();

  int glicemiaMatinal = 0;
  int glicemiaPreAlmoco = 0;
  int glicemiaPosAlmoco = 0;
  int glicemiaPreJanta = 0;
  int glicemiaPosJanta = 0;
  int glicemiaNoturna = 0;

  int? controleRegistroHojeDia = 0;
  String? controleRegistroHojeUsuario = '';

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  DateTime date = DateTime.now();

  void salvar(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    firestore
        .collection('Glicemia')
        .where('dia', isEqualTo: date.day)
        .where('mes', isEqualTo: date.month)
        .where('ano', isEqualTo: date.year)
        .where('uid', isEqualTo: auth.currentUser!.uid)
        .get()
        .then(
      (querySnapshot) {
        print("Successfully completed");
        print('documetno2 ${querySnapshot.docs.isEmpty}');

        if (querySnapshot.docs.isNotEmpty) {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('Atenção'),
                content: Text('Registro de hoje ja efetuado'),
              );
            },
          );
        } else {
          if (formKey1.currentState!.validate()) {
            formKey1.currentState!.save();

            firestore.collection('Glicemia').add({
              'dia': date.day,
              'mes': date.month,
              'ano': date.year,
              'matinal': glicemiaMatinal,
              'preAlmoco': glicemiaPreAlmoco,
              'posAlmoco': glicemiaPosAlmoco,
              'preJanta': glicemiaPreJanta,
              'posJanta': glicemiaPosJanta,
              'noturna': glicemiaNoturna,
              'uid': auth.currentUser!.uid,
            });

            formKey1.currentState?.reset();

            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text('Atenção'),
                  content: Text('Registro efetuado com sucesso'),
                );
              },
            );
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    await prefs.remove('controleRegistroHoje');
    await prefs.remove('controleRegistroHojeDia');
    await prefs.remove('controleRegistroHojeUsuario');
  }

  void logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('autoLogin');

      await auth.signOut();

      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    } catch (e) {}
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
                onPressed: () => logout(context),
                // backgroundColor: Colors.black26,
                elevation: 0,
                child: Icon(Icons.logout),
              ),
            ),
          ],
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
                  bolinhaDosValores(
                      context, matinal(), 'Glicemia Matinal', 'Ao acordar'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      bolinhaDosValores(context, preAlmoco(),
                          'Glicemia pré-prandial', 'Almoço'),
                      bolinhaDosValores(context, posAlmoco(),
                          'Glicemia pós-prandial', 'Almoço'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      bolinhaDosValores(context, preJanta(),
                          'Glicemia pré-prandial', 'Jantar'),
                      bolinhaDosValores(context, posJanta(),
                          'Glicemia pós-prandial', 'Jantar'),
                    ],
                  ),
                  bolinhaDosValores(context, noturna(), 'Glicemia Noturna',
                      'Antes de dormir'),
                  ElevatedButton(
                      onPressed: () {
                        salvar(context);
                      },
                      child: Text('Registrar'))
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 50,
          width: 10,
          color: Colors.blue[50],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 80,
                decoration: BoxDecoration(
                  // color: Colors.lightBlueAccent,
                  border: Border(
                    // bottom: BorderSide(color: Colors.black, width: 2),
                    top: BorderSide(color: Colors.lightBlueAccent, width: 10),
                    // left: BorderSide(color: Colors.black, width: 2),
                    // right: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.today,
                    color: Colors.lightBlueAccent,
                  ),
                  tooltip: 'Hoje',
                ),
              ),
              Container(
                width: 80,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/historico');
                  },
                  icon: Icon(Icons.history),
                  tooltip: 'Histórico',
                ),
              ),
            ],
          ),
        ));
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
          onSaved: (value) {
            if (value == null || value.isEmpty) {
              value = '0';
            }
            glicemiaMatinal = int.parse(value);
          }),
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
          onSaved: (value) {
            if (value == null || value.isEmpty) {
              value = '0';
            }
            glicemiaPreAlmoco = int.parse(value);
          }),
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
          onSaved: (value) {
            if (value == null || value.isEmpty) {
              value = '0';
            }
            glicemiaPosAlmoco = int.parse(value);
          }),
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
          onSaved: (value) {
            if (value == null || value.isEmpty) {
              value = '0';
            }
            glicemiaPreJanta = int.parse(value);
          }),
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
          onSaved: (value) {
            if (value == null || value.isEmpty) {
              value = '0';
            }
            glicemiaPosJanta = int.parse(value);
          }),
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
          onSaved: (value) {
            if (value == null || value.isEmpty) {
              value = '0';
            }
            glicemiaNoturna = int.parse(value);
          }),
    );
  }
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
