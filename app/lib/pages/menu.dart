import 'package:app/pages/forms.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/colors.dart';
import 'package:app/pages/statistics.dart';
import 'package:app/pages/widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/utils/globals.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:fluttertoast/fluttertoast.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    // Aquí debes agregar las 3 páginas diferentes para cada opción de navegación
    forms(),
    home(),
    statistics(),
  ];

  final List<PreferredSizeWidget> _appbar = [
    CustomAppBarAcceso(text: 'Formularios'),
    CustomAppBarAcceso(text: 'Acceso'),
    CustomAppBarAcceso(text: 'Estadísticas'),
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
        //backgroundColor: colorBottonNav,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_document),
            label: 'Formularios',
            //backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            //backgroundColor: Colors.green,
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(Icons.analytics),
            label: 'Estadisticas',
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
  int idUser = Globals.returnID(Globals.token);

  int warning = 2;

  Future<void> setTime(int type) async {
    try {
      if (type == 1) {
        //await Future.delayed(const Duration(seconds: 5));
        final response = await http.post(
          Uri.parse(
              'http://${dotenv.env['BASE_URL']}:5000/entrytime/'), //Uri.parse('http://127.0.0.1:5000/api/v1/fecha'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, int>{'user_id': idUser}),
        );
        if (response.statusCode == 200) {
          Fluttertoast.showToast(
              msg: "Hora Registrada con exito",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Error al ingresar hora de entrada",
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
              'http://${dotenv.env['BASE_URL']}:5000/exittime/'), //Uri.parse('http://127.0.0.1:5000/api/v1/fecha'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, int>{'user_id': idUser}),
        );
        if (response.statusCode == 200) {
          Fluttertoast.showToast(
              msg: "Hora Registrada con exito",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Error al ingresar hora de salida",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    } catch (e) {
      throw Exception("Error al ingresar hora");
    }
  }

  Future<void> setWarning() async {
    try {
      final response = await http.patch(
        Uri.parse("http://${dotenv.env['BASE_URL']}:5000/user/${idUser}"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, int>{'state': warning}),
      );
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Cambiado a estado de emergencia",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
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
      throw Exception("Error al ingresar hora");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          buttonMenu(
            color: Colors.lightGreen,
            text: "Entrada",
            icon: Icons.login,
            setTime: setTime,
            type: 1,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          buttonMenu(
            color: Colors.red,
            text: "Salida",
            icon: Icons.logout,
            setTime: setTime,
            type: 2,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Container(
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
        ],
      ),
    );
  }
}
