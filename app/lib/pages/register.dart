import 'package:app/object/stadistic.dart';
import 'package:flutter/material.dart';
//import 'package:app/pages/widget.dart';

import 'package:app/utils/colors.dart';

class tableRegister extends StatefulWidget {
  const tableRegister({super.key});

  @override
  State<tableRegister> createState() => _tableRegisterState();
}

class _tableRegisterState extends State<tableRegister> {
  @override
  Widget build(BuildContext context) {
    final List<Entries> args =
        ModalRoute.of(context)!.settings.arguments as List<Entries>;
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Registros",
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      //_appbar[_currentIndex],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
          child: SingleChildScrollView(
            child: Table(
              border: TableBorder.all(color: Colors.black),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                const TableRow(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 239, 224, 86),
                  ),
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Ingreso",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Salida",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                ...List.generate(
                  args.length,
                  (index) => TableRow(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${args[index].entryDateTime}"),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${args[index].exitDateTime}"),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ), /*AppBar(
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
    );
  }
}
