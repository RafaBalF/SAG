// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Color corJan = Colors.blueGrey;
  Color corFev = Colors.blueGrey;
  Color corMar = Colors.blueGrey;
  Color corAbr = Colors.blueGrey;
  Color corMai = Colors.blueGrey;
  Color corJun = Colors.blueGrey;
  Color corJul = Colors.blueGrey;
  Color corAgo = Colors.blueGrey;
  Color corSet = Colors.blueGrey;
  Color corOut = Colors.blueGrey;
  Color corNov = Colors.blueGrey;
  Color corDez = Colors.blueGrey;

  DateTime date = DateTime.now();

  void delete(String id) {
    firestore.collection('Glicemia').doc(id).delete();
  }

  var itemSelecionado;

  void _dropDownItemSelected(int novoItem) {
    setState(() {
      itemSelecionado = novoItem;
    });
  }

  int? mesSelect;

  List<int> list1 = <int>[2020, 2021, 2022, 2023];

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
    if (mesSelect == null) {
      ifzaoGigante();
    }

    final ScrollController _scrollController =
        ScrollController(initialScrollOffset: 100.0 * date.month - 250);

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
                onPressed: () => logout(context),
                // backgroundColor: Colors.black26,
                elevation: 0,
                child: Icon(Icons.logout),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 5,
              child: DropdownButton<int>(
                  hint: Text('2023'),
                  dropdownColor: Colors.white,
                  items: list1.map((int dropDownIntItem) {
                    return DropdownMenuItem<int>(
                      value: dropDownIntItem,
                      child: Text(dropDownIntItem.toString()),
                    );
                  }).toList(),
                  onChanged: (int? novoItemSelecionado) {
                    _dropDownItemSelected(novoItemSelecionado!);
                    setState(() {
                      itemSelecionado = novoItemSelecionado;
                    });
                  },
                  value: itemSelecionado),
            ),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  children: [
                    Row(
                      children: [
                        meses('Janeiro', corJan),
                        meses('Fevereiro', corFev),
                        meses('Março', corMar),
                        meses('Abril', corAbr),
                        meses('Maio', corMai),
                        meses('Junho', corJun),
                        meses('Julho', corJul),
                        meses('Agosto', corAgo),
                        meses('Setembro', corSet),
                        meses('Outubro', corOut),
                        meses('Novembro', corNov),
                        meses('Dezembro', corDez),
                      ],
                    ),
                  ]),
            ),
            Flexible(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: firestore
                      .collection('Glicemia')
                      .where('mes', isEqualTo: mesSelect ?? date.month)
                      .where('ano', isEqualTo: itemSelecionado ?? date.year)
                      .where('uid', isEqualTo: auth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    var glicemias = snapshot.data!.docs;

                    print('inha $mesSelect');
                    print('inha2$itemSelecionado');

                    return ListView(
                        children: glicemias
                            .map((task) => Dismissible(
                                  key: Key(task.id),
                                  onDismissed: (_) => delete(task.id),
                                  background: Container(
                                      color: Colors.red,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Apagar',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25)),
                                        ],
                                      )),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/update',
                                        arguments: {
                                          "id": task.id,
                                          "matinal": task['matinal'],
                                          "preAlmoco": task['preAlmoco'],
                                          "posAlmoco": task['posAlmoco'],
                                          "preJanta": task['preJanta'],
                                          "posJanta": task['posJanta'],
                                          "noturna": task['noturna'],
                                        },
                                      );
                                    },
                                    child: glicemiaDoDia(
                                      task['dia'],
                                      task['matinal'],
                                      task['preAlmoco'],
                                      task['posAlmoco'],
                                      task['preJanta'],
                                      task['posJanta'],
                                      task['noturna'],
                                    ),
                                  ),
                                ))
                            .toList());
                  }),
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
              Container(
                width: 80,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  icon: Icon(Icons.today),
                  tooltip: 'Hoje',
                ),
              ),
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
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/historico');
                  },
                  icon: Icon(
                    Icons.history,
                    color: Colors.lightBlueAccent,
                  ),
                  tooltip: 'Histórico',
                ),
              ),
            ],
          ),
        ));
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

  ifzaoGigante() {
    if (date.month == 1) {
      setState(() {
        corJan = Colors.blue;
      });
    }
    if (date.month == 2) {
      setState(() {
        corFev = Colors.blue;
      });
    }
    if (date.month == 3) {
      setState(() {
        corMar = Colors.blue;
      });
    }
    if (date.month == 4) {
      setState(() {
        corAbr = Colors.blue;
      });
    }
    if (date.month == 5) {
      setState(() {
        corMai = Colors.blue;
      });
    }
    if (date.month == 6) {
      setState(() {
        corJun = Colors.blue;
      });
    }
    if (date.month == 7) {
      setState(() {
        corJul = Colors.blue;
      });
    }
    if (date.month == 8) {
      setState(() {
        corAgo = Colors.blue;
      });
    }
    if (date.month == 9) {
      setState(() {
        corSet = Colors.blue;
      });
    }
    if (date.month == 10) {
      setState(() {
        corOut = Colors.blue;
      });
    }
    if (date.month == 11) {
      setState(() {
        corNov = Colors.blue;
      });
    }
    if (date.month == 12) {
      setState(() {
        corDez = Colors.blue;
      });
    }
  }

  GestureDetector meses(String mes, cor) {
    return GestureDetector(
      onTap: () {
        switchCaseGigante(mes);
      },
      child: Container(
        margin: EdgeInsets.all(2),
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: cor,
        ),
        child: Center(
            child: Text(
          mes,
          style: TextStyle(fontSize: 18, color: Colors.white),
        )),
      ),
    );
  }

  switchCaseGigante(mes) {
    switch (mes) {
      case 'Janeiro':
        {
          setState(() {
            corJan = Colors.blue;
            corFev = Colors.blueGrey;
            corMar = Colors.blueGrey;
            corAbr = Colors.blueGrey;
            corMai = Colors.blueGrey;
            corJun = Colors.blueGrey;
            corJul = Colors.blueGrey;
            corAgo = Colors.blueGrey;
            corDez = Colors.blueGrey;
            corSet = Colors.blueGrey;
            corOut = Colors.blueGrey;
            corNov = Colors.blueGrey;
            corDez = Colors.blueGrey;
          });
          setState(() => mesSelect = 1);
        }

        break;
      case 'Fevereiro':
        {
          setState(() {
            corJan = Colors.blueGrey;
            corFev = Colors.blue;
            corMar = Colors.blueGrey;
            corAbr = Colors.blueGrey;
            corMai = Colors.blueGrey;
            corJun = Colors.blueGrey;
            corJul = Colors.blueGrey;
            corAgo = Colors.blueGrey;
            corSet = Colors.blueGrey;
            corOut = Colors.blueGrey;
            corNov = Colors.blueGrey;
            corDez = Colors.blueGrey;
          });
          setState(() => mesSelect = 2);
        }

        break;
      case 'Março':
        {
          setState(() {
            corJan = Colors.blueGrey;
            corFev = Colors.blueGrey;
            corMar = Colors.blue;
            corAbr = Colors.blueGrey;
            corMai = Colors.blueGrey;
            corJun = Colors.blueGrey;
            corJul = Colors.blueGrey;
            corAgo = Colors.blueGrey;
            corSet = Colors.blueGrey;
            corOut = Colors.blueGrey;
            corNov = Colors.blueGrey;
            corDez = Colors.blueGrey;
          });
          setState(() => mesSelect = 3);
        }

        break;
      case 'Abril':
        {
          setState(() {
            corJan = Colors.blueGrey;
            corFev = Colors.blueGrey;
            corMar = Colors.blueGrey;
            corAbr = Colors.blue;
            corMai = Colors.blueGrey;
            corJun = Colors.blueGrey;
            corJul = Colors.blueGrey;
            corAgo = Colors.blueGrey;
            corSet = Colors.blueGrey;
            corOut = Colors.blueGrey;
            corNov = Colors.blueGrey;
            corDez = Colors.blueGrey;
          });
          setState(() => mesSelect = 4);
        }

        break;
      case 'Maio':
        {
          setState(() {
            corJan = Colors.blueGrey;
            corFev = Colors.blueGrey;
            corMar = Colors.blueGrey;
            corAbr = Colors.blueGrey;
            corMai = Colors.blue;
            corJun = Colors.blueGrey;
            corJul = Colors.blueGrey;
            corAgo = Colors.blueGrey;
            corSet = Colors.blueGrey;
            corOut = Colors.blueGrey;
            corNov = Colors.blueGrey;
            corDez = Colors.blueGrey;
          });
          setState(() => mesSelect = 5);
        }

        break;
      case 'Junho':
        {
          setState(() {
            corJan = Colors.blueGrey;
            corFev = Colors.blueGrey;
            corMar = Colors.blueGrey;
            corAbr = Colors.blueGrey;
            corMai = Colors.blueGrey;
            corJun = Colors.blue;
            corJul = Colors.blueGrey;
            corAgo = Colors.blueGrey;
            corSet = Colors.blueGrey;
            corOut = Colors.blueGrey;
            corNov = Colors.blueGrey;
            corDez = Colors.blueGrey;
          });
          setState(() => mesSelect = 6);
        }

        break;
      case 'Julho':
        {
          setState(() {
            corJan = Colors.blueGrey;
            corFev = Colors.blueGrey;
            corMar = Colors.blueGrey;
            corAbr = Colors.blueGrey;
            corMai = Colors.blueGrey;
            corJun = Colors.blueGrey;
            corJul = Colors.blue;
            corAgo = Colors.blueGrey;
            corSet = Colors.blueGrey;
            corOut = Colors.blueGrey;
            corNov = Colors.blueGrey;
            corDez = Colors.blueGrey;
          });
          setState(() => mesSelect = 7);
        }

        break;
      case 'Agosto':
        {
          setState(() {
            corJan = Colors.blueGrey;
            corFev = Colors.blueGrey;
            corMar = Colors.blueGrey;
            corAbr = Colors.blueGrey;
            corMai = Colors.blueGrey;
            corJun = Colors.blueGrey;
            corJul = Colors.blueGrey;
            corAgo = Colors.blue;
            corSet = Colors.blueGrey;
            corOut = Colors.blueGrey;
            corNov = Colors.blueGrey;
            corDez = Colors.blueGrey;
          });
          setState(() => mesSelect = 8);
        }

        break;
      case 'Setembro':
        {
          setState(() {
            corJan = Colors.blueGrey;
            corFev = Colors.blueGrey;
            corMar = Colors.blueGrey;
            corAbr = Colors.blueGrey;
            corMai = Colors.blueGrey;
            corJun = Colors.blueGrey;
            corJul = Colors.blueGrey;
            corAgo = Colors.blueGrey;
            corSet = Colors.blue;
            corOut = Colors.blueGrey;
            corNov = Colors.blueGrey;
            corDez = Colors.blueGrey;
          });
          setState(() => mesSelect = 9);
        }

        break;
      case 'Outubro':
        {
          setState(() {
            corJan = Colors.blueGrey;
            corFev = Colors.blueGrey;
            corMar = Colors.blueGrey;
            corAbr = Colors.blueGrey;
            corMai = Colors.blueGrey;
            corJun = Colors.blueGrey;
            corJul = Colors.blueGrey;
            corAgo = Colors.blueGrey;
            corSet = Colors.blueGrey;
            corOut = Colors.blue;
            corNov = Colors.blueGrey;
            corDez = Colors.blueGrey;
          });
          setState(() => mesSelect = 10);
        }

        break;
      case 'Novembro':
        {
          setState(() {
            corJan = Colors.blueGrey;
            corFev = Colors.blueGrey;
            corMar = Colors.blueGrey;
            corAbr = Colors.blueGrey;
            corMai = Colors.blueGrey;
            corJun = Colors.blueGrey;
            corJul = Colors.blueGrey;
            corAgo = Colors.blueGrey;
            corSet = Colors.blueGrey;
            corOut = Colors.blueGrey;
            corNov = Colors.blue;
            corDez = Colors.blueGrey;
          });
          setState(() => mesSelect = 11);
        }

        break;
      case 'Dezembro':
        {
          setState(() {
            corJan = Colors.blueGrey;
            corFev = Colors.blueGrey;
            corMar = Colors.blueGrey;
            corAbr = Colors.blueGrey;
            corMai = Colors.blueGrey;
            corJun = Colors.blueGrey;
            corJul = Colors.blueGrey;
            corAgo = Colors.blueGrey;
            corSet = Colors.blueGrey;
            corOut = Colors.blueGrey;
            corNov = Colors.blueGrey;
            corDez = Colors.blue;
          });
          setState(() => mesSelect = 12);
        }

        break;
      default:
    }
  }
}
