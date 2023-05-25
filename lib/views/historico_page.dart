// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  var _itemSelecionado;

  void _dropDownItemSelected(String novoItem) {
    setState(() {
      _itemSelecionado = novoItem;
    });
  }

  List<Widget> x = <Widget>[glicemiaDoDia(10, 10, 10, 10, 10, 10, 10)];

  List<String> list1 = <String>['2020', '2021', '2022', '2023'];

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
          title: Text('Histórico de Glicemia'),
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
        body: Column(
          children: [
            Expanded(
              child: ListView(children: [
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 5,
                      child: DropdownButton<String>(
                          hint: Text('2023'),
                          dropdownColor: Colors.white,
                          items: list1.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            );
                          }).toList(),
                          onChanged: (String? novoItemSelecionado) {
                            _dropDownItemSelected(novoItemSelecionado!);
                            setState(() {
                              _itemSelecionado = novoItemSelecionado;
                            });
                          },
                          value: _itemSelecionado),
                    ),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          meses('Junho'),
                          meses('Maio'),
                          meses('Abril'),
                          meses('Março'),
                          meses('Fevereiro'),
                          meses('Janeiro'),
                        ],
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     Flexible(
                    //       child: StreamBuilder<
                    //               QuerySnapshot<Map<String, dynamic>>>(
                    //           stream:
                    //               firestore.collection('Glicemia').snapshots(),
                    //           builder: (context, snapshot) {
                    //             if (!snapshot.hasData) {
                    //               return Center(
                    //                   child: CircularProgressIndicator());
                    //             }
                    //             var glicemias = snapshot.data!.docs;
                    //             return ListView(
                    //                 children: glicemias
                    //                     .map((task) => glicemiaDoDia(
                    //                           task['dia'],
                    //                           task['matinal'],
                    //                           task['preAlmoco'],
                    //                           task['posAlmoco'],
                    //                           task['preJanta'],
                    //                           task['posJanta'],
                    //                           task['noturna'],
                    //                         ))
                    //                     .toList());
                    //           }),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ]),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 50,
          width: 10,
          color: Colors.blue[50],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/home');
                },
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

Container glicemiaDoDia(
    dia, matinal, preAlmoco, posAlmoco, preJanta, posJanta, noturna) {
  return Container(
    height: 150,
    margin: EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.blue[200],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Dia: $dia',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            SizedBox(
              child: Container(
                color: Colors.grey,
                width: 1,
                height: 140,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Matinal: $matinal',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Pré-pradial - Almoço: $preAlmoco',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Pós-pradial - Almoço: $posAlmoco',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Pré-pradial - Janta: $preJanta',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Pós-pradial - Janta: $posJanta',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Noturna: $noturna',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Container meses(String mes) {
  return Container(
    margin: EdgeInsets.all(2),
    width: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      color: Colors.blue,
    ),
    child: Center(
        child: Text(
      mes,
      style: TextStyle(fontSize: 18, color: Colors.white),
    )),
  );
}
