import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class available extends StatefulWidget {
  @override
  State<available> createState() => _availableState();
}

class _availableState extends State<available> {
  List<String> list = <String>['Todos', 'Conductor', 'Bombero'];
  String? dropdownValue = "Todos";
  @override
  Widget build(BuildContext context) {
    return Container(
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
            margin: EdgeInsets.only(top: 10),
            child: DropdownButtonHideUnderline(
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
              ),
              /*child: DropdownMenu<String>(
                width: 200,
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
              ),*/
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return stateBombero();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class stateBombero extends StatefulWidget {
  @override
  State<stateBombero> createState() => _stateBomberoState();
}

class _stateBomberoState extends State<stateBombero> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 242, 242, 242),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 2, color: Colors.green), // Quitar el borde
      ),
      height: 50,
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Cargo",
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                    "Nombre",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
