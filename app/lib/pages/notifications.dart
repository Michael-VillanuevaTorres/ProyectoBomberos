import 'dart:convert';
import 'dart:ui';
import 'package:app/object/bitacora.dart';
import 'package:app/pages/widget.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class notification extends StatefulWidget {
  static const route = '/notifications';
  const notification({super.key});

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  late List<dynamic> notifications;
  late Future<void> _initLoad;

  Future<void> getNotificaciones() async {
    try {
      final response = await http.get(Uri.parse(
          "http://${dotenv.env['BASE_URL']}:5000/logs?description=0"));
      notifications = json.decode(response.body);

      if (response.statusCode == 200) {
        notifications =
            notifications.map((bit) => Bitacora.fromJson(bit)).toList();
        notifications = notifications.reversed.toList();
      }
    } catch (error) {
      // Manejo de errores de la solicitud
      throw Exception('Failed to load User');
    }
  }

  Widget viewNotification(String description, String date) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 80,
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
        color: const Color.fromRGBO(255, 255, 255, 40), // Color del contenedor
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                child: Text(description,
                    overflow: TextOverflow.ellipsis, maxLines: 2),
              ),
            ),
            Container(
              child: Text(date),
            )
          ],
        ),
      ),
    );
  }

  Widget textAlert(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _initLoad = getNotificaciones();
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
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: _initLoad,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      {
                        return RefreshIndicator(
                            onRefresh: () => getNotificaciones(),
                            child: ListView.builder(
                                itemCount: notifications.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final item = notifications[index];
                                  return GestureDetector(
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 5, sigmaY: 5),
                                          child: AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    255, 255, 255, 1),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                textAlert("Autor: ", item.user),
                                                textAlert(
                                                    "Fecha: ", item.dateTime),
                                                textAlert("Unidad: ",
                                                    item.truckPatent),
                                                item.type == "Single_use"
                                                    ? textAlert(
                                                        "Tipo: ", "Uso común")
                                                    : item.type == "Maintenance"
                                                        ? textAlert("Tipo: ",
                                                            "Mantención")
                                                        : textAlert("Tipo: ",
                                                            "Reparación"),
                                                textAlert(
                                                    "Nivel de combustible: ",
                                                    transformTodouble(item
                                                        .fuelLevel
                                                        .toString())),
                                                textAlert(
                                                    "Nivel de aceite: ",
                                                    transformTodouble(item
                                                        .waterLevel
                                                        .toString())),
                                                textAlert(
                                                    "Nivel de agua: ",
                                                    transformTodouble(item
                                                        .oilLevel
                                                        .toString())),
                                                const Text(
                                                  "Observación:",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(item.description),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    child: index == notifications.length - 1
                                        ? Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            child: viewNotification(
                                                item.description,
                                                item.dateTime),
                                          )
                                        : viewNotification(
                                            item.description, item.dateTime),
                                  );
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
