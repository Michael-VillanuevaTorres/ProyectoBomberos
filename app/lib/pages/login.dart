//import 'dart:convert';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';
//import 'package:app/dtos/accces_token-dart.dart';
//import 'package:app/utils/globals.dart';
//import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:app/pages/menu.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  /*Future<AccessToken>? _futureToken;

  Future<AccessToken> validar(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://d1b2-191-125-37-58.ngrok-free.app/api/v1/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return AccessToken.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Credeciales incorrectas.');
    }
  }

  FutureBuilder<AccessToken> buildFutureBuilder() {
    return FutureBuilder<AccessToken>(
      future: _futureToken,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Globals.token = snapshot.data!.accessToken;
          WidgetsBinding.instance.addPostFrameCallback((_) =>
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const ),
                  (Route<dynamic> route) => false));

          return const Text("Cargando...");
        } else if (snapshot.hasError) {
          return seccionEnviar("Error de Credenciales");
        }
        return const Text("Cargando...");
      },
    );
  }*/

  Widget ingresar() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuPage(),
              ),
            );
          },
          child: const Text('Ingresar'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorBackground,
        body: Padding(
          padding: const EdgeInsets.only(top: 150),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const AutoSizeText(
              'RegisFire',
              style: TextStyle(
                color: Colors.black,
                fontSize: 50,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w900,
                height: 0,
              ),
              maxLines: 1,
              minFontSize: 16,
            ),
            Container(
              margin: const EdgeInsets.only(top: 40),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: OvalBorder(side: BorderSide(width: 1)),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  )
                ],
              ),
              constraints: const BoxConstraints(maxWidth: 300, maxHeight: 300),
              child: Center(
                child: Image.asset(
                  'assets/escudo-2.png',
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      child: TextFormField(
                        controller: loginController,
                        decoration: const InputDecoration(
                            fillColor: Color.fromARGB(255, 255, 0, 0),
                            iconColor: Color.fromARGB(255, 255, 0, 0),
                            focusColor: Color.fromARGB(255, 255, 0, 0),
                            hoverColor: Color.fromARGB(255, 255, 0, 0),
                            border: OutlineInputBorder(),
                            labelText: "N° Bombero"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa tu número de bombero';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            focusColor: Color.fromARGB(255, 255, 0, 0),
                            border: OutlineInputBorder(),
                            labelText: "Password"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa tu password';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16.0),
                        child: Center(
                            child: /*(_futureToken == null)
                              ? seccionEnviar("")
                              : buildFutureBuilder()),*/
                                ingresar())),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}