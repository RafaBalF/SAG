// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String senha = '';

  var formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  void login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      try {
        await auth.signInWithEmailAndPassword(email: email, password: senha);

        Navigator.of(context).pushNamed('/home');
      } catch (e) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('Atenção'),
              content: Text('Login Invalido'),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(300.0),
                child: Image.asset(
                  'assets/logo_sag.jpg',
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
                    border: OutlineInputBorder(),
                    labelText: 'Login',
                  ),
                  onSaved: (value) => email = value!,
                ),
              ),
              Container(
                margin: EdgeInsets.all(8),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Senha',
                  ),
                  onSaved: (value) => senha = value!,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  login(context);
                },
                child: Text('Entrar'),
              ),
              SizedBox(
                height: 3,
              ),
              TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/cadastro'),
                  child: Text('Registrar-se'))
            ],
          )),
    );
  }
}
