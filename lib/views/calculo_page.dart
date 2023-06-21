// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculoPage extends StatefulWidget {
  const CalculoPage({super.key});

  @override
  State<CalculoPage> createState() => _CalculoPageState();
}

class _CalculoPageState extends State<CalculoPage> {
  var formKey2 = GlobalKey<FormState>();

  double? glicemiaValue;
  int? peso;
  double? tdi = 0;
  double? fsi = 0;
  double? insulinaBasal = 0;
  double? reducaoGlicemia = 0;
  double? insulinaCaloria = 0;
  int? caloriasConsumidas;
  String? idade;

  String? fator;

  List<String> list1 = <String>[
    '0 a 5 anos',
    '5 a 10 anos',
    '10 a 18 anos',
    'acima de 19 anos'
  ];

  calcularGlicemia(fator) async {
    if (formKey2.currentState!.validate()) {
      formKey2.currentState!.save();
      switch (idade) {
        case '0 a 5 anos':
          setState(() {
            tdi = peso! * 0.5;
          });

          break;
        case '5 a 10 anos':
          setState(() {
            tdi = peso! * 0.8;
          });

          break;
        case '10 a 18 anos':
          setState(() {
            tdi = peso! * 1.1;
          });

          break;
        case 'acima de 19 anos':
          setState(() {
            tdi = peso! * 0.5;
          });

          break;
        default:
      }
      setState(() => insulinaBasal = 0.4 * tdi!);
      setState(() {
        fsi = 1800 / tdi!;
      });
      setState(() => reducaoGlicemia = (glicemiaValue! - 100) / fsi!);

      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('cameraScan');
      await prefs.remove('fator');

      switch (fator) {
        case 'matinal':
          await prefs.setDouble('fatorMatinal', glicemiaValue!);
          break;
        case 'preAlmoco':
          await prefs.setDouble('fatorPreAlmoco', glicemiaValue!);
          break;
        case 'posAlmoco':
          await prefs.setDouble('fatorPosAlmoco', glicemiaValue!);
          break;
        case 'preJanta':
          await prefs.setDouble('fatorPreJanta', glicemiaValue!);
          break;
        case 'posJanta':
          await prefs.setDouble('fatorPosJanta', glicemiaValue!);
          break;
        case 'noturna':
          await prefs.setDouble('fatorNoturna', glicemiaValue!);
          break;
        default:
      }
    }
  }

  calcularCaloria() {
    var formKey3 = GlobalKey<FormState>();
    insulinaCaloria = 0;
    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Atenção'),
            content: SizedBox(
              height: 297,
              child: Column(
                children: [
                  Form(
                    key: formKey3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Carboidratos consumidos (g)',
                        ),
                        validator: (value) {
                          if (value == '' || value!.isEmpty) {
                            return "Por favor insira um valor de calorias";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          caloriasConsumidas = int.parse(value!);
                        },
                      ),
                    ),
                  ),
                  valores(insulinaCaloria!.toStringAsFixed(0), 'Insulina bolus',
                      'Unidades'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey3.currentState!.validate()) {
                            formKey3.currentState!.save();
                            setState(() {
                              insulinaCaloria = (caloriasConsumidas! / 15);
                            });
                          }
                        },
                        child: Text('Calcular'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  var itemSelecionado;

  void _dropDownItemSelected(String novoItem) {
    setState(() {
      itemSelecionado = novoItem;
      idade = novoItem;
    });
  }

  getFator() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() => fator = prefs.getString('fator') ?? '');
  }

  @override
  Widget build(BuildContext context) {
    getFator();
    return Scaffold(
        appBar: AppBar(
          title: Text('Calculo de insulina'),
        ),
        body: telaGlicemia());
  }

  SingleChildScrollView telaGlicemia() {
    Object? dataCamera = ModalRoute.of(context)?.settings.arguments;

    var cameraScan = dataCamera ?? '';

    return SingleChildScrollView(
      reverse: true,
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: formKey2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: cameraScan.toString(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Glicêmia',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.camera_alt_outlined),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/camera');
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == '' || value!.isEmpty) {
                          return "Por favor insira sua glicêmia";
                        }
                        return null;
                      },
                      onSaved: (value) => glicemiaValue = double.parse(value!),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Peso corporal (kg)',
                      ),
                      validator: (value) {
                        if (value == '' || value!.isEmpty) {
                          return "Por favor insira seu peso";
                        }
                        return null;
                      },
                      onSaved: (value) => peso = int.parse(value!),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        hint: Text('Idade'),
                        dropdownColor: Colors.white,
                        validator: (value) {
                          if (value == '' || value == null) {
                            return "Por favor insira sua idade";
                          }
                          return null;
                        },
                        items: list1.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem.toString()),
                          );
                        }).toList(),
                        onChanged: (String? novoItemSelecionado) {
                          _dropDownItemSelected(novoItemSelecionado!);
                          setState(() {
                            itemSelecionado = novoItemSelecionado;
                          });
                        },
                        value: itemSelecionado),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          calcularGlicemia(fator);
                        },
                        child: Text('Calcular'),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      valores(fsi!.toStringAsFixed(1),
                          'Fator de sensibilidade a insulina', 'FSI'),
                      valores(
                          reducaoGlicemia! >= 0
                              ? reducaoGlicemia!.toStringAsFixed(0)
                              : 0,
                          'Unidades para redução de glicêmia para 100',
                          '')
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    // width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        calcularCaloria();
                      },
                      child: Text('Calcular por carboidrato'),
                    ),
                  ),
                ),
                Container(
                  color: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      valores(tdi!.toStringAsFixed(1),
                          'Total diario de insulina', 'TDI'),
                      valores(insulinaBasal!.toStringAsFixed(0),
                          'Insulina basal', '')
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding valores(valorDado, legenda, sublegenda) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                '${valorDado ?? ''}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                legenda,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                sublegenda,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
