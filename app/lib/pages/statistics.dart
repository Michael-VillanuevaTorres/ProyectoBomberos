import 'package:flutter/material.dart';

class statistics extends StatefulWidget {
  //const statistics({Key? key}) : super(key: key);

  @override
  State<statistics> createState() => _statisticsState();
}

class _statisticsState extends State<statistics> {
  List<String> list = <String>['Ultima Semana', 'Ultimo mes'];
  String dropdownValue = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black), // Quitar el borde
            ),
            child: DropdownMenu<String>(
              initialSelection: list.first,
              menuStyle: MenuStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
              ),
              inputDecorationTheme: InputDecorationTheme(
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
        ],
      ),
    );
  }
}
