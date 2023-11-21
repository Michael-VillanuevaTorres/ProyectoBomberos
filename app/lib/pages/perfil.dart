import 'dart:convert';

import 'package:app/token/accces_token-dart.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class perfil extends StatefulWidget {
  const perfil({super.key});
  static const route = '/perfil';

  @override
  State<perfil> createState() => _perfilState();
}

class _perfilState extends State<perfil> {
  TextEditingController password = TextEditingController();
  bool _obscureTextone = true;
  bool _obscureTexttwo = true;
  Auth auth = Auth();
  TextEditingController repassword = TextEditingController();

  bool editar = false;

  Widget updatePassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 60,
            child: TextFormField(
              controller: password,
              obscureText: _obscureTextone,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureTextone ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureTextone =
                          !_obscureTextone; // Cambia entre texto visible y oculto
                    });
                  },
                ),
                labelText: "Contraseña",
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 60,
            child: TextFormField(
              controller: repassword,
              obscureText: _obscureTexttwo,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureTexttwo ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureTexttwo =
                          !_obscureTexttwo; // Cambia entre texto visible y oculto
                    });
                  },
                ),
                labelText: "Repetir Contraseña",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (password.text != repassword.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Las contraseñas no coinciden')),
                  );
                } else if (password.text.isEmpty || repassword.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Campos vacios')));
                  // Validate returns true if the form is valid, or false otherwise.
                } else {
                  //* REALIZAR LLAMADA A API PARA CAMBIAR CONTRASEÑA
                }
              },
              child: const Text('Cambiar'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    print("token logout: ${auth.token}");
    final response = await http.post(
      Uri.parse('http://${dotenv.env['BASE_URL']}:5000/user/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${auth.token}',
      },
    );
    if (response.statusCode == 200) {
      Center(child: CircularProgressIndicator());
    } else {
      throw Exception('Error Al Cerrar Sesión');
    }
  }

  @override
  void initState() {
    super.initState();
    auth.loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Perfil",
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 20, top: 20),
              child: const CircleAvatar(
                maxRadius: 100,
                //backgroundImage: NetworkImage(""), // insertar imagen de perfil
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Text(
                "Micheal Scott",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: const Text(
                "administrador",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * 0.8,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(top: 20),
              child: const Text(
                "Correo",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * 0.8,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(top: 5),
              child: const Text(
                "Correo",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * 0.8,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cambiar contraseña",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (editar == true) {
                        editar = false;
                      } else {
                        editar = true;
                      }
                      setState(() {});
                    },
                    child:
                        !editar ? Icon(Icons.edit) : Icon(Icons.arrow_drop_up),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        disabledBackgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ],
              ),
            ),
            editar ? updatePassword(context) : const Text(""),
            ElevatedButton(
              onPressed: () async {
                await logout();
                await auth.clearToken();
                Navigator.pushNamed(context, '/login');
              },
              child: const Text("Cerrar Sesión",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ],
        ),
      ),
    );
  }
}
