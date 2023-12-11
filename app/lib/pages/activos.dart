import 'dart:convert';
import 'package:app/object/users.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Estados posible de un bombero
const status = {
  "Emergencia": 2,
  "Disponible": 1,
  "Desconectado": 0,
};

class available extends StatefulWidget {
  @override
  State<available> createState() => _availableState();
}

class _availableState extends State<available> {
  // Variables para almacenar los bomberos activos y en emergencia
  late Future<void> _initLoad;
  late List<dynamic> users;
  late List<dynamic> activeUser;
  late List<dynamic> warningUser;

  // Obtener bomberos según la opción seleccionada en el dropdown
  // Option : 0 -> Todos, 1 -> Activos, 2 -> Emergencia
  Future<void> getUser(int option) async {
    try {
      Future.delayed(const Duration(seconds: 5));
      // Obtener bomberos activos mediante la API
      final responseActive = await http.get(
          Uri.parse("http://${dotenv.env['BASE_URL']}/user/users_by_state/1"));
      activeUser = json.decode(responseActive.body);

      // Obtener los bomberos en emergencia desde la API
      final responseWarning = await http.get(
          Uri.parse("http://${dotenv.env['BASE_URL']}/user/users_by_state/2"));
      warningUser = json.decode(responseWarning.body);

      // Si la respuesta es 200, se almacenan los bomberos en sus respectivas listas
      if (responseActive.statusCode == 200 &&
          responseWarning.statusCode == 200) {
        setState(() {
          activeUser = activeUser.map((user) => User.fromJson(user)).toList();
          warningUser = warningUser.map((user) => User.fromJson(user)).toList();
          if (option == 0) users = activeUser + warningUser;
          if (option == 1) users = activeUser;
          if (option == 2) users = warningUser;
        });
      }
    } catch (error) {
      throw Exception('Failed to load User');
    }
  }

  // Método llamado al iniciar el estado del widget
  @override
  void initState() {
    super.initState();
    _initLoad = () async {
      await getUser(0);
    }();
  }

// lista de opciones del dropdown
  List<String> list = <String>['Todos', 'Activos', 'Emergencia'];
  int? dropdownValue = 0; // valor incial del dropdown

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
                    // Al seleccionar un valor se actualiza la lista de bomberos
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
          // Lista de bomberos
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
                                return stateBombero(context, item);
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

/*class stateBombero extends StatefulWidget {
  User firefighter;
  stateBombero({required this.firefighter});

  @override
  State<stateBombero> createState() => _stateBomberoState();
}

class _stateBomberoState extends State<stateBombero> {*/

// Widget que se muentra el bombero en la lista y su estado correspondiente
Widget stateBombero(BuildContext context, User firefighter) {
  // User P = widget.firefighter;
  Color colorContainer;
  switch (firefighter.state) {
    case 2:
      colorContainer = const Color.fromARGB(255, 255, 174, 52);
    default:
      colorContainer = Colors.green;
  }
  return Center(
    child: Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 242, 242, 242),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 3, color: colorContainer), // Quitar el borde
      ),
      height: 55,
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, right: 20),
            child: firefighter.image != null
                ? Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: MemoryImage(base64Decode(firefighter.image!)),
                      ),
                    ),
                  )
                : const CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage('assets/bombero.png'),
                  ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (firefighter.state == status["Emergencia"])
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
                    "${firefighter.firstName} ${firefighter.lastName}",
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
