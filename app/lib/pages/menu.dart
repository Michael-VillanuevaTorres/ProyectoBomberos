import 'package:app/object/users.dart';
import 'package:app/pages/activos.dart';
import 'package:app/pages/forms.dart';
import 'package:app/token/accces_token-dart.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/colors.dart';
import 'package:app/pages/statistics.dart';
import 'package:app/pages/widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app/pages/qrScanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluttertoast/fluttertoast.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _currentIndex = 1;
  late int idUser;

  // Lista de Widget que representan las paginas principales de la APP
  final List<Widget> _pages = [
    // Aquí debes agregar las 3 páginas diferentes para cada opción de navegación
    const forms(),
    home(),
    const statistics(),
    available(),
  ];

  // Lista de Widget que representan los AppBars de cada página
  final List<PreferredSizeWidget> _appbar = [
    CustomAppBarAcceso(text: 'Formulario Bitacora'),
    CustomAppBarAcceso(text: 'Acceso'),
    CustomAppBarAcceso(text: 'Estadísticas'),
    CustomAppBarAcceso(text: 'Bomberos'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: _appbar[_currentIndex],
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // 4 navegaciones principales de la APP
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_document),
            label: 'Formularios', //backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            //backgroundColor: Colors.green,
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            //backgroundColor: Colors.white,
            icon: Icon(Icons.analytics),
            label: 'Estadisticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Bomberos',
            //backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }
}

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  late User usuario;
  late int idUser;
  //late Future<void> _initLoad;
  //Globals.returnID(Globals.token);
  Auth auth = Auth();
  int _state = 0;

  // Obtener informacion importante a la hora de iniciar

  int warning = 2;

  Future<void> getUserInfo() async {
    try {
      final response = await http.get(
        Uri.parse('http://${dotenv.env['BASE_URL']}:1522/user/${idUser}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${auth.token}',
        },
      );
      if (response.statusCode == 200) {
        usuario = User.fromJson(json.decode(response.body));

        // Almacena la información del usuario en las shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('firstName', usuario.firstName);
        prefs.setString('email', usuario.email);
        prefs.setString('lastName', usuario.lastName);
        prefs.setString('role', usuario.role);
        prefs.setString('userName', usuario.userName);
        setState(() {
          _state = usuario.state;
        });
      }
    } catch (e) {
      throw Exception("Error al cargar usuario");
    }
  }

  void navigateToQrScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              QrScanner(onQrCodeScanned: handleQrCodeScanned)),
    );
  }

  void handleQrCodeScanned(String scannedResult) {
    // Perform actions based on the scanned QR code result
    // Update _state or perform any other logic
    // For example, you can call setTime with a type based on the scannedResult
    print(scannedResult);
    if (scannedResult == "Entrada") {
      setTime(1);
    }

    if (scannedResult == "Salida") {
      setTime(0);
    }
  }

  Future<void> setTime(int type) async {
    try {
      if (type == 1) {
        final response = await http.post(
          Uri.parse(
              'http://${dotenv.env['BASE_URL']}:1522/entrytime/'), //Uri.parse('http://127.0.0.1:5000/api/v1/fecha'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${auth.token}',
          },
          body: jsonEncode(<String, int>{'user_id': idUser}),
        );
        if (response.statusCode == 200) {
          Fluttertoast.showToast(
              msg: "Entrada registrada con exito",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          getUserInfo();
        } else {
          Fluttertoast.showToast(
              msg: "Error al registrar entrada",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        final response = await http.post(
          Uri.parse(
              'http://${dotenv.env['BASE_URL']}:1522/exittime/'), //Uri.parse('http://127.0.0.1:5000/api/v1/fecha'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${auth.token}',
          },
          body: jsonEncode(<String, int>{'user_id': idUser}),
        );
        if (response.statusCode == 200) {
          Fluttertoast.showToast(
              msg: "Salida registrada con exito",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          getUserInfo();
        } else {
          Fluttertoast.showToast(
              msg: "Error al registrar hora de salida",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    } catch (e) {
      throw Exception("Error al ingresar registro");
    }
  }

  // Llamada a API Cambiar estado de emergencia
  Future<void> setWarning() async {
    try {
      final response = await http.put(
          Uri.parse(
              "http://${dotenv.env['BASE_URL']}:1522/user/${idUser}/emergency"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${auth.token}',
          });
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Cambiado a estado de emergencia",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        getUserInfo();
      } else {
        Fluttertoast.showToast(
            msg: "Error al cambiar estado",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      throw Exception("Error cambiar estado");
    }
  }

  @override
  void initState() {
    super.initState();

    QrScanner(onQrCodeScanned: handleQrCodeScanned);
    auth.loadToken().then((value) => idUser = returnId(auth.token));

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Visibility(
            visible: _state == 0,
            child: buttonMenu(
              color: Colors.lightGreen,
              text: "Entrada",
              icon: Icons.login,
              onPressed: () => navigateToQrScanner(),
              type: 1,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Visibility(
            visible: _state == 1,
            child: buttonMenu(
              color: Colors.red,
              text: "Salida",
              icon: Icons.logout,
              onPressed: () => navigateToQrScanner(),
              type: 2,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Visibility(
            visible: _state == 2 || _state == 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              width: 200,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,
                  elevation: 7,
                  backgroundColor: Colors.orange,
                ),
                onPressed: () async {
                  await setWarning();
                  setState(
                    () {},
                  );
                },
                icon: Icon(Icons.warning, color: Colors.white, size: 30),
                label: Text(
                  "Emergencia",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
