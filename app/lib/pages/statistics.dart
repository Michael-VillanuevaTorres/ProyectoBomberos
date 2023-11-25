import 'package:app/object/stadistic.dart';
import 'package:app/pages/widget.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class statistics extends StatefulWidget {
  //const statistics({Key? key}) : super(key: key);

  @override
  State<statistics> createState() => _statisticsState();
}

class _statisticsState extends State<statistics> {
  late Datatimes _statsweek;
  late Datatimes _stats;
  late Datatimes _statsmonth;

  late Future<void> _initLoad;
  Future<void> getStadistics() async {
    try {
      final responseweek = await http
          .get(Uri.parse('http://perrera.inf.udec.cl:1522/entrytime/summary/1/1'));
      final responsemonth = await http
          .get(Uri.parse('http://perrera.inf.udec.cl:1522/entrytime/summary/1/30'));
      if (responseweek.statusCode == 200 && responsemonth.statusCode == 200) {
        _statsweek = Datatimes.fromJson(json.decode(responseweek.body));
        _stats = _statsweek;
        _statsmonth = Datatimes.fromJson(json.decode(responsemonth.body));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _initLoad = getStadistics();
  }

  List<String> list = <String>['Última Semana', 'Último mes'];
  String dropdownValue = "";
  double ready = 5.1;
  final double total = 20.3;

  final colorList = <Color>[Colors.greenAccent, Colors.redAccent];

  @override
  Widget build(BuildContext context) {
    final double missing = total - ready;
    final dataMap = <String, double>{
      "Horas realizadas": ready,
      "Horas faltantes": missing,
    };
    return FutureBuilder(
      future: _initLoad,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            {
              return Center(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.black), // Quitar el borde
                      ),
                      child: DropdownMenu<String>(
                        width: 170,
                        initialSelection: list.last,
                        menuStyle: const MenuStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.white),
                        ),
                        inputDecorationTheme: const InputDecorationTheme(
                          focusColor: Colors.red,
                        ),
                        onSelected: (String? value) {
                          dropdownValue = value!;

                          if (dropdownValue == "Última Semana") {
                            _stats = _statsweek;
                            ready = _stats.entryCount.toDouble();
                          } else {
                            _stats = _statsmonth;
                            ready = _stats.entryCount.toDouble();
                          } // This is called when the user selects an item.
                          setState(
                            () {},
                          );
                        },
                        dropdownMenuEntries: list
                            .map<DropdownMenuEntry<String>>(
                              (String value) => DropdownMenuEntry<String>(
                                  value: value, label: value),
                            )
                            .toList(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            Navigator.pushNamed(context, 'registers',
                                arguments: _stats.entrytimes);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          foregroundColor: Colors.black,
                          backgroundColor:
                              const Color.fromARGB(255, 249, 160, 160),
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
                      child: Dataregister(
                        title: "Registros",
                        register: _stats.entryCount,
                      ),
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
    );
  }
}
