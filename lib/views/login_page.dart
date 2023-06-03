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
  bool senhaVisivel = true;
  bool button = false;
  bool emailValidate = false;
  bool senhaValidate = false;

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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Login',
                  ),
                  validator: (value) {
                    if (value == '' || value!.isEmpty) {
                      return "Por favor insira seu login";
                    } else if (!value.contains('@')) {
                      return "E-mail inválido";
                    }
                    return null;
                  },
                  onSaved: (value) => email = value!,
                ),
              ),
              Container(
                margin: EdgeInsets.all(8),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: senhaVisivel,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Senha',
                    suffixIcon: IconButton(
                      icon: Icon(senhaVisivel
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: (() {
                        setState(() {
                          senhaVisivel = !senhaVisivel;
                        });
                      }),
                    ),
                  ),
                  validator: (value) {
                    if (value == '' || value!.isEmpty) {
                      return "Por favor insira sua senha";
                    } else if (value.length < 6) {
                      return "sua senha precisa ter mais de 5 caracteres";
                    }
                    return null;
                  },
                  onSaved: (value) => senha = value!,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      login(context);
                    },
                    child: Text('Entrar'),
                  ),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Não tem uma conta?'),
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/cadastro'),
                      child: Text('Registre-se')),
                ],
              )
            ],
          )),
    );
  }
}
