import 'package:app/pages/activos.dart';
import 'package:app/pages/forms.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/colors.dart';
import 'package:app/pages/statistics.dart';
import 'package:app/pages/widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
    available(),
    //Container(color: Colors.green),
  ];

  final List<PreferredSizeWidget> _appbar = [
    CustomAppBarAcceso(text: 'Formularios'),
    CustomAppBarAcceso(text: 'Acceso'),
    CustomAppBarAcceso(text: 'Estadisticas'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: _appbar[_currentIndex],
      /*AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
        title: const Text(
          'Acceso',
          style: TextStyle(color: Colors.white),
        ),
      ),*/

      body: _pages[_currentIndex],

      /*Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            buttonMenu(Colors.lightGreen, "Entrada", Icons.login),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            buttonMenu(Colors.red, "Salida", Icons.logout),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            buttonMenu(Colors.orange, "Emergencia", Icons.warning),
          ],
        ),
      ),*/
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción a realizar cuando se presiona el botón flotante
          // Por ejemplo, mostrar un mensaje en la consola
          print('Botón flotante presionado');
        },
        child: Container(child: Icon(Icons.check)), // Icono del botón flotante
        backgroundColor: Colors.lightGreen, // Color de fondo del botón flotante
      ),*/

      //_pages[_currentIndex],
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
  Future<void> setTime(int id_user) async {
    try {
      //await Future.delayed(const Duration(seconds: 5));
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/v1/fecha'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, int>{'id_user': id_user}),
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
            msg: "Error al registrar hora",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
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
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          buttonMenu(
            color: Colors.red,
            text: "Salida",
            icon: Icons.logout,
            setTime: setTime,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          buttonMenu(
            color: Colors.orange,
            text: "Emergencia",
            icon: Icons.warning,
            setTime: setTime,
          ),
        ],
      ),
    );
    /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción a realizar cuando se presiona el botón flotante
          // Por ejemplo, mostrar un mensaje en la consola
          print('Botón flotante presionado');
        },
        child: Container(child: Icon(Icons.check)), // Icono del botón flotante
        backgroundColor: Colors.lightGreen, // Color de fondo del botón flotante
      )*/
  }
}
