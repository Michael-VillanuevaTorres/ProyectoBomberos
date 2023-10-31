import 'package:app/pages/widget.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class statistics extends StatefulWidget {
  //const statistics({Key? key}) : super(key: key);

  @override
  State<statistics> createState() => _statisticsState();
}

class _statisticsState extends State<statistics> {
  List<String> list = <String>['Última Semana', 'Último mes'];
  String dropdownValue = "";
  double ready = 5.1;
  final double total = 20.3;

  final colorList = <Color>[Colors.greenAccent, Colors.redAccent];
  //int registros = 3; // registros Semanales

  @override
  Widget build(BuildContext context) {
    final double missing = total - ready;

    final dataMap = <String, double>{
      "Horas realizadas": ready,
      "Horas faltantes": missing,
    };
    return Center(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black), // Quitar el borde
            ),
            child: DropdownMenu<String>(
              width: 170,
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
                  if (dropdownValue == "Última Semana") {
                    ready = 3;
                    //registros = 3;
                  } else {
                    ready = 5.1;
                    //registros = 4;
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
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                side: const BorderSide(color: Colors.black, width: 1),
              ), // Quitar el borde
              child: const Text("Ver Registros"),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            child: Datahour(time: DateTime.now(), register: 1),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            child: Dataregister(title: "Registros"),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PieChart(
              chartRadius: 150,
              dataMap: dataMap,
              legendOptions: const LegendOptions(
                showLegendsInRow: true,
                legendPosition: LegendPosition.top,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartType: ChartType.ring,
              baseChartColor: Colors.grey[50]!.withOpacity(0.15),
              colorList: colorList,
              chartValuesOptions: const ChartValuesOptions(
                showChartValuesInPercentage: false,
              ),
              totalValue: total.toDouble(),
            ),
          ),
        ],
      ),
    );
  }
}
