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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/utils/globals.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _currentIndex = 1;
  int idUser = Globals.returnID(Globals.token);
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      forms(),
      home(),
      statistics(),
      available(),
    ];
  }


  final List<PreferredSizeWidget> _appbar = [
    CustomAppBarAcceso(text: 'Formularios'),
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
  int _state=0;
  Auth auth = Auth();
  int warning = 2;

  @override
  void initState() {
    super.initState();
    _getInitialState();// Llama a _getInitialState() al inicio del estado del widget
    auth.loadToken();
    QrScanner(onQrCodeScanned: handleQrCodeScanned);
  }

  Future<void> _getInitialState() async {
    final response = await http.get(
      Uri.parse(
          'http://perrera.inf.udec.cl:1522/user/?user_id=$idUser'), //Uri.parse('http://perrera.inf.udec.cl:1522/api/v1/fecha'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {

      final List<dynamic> responseData = jsonDecode(response.body);

      if (responseData.isNotEmpty) {
        if (responseData[0] is Map<String, dynamic>) {
          final int state = responseData[0]['state'];
          setState(() {
            _state = state;
          });
        } else {
          setState(() {
            _state = 0;
          });
        }
      } else {

        print('Error');
      }
    }
  }

  void navigateToQrScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QrScanner(onQrCodeScanned: handleQrCodeScanned)),
    );
  }

  void handleQrCodeScanned(String scannedResult) {
    // Perform actions based on the scanned QR code result
    // Update _state or perform any other logic
    // For example, you can call setTime with a type based on the scannedResult
    setTime(int.parse(scannedResult));
  }

  Future<void> setTime(int type) async {
    try {
      if (type == 1) {
        print("Token de entradas es:  ${auth.token}");
        //await Future.delayed(const Duration(seconds: 5));
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
              msg: "Hora Registrada con exito",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
              _state=1;
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
              'http://${dotenv.env['BASE_URL']}:1522/exittime/'), //Uri.parse('http://127.0.0.1:5000/api/v1/fecha'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${auth.token}',
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
              _state=0;
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
        Uri.parse("http://${dotenv.env['BASE_URL']}:1522/user/${idUser}"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${auth.token}',
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
          Visibility(
            visible: _state == 0,
            child: SizedBox(height: MediaQuery.of(context).size.height * 0.1,
              child: ButtonMenu(
                color: Colors.lightGreen,
                text: "Entrada",
                icon: Icons.login,
                onPressed: () => navigateToQrScanner(), // Navigate to QrScanner
                type: 1,
              ),
            ),
          ),
          Visibility(
            visible: _state == 1,
            child:
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child:  ButtonMenu(
                  color: Colors.lightGreen,
                  text: "Salida",
                  icon: Icons.login,
                  onPressed: () => navigateToQrScanner(), // Navigate to QrScanner
                  type: 2,
                ),
              ),

          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Visibility(
            visible: _state == 1,
            child:
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child:  ButtonMenu(
                  color: Colors.lightGreen,
                  text: "Emergencia",
                  icon: Icons.login,
                  onPressed: () => navigateToQrScanner(), // Navigate to QrScanner
                  type: 3,
                ),
              ),
          ),
        ],
      ),
    );
  }
}
