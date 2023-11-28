import 'dart:convert';
import 'package:app/token/accces_token-dart.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class perfil extends StatefulWidget {
  const perfil({super.key});
  static const route = '/perfil';

  @override
  State<perfil> createState() => _perfilState();
}

class _perfilState extends State<perfil> {
  bool _mostrarIndicadorCarga = false;
  String firstName = "";
  String lastName = "";
  String email = "";
  String userName = "";
  String role = "";
  //String? firstName, lastName, email, userName, role; // = "";
  bool _obscureTextone = true;
  bool _obscureTexttwo = true;
  Auth auth = Auth();
  TextEditingController current_password = TextEditingController();
  TextEditingController new_password = TextEditingController();
  TextEditingController rep_new_password = TextEditingController();

  bool editar = false;

  Future<void> changePassword(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://${dotenv.env['BASE_URL']}:5000/user/change-password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${auth.token}',
        },
        body: jsonEncode(<String, String>{
          "current_password": current_password.text,
          "new_password": new_password.text
        }),
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: responseData['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        await logout(context);
        await auth.clearToken();
        Navigator.pushNamed(context, '/login');
      } else {
        Fluttertoast.showToast(
            msg: responseData['error'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.red,
            fontSize: 12.0);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Widget sectionPassword(TextEditingController controller, String label) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 60,
      child: TextFormField(
        controller: controller,
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
          labelText: "Contraseña Actual",
        ),
      ),
    );
  }

  Widget updatePassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sectionPassword(current_password, "Contraseña Actual"),
          sectionPassword(new_password, "Nueva Contraseña"),
          sectionPassword(rep_new_password, "Repetir Nueva Contraseña"),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                print("new password: ${new_password.text}");
                print("new password: ${rep_new_password.text}");

                if (new_password.text != rep_new_password.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Las contraseñas no coinciden')),
                  );
                } else if (current_password.text.isEmpty ||
                    new_password.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Existen campos vacios')));
                  // Validate returns true if the form is valid, or false otherwise.
                } else {
                  await changePassword(context);
                }
              },
              child: const Text('Cambiar'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    Navigator.pushNamed(context, '/login');

    setState(
      () {
        _mostrarIndicadorCarga = true;
      },
    );
    print("token logout: ${auth.token}");
    try {
      final response = await http.post(
        Uri.parse('http://${dotenv.env['BASE_URL']}:5000/user/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${auth.token}',
        },
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: responseData['msg'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        //await auth.clearToken();
        Navigator.pushNamed(context, '/login');
      } else {
        Fluttertoast.showToast(
            msg: "Error al cerrar sesión",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.red,
            fontSize: 12.0);
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      // Oculta el indicador de carga después de la solicitud
      setState(
        () {
          _mostrarIndicadorCarga = false;
        },
      );
    }
  }

  Future<void> _obtenerInformacion(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName')!;
      lastName = prefs.getString('lastName')!;
      email = prefs.getString('email')!;
      role = prefs.getString('role')!;
      userName = prefs.getString('userName')!;
    });
  }

  @override
  void initState() {
    super.initState();
    auth.loadToken();
    _obtenerInformacion(context);
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
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
                child: Text(
                  "$firstName $lastName",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: Text(
                  role,
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
                child: Text(
                  "Correo: $email",
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
                child: Text(
                  "Usuario : $userName",
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                      child: !editar
                          ? Icon(Icons.edit)
                          : Icon(Icons.arrow_drop_up),
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
                  await logout(context);
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
              if (_mostrarIndicadorCarga) const CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
