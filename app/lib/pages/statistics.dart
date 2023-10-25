import 'package:app/pages/widget.dart';
import 'package:flutter/material.dart';

class statistics extends StatefulWidget {
  //const statistics({Key? key}) : super(key: key);

  @override
  State<statistics> createState() => _statisticsState();
}

class _statisticsState extends State<statistics> {
  List<String> list = <String>['Ultima Semana', 'Ultimo mes'];
  String dropdownValue = "";
  //int registros = 3; // registros Semanales

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black), // Quitar el borde
            ),
            child: DropdownMenu<String>(
              initialSelection: list.first,
              menuStyle: const MenuStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
              ),
              inputDecorationTheme: const InputDecorationTheme(
                focusColor: Colors.red,
              ),
              onSelected: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  print(value);
                  dropdownValue = value!;
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
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  Navigator.pushNamed(
                    context,
                    'registers',
                    arguments: [
                      {
                        'title': "Registros",
                        'registers': 3,
                      },
                      {
                        'title': "Registros",
                        'registers': 4,
                      },
                    ],
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                foregroundColor: Colors.black,
                backgroundColor: const Color.fromARGB(255, 249, 160, 160),
                elevation: 10,
                side: BorderSide(color: Colors.black, width: 1),
              ), // Quitar el borde
              child: Text("Ver Registros"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            child: Datahour(time: DateTime.now(), register: 1),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            child: Dataregister(title: "Registros"),
          ),
        ],
      ),
    );
  }
}
