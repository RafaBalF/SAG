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

  double glicemiaMatinal = 0;
  double glicemiaPreAlmoco = 0;
  double glicemiaPosAlmoco = 0;
  double glicemiaPreJanta = 0;
  double glicemiaPosJanta = 0;
  double glicemiaNoturna = 0;

  int? controleRegistroHojeDia = 0;
  String? controleRegistroHojeUsuario = '';

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  DateTime date = DateTime.now();

  void salvar(BuildContext context) async {
    firestore
        .collection('Glicemia')
        .where('dia', isEqualTo: date.day)
        .where('mes', isEqualTo: date.month)
        .where('ano', isEqualTo: date.year)
        .where('uid', isEqualTo: auth.currentUser!.uid)
        .get()
        .then(
      (querySnapshot) async {
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

            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('fatorMatinal');
            await prefs.remove('fatorPreAlmoco');
            await prefs.remove('fatorPosAlmoco');
            await prefs.remove('fatorPreJanta');
            await prefs.remove('fatorPosJanta');
            await prefs.remove('fatorNoturna');

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
  }

  void logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('autoLogin');
      await prefs.remove('fatorMatinal');
      await prefs.remove('fatorPreAlmoco');
      await prefs.remove('fatorPosAlmoco');
      await prefs.remove('fatorPreJanta');
      await prefs.remove('fatorPosJanta');
      await prefs.remove('fatorNoturna');

      await auth.signOut();

      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    } catch (e) {}
  }

  navegar(fator) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fator', fator);
    Navigator.of(context).pushNamed('/calculo');
  }

  getGlicemia() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      glicemiaMatinal = prefs.getDouble('fatorMatinal') ?? 0;
      glicemiaPreAlmoco = prefs.getDouble('fatorPreAlmoco') ?? 0;
      glicemiaPosAlmoco = prefs.getDouble('fatorPosAlmoco') ?? 0;
      glicemiaPreJanta = prefs.getDouble('fatorPreJanta') ?? 0;
      glicemiaPosJanta = prefs.getDouble('fatorPosJanta') ?? 0;
      glicemiaNoturna = prefs.getDouble('fatorNoturna') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    getGlicemia();
    return Scaffold(
        appBar: AppBar(
          leading: Image.asset(
            'assets/logo_sag.jpeg',
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
                  bolinhaDosValores(context, glicemiaMatinal,
                      'Glicemia Matinal', 'Ao acordar', 'matinal'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      bolinhaDosValores(context, glicemiaPreAlmoco,
                          'Glicemia pré-prandial', 'Almoço', 'preAlmoco'),
                      bolinhaDosValores(context, glicemiaPosAlmoco,
                          'Glicemia pós-prandial', 'Almoço', 'posAlmoco'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      bolinhaDosValores(context, glicemiaPreJanta,
                          'Glicemia pré-prandial', 'Jantar', 'preJanta'),
                      bolinhaDosValores(context, glicemiaPosJanta,
                          'Glicemia pós-prandial', 'Jantar', 'posJanta'),
                    ],
                  ),
                  bolinhaDosValores(context, glicemiaNoturna,
                      'Glicemia Noturna', 'Antes de dormir', 'noturna'),
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
          color: Colors.green[50],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 80,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.greenAccent, width: 10),
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  icon: Icon(
                    Icons.today,
                    color: Colors.greenAccent,
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

  GestureDetector bolinhaDosValores(
      context, glicemiaValue, rotina, refeicao, fator) {
    return GestureDetector(
      onTap: () => navegar(fator),
      child: Container(
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
              Text(
                '${glicemiaValue.toStringAsFixed(0) ?? ''}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
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
}
