// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var formKey = GlobalKey<FormState>();

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
              bolinhaDosValores(context, '0', 'Glicemia Matinal', 'Ao acordar'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  bolinhaDosValores(
                      context, '0', 'Glicemia pré-prandial', 'Almoço'),
                  bolinhaDosValores(
                      context, '0', 'Glicemia pós-prandial', 'Almoço'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  bolinhaDosValores(
                      context, '0', 'Glicemia pré-prandial', 'Jantar'),
                  bolinhaDosValores(
                      context, '0', 'Glicemia pós-prandial', 'Jantar'),
                ],
              ),
              bolinhaDosValores(
                  context, '0', 'Glicemia Noturna', 'Antes de dormir'),
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

GestureDetector bolinhaDosValores(context, glicemia, rotina, refeicao) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pushNamed('/create');
    },
    child: Container(
      height: 130,
      width: 130,
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
        fontSize: 12,
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
        fontSize: 40,
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
