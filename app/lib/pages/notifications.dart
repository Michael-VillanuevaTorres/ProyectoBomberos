import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class notification extends StatefulWidget {
  const notification({super.key});

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  late Future<void> _initLoad;
  late List<dynamic> notifications;
  get http => null;

  Future<void> getNotificaciones() async {
    try {
      final response = await http.get(Uri.parse(
          "http://${dotenv.env['BASE_URL']}:5000/user/users_by_state/1"));
      if (response.statusCode == 200) {}

      //return list.where((element) => element.state == value).toList();
    } catch (error) {
      // Manejo de errores de la solicitud
      throw Exception('Failed to load User');
    }
  }

  @override
  void initState() {
    super.initState();
    //_initLoad = getNotificaciones();
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
            "Notificaciones",
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Autor:",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                "Fecha:",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "   ",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Unidad:",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                " Unidad 1",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          Text(
                            "Observación",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text("dsnfkjsdngjkfdngjkdfg"),
                        ],
                      ),
                    ),
                  );
                },
              ),
              child: Container(
                margin: EdgeInsets.only(top: 10, left: 10),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(12.0), // Bordes redondeados
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 94, 94, 94)
                          .withOpacity(0.2), // Color de la sombra
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: Offset(0, 2), // Desplazamiento de la sombra
                    ),
                  ],
                  color: const Color.fromRGBO(
                      255, 255, 255, 40), // Color del contenedor
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2),
                        ),
                      ),
                      Container(
                        child: Text("10-20-2023"),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 10),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 94, 94, 94)
                        .withOpacity(0.2), // Color de la sombra
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(0, 2), // Desplazamiento de la sombra
                  ),
                ],
                color: const Color.fromRGBO(
                    255, 255, 255, 40), // Color del contenedor
              ),
              child: Center(
                child: Text(
                  'Texto en el Contenedor',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            /*Expanded(child: Container()
                  /* FutureBuilder(
                  future: _initLoad,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        {
                          return RefreshIndicator(
                              onRefresh: () => getUser(dropdownValue!),
                              child: ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final item = users[index];
                                    return stateBombero(firefighter: item);
                                  }));
                        }
                      case ConnectionState.waiting:
                        {
                          return const Center(child: CircularProgressIndicator());
                        }
                      case ConnectionState.active:
                        {
                          return const Center(child: CircularProgressIndicator());
                        }
                      case ConnectionState.none:
                        {
                          return const Center(child: CircularProgressIndicator());
                        }
                    }
                  },
                ),*/
                  ),*/
          ],
        ),
      ),
    );
  }
}
