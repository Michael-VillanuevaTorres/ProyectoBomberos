import 'dart:convert';
import 'package:app/object/users.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const status = {
  "Emergencia": 2,
  "Disponible": 1,
};

class available extends StatefulWidget {
  @override
  State<available> createState() => _availableState();
}

class _availableState extends State<available> {
  late Future<void> _initLoad;
  late List<dynamic> users;
  late List<dynamic> activeUser;
  late List<dynamic> warningUser;

  Future<void> getUser(int option) async {
    try {
      final responseActive = await http.get(Uri.parse(
          "http://${dotenv.env['BASE_URL']}:1522/user/users_by_state/1"));
      activeUser = json.decode(responseActive.body);

      final responseWarning = await http.get(Uri.parse(
          "http://${dotenv.env['BASE_URL']}:1522/user/users_by_state/2"));
      warningUser = json.decode(responseWarning.body);
      if (responseActive.statusCode == 200 &&
          responseWarning.statusCode == 200) {
        setState(() {
          activeUser = activeUser.map((user) => User.fromJson(user)).toList();
          warningUser = warningUser.map((user) => User.fromJson(user)).toList();
          if (option == 0) {
            users = activeUser + warningUser;
          }
          if (option == 1) {
            users = activeUser;
          }
          if (option == 2) {
            users = warningUser;
          }
        });
      }
      // Si la solicitud es exitosa y el estado es 200 (OK), analizamos los datos
      //List users = json.decode(response_active.body);
      // Convertir la lista dinámica a una lista de Map<String, dynamic>
      //if (value == 0) {
      //}
      //return list.where((element) => element.state == value).toList();
    } catch (error) {
      // Manejo de errores de la solicitud
      throw Exception('Failed to load User');
    }
  }

  @override
  void initState() {
    super.initState();
    _initLoad = getUser(0);
  }

  List<String> list = <String>['Todos', 'Activos', 'Emergencia'];
  int? dropdownValue = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Container(
              padding: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black), // Quitar el borde
              ),
              child: DropdownMenu<String>(
                width: 150,
                initialSelection: list.first,
                menuStyle: const MenuStyle(
                  backgroundColor:
                  MaterialStatePropertyAll<Color>(Colors.white),
                ),
                inputDecorationTheme: const InputDecorationTheme(
                  focusColor: Colors.red,
                ),
                onSelected: (String? value) {
                  setState(() {
                    switch (value) {
                      case "Todos":
                        users = activeUser + warningUser;
                        dropdownValue = 0;
                        break;
                      case "Activos":
                        users = activeUser;
                        dropdownValue = 1;
                        break;
                      case "Emergencia":
                        users = warningUser;
                        dropdownValue = 2;
                        break;
                    }
                  });
                },
                dropdownMenuEntries: list
                    .map<DropdownMenuEntry<String>>(
                      (String value) =>
                      DropdownMenuEntry<String>(value: value, label: value),
                )
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
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
            ),
          ),
        ],
      ),
    );
  }
}

class stateBombero extends StatefulWidget {
  User firefighter;
  stateBombero({required this.firefighter});

  @override
  State<stateBombero> createState() => _stateBomberoState();
}

class _stateBomberoState extends State<stateBombero> {
  @override
  Widget build(BuildContext context) {
    // User P = widget.firefighter;
    Color colorContainer;
    switch (widget.firefighter.state) {
      case 2:
        colorContainer = const Color.fromARGB(255, 255, 174, 52);
    //print("status : ${status["Emergencia"]}");
      default:
        colorContainer = Colors.green;
    }

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 242, 242, 242),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border:
          Border.all(width: 3, color: colorContainer), // Quitar el borde
        ),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 20),
              child: const CircleAvatar(
                maxRadius: 20,
                backgroundImage: NetworkImage(""), // insertar imagen de perfil
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.firefighter.state == status["Emergencia"])
                      const Text(
                        "Emergencia",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      )
                    else
                      const Text(
                        "Dispobible",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    Text(
                      "${widget.firefighter.firstName} ${widget.firefighter.lastName}",
                      style: const TextStyle(fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
