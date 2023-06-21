// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String email = '';
  String senha = '';
  String confirmarSenha = '';

  var formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  void register(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (senha != confirmarSenha) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('Atenção'),
              content: Text('Senhas não coincidem'),
            );
          },
        );
      } else {
        try {
          print(email);
          print(senha);
          await auth.createUserWithEmailAndPassword(
              email: email, password: senha);

          Navigator.of(context).pushReplacementNamed('/home');
        } catch (e) {
          showDialog(
            context: context,
            builder: (_) {
              print(e);
              return AlertDialog(
                title: Text('Atenção'),
                content: Text('Cadastro Invalido'),
              );
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registre-se'),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 150),
                ClipRRect(
                  borderRadius: BorderRadius.circular(300.0),
                  child: Image.asset(
                    'assets/logo_sag.jpeg',
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Login',
                    ),
                    onSaved: (value) => email = value!,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                    ),
                    onSaved: (value) => senha = value!,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Senha',
                    ),
                    onSaved: (value) => confirmarSenha = value!,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    register(context);
                  },
                  child: Text('Registrar-se'),
                ),
              ],
            )),
      ),
    );
  }
}
