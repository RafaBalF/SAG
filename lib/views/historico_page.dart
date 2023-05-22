// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  var _itemSelecionado;

  void _dropDownItemSelected(String novoItem) {
    setState(() {
      this._itemSelecionado = novoItem;
    });
  }

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
                      this._itemSelecionado = novoItemSelecionado;
                    });
                  },
                  value: _itemSelecionado),
            ),
            SizedBox(
              height: 50,
              width: 1000,
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
            glicemiaDoDia(10, 10, 10, 10, 10, 10, 10),
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

Container glicemiaDoDia(dia, matinal, preAlmoco, posAlmoco, preJanta, posJanta, noturna) {
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
        Text('Dia: $dia', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),),
        
        Row(
          children: [
            SizedBox(child: Container(color: Colors.grey, width: 1, height: 140,),),
            SizedBox(width: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Matinal: $matinal', style: TextStyle(color: Colors.white),),
                Text('Pré-pradial - Almoço: $preAlmoco', style: TextStyle(color: Colors.white),),
                Text('Pós-pradial - Almoço: $posAlmoco', style: TextStyle(color: Colors.white),),
                Text('Pré-pradial - Janta: $preJanta', style: TextStyle(color: Colors.white),),
                Text('Pós-pradial - Janta: $posJanta', style: TextStyle(color: Colors.white),),
                Text('Noturna: $noturna', style: TextStyle(color: Colors.white),),
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
