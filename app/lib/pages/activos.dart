import 'dart:convert';
import 'package:app/object/users.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:app/utils/colors.dart';

const status = {
  "Emergencia": 0,
  "Disponible": 1,
};

class available extends StatefulWidget {
  @override
  State<available> createState() => _availableState();
}

class _availableState extends State<available> {
  Future<List<User>> getUser(int value) async {
    try {
      final response =
          await http.get(Uri.parse("http://127.0.0.1:5000/api/v1/usersAll"));
      //if (response.statusCode == 200) {
      // Si la solicitud es exitosa y el estado es 200 (OK), analizamos los datos
      List users = json.decode(response.body);
      // Convertir la lista dinámica a una lista de Map<String, dynamic>
      List<User> list = users.map((user) => User.fromJson(user)).toList();
      if (value == 2) {
        return list;
      }
      return list.where((element) => element.status == value).toList();
    } catch (error) {
      // Manejo de errores de la solicitud
      throw Exception('Failed to load User');
    }
  }

  List<String> list = <String>['Todos', 'Activos', 'Emergencia'];
  int? dropdownValue = 2;

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
            "Disponibles",
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            /*Container(
              height: 20,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black), // Quitar el borde
              ),
              child: */
            Container(
              margin: const EdgeInsets.only(top: 10),
              /*child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  /*hint: const Row(
                    children: [
                      Icon(
                        Icons.list,
                        size: 16,
                        color: Colors.yellow,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          'Select Item',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),*/
                  items: list
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  value: dropdownValue,
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 40,
                    width: 160,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: Colors.white,
                    ),
                    elevation: 2,
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                    iconSize: 14,
                    iconEnabledColor: Colors.red,
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.amber,
                    ),
                    offset: const Offset(-20, 0),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all<double>(6),
                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 30,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),*/
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
                          dropdownValue = 2;
                          break;
                        case "Activos":
                          dropdownValue = 1;
                          break;
                        case "Emergencia":
                          dropdownValue = 0;
                          break;
                      }
                      print(dropdownValue);
                    });
                  },
                  dropdownMenuEntries: list
                      .map<DropdownMenuEntry<String>>(
                        (String value) => DropdownMenuEntry<String>(
                            value: value, label: value),
                      )
                      .toList(),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<User>>(
                  future: getUser(dropdownValue!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = snapshot.data![index];
                            return stateBombero(firefighter: item);
                          });
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
              /*child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: listFilter.length,
                itemBuilder: (BuildContext context, int index) {
                  return stateBombero(firefighter: listFilter[index]);
                },
              ),*/
            ),
          ],
        ),
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
    switch (widget.firefighter.status) {
      case 0:
        colorContainer = const Color.fromARGB(255, 255, 174, 52);
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
                    if (widget.firefighter.status == status["Emergencia"])
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
                      "${widget.firefighter.name} ${widget.firefighter.apellido}",
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
