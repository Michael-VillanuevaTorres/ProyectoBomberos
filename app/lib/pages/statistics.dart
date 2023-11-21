import 'package:app/main.dart';
import 'package:app/object/stadistic.dart';
import 'package:app/pages/register.dart';
import 'package:app/pages/widget.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class statistics extends StatefulWidget {
  //const statistics({Key? key}) : super(key: key);

  @override
  State<statistics> createState() => _statisticsState();
}

class _statisticsState extends State<statistics> {
  late DateTimes _statsweek;
  late DateTimes _stats;
  late DateTimes _statsmonth;

  double timetoHour(String totalHoursWorked) {
    List<String> s = _stats.totalHoursWorked.split(":");
    double suma = double.parse(s[0]) +
        double.parse(s[1]) / 60 +
        (double.parse(s[2]) / 3600);
    return suma;
  }

  late Future<void> _initLoad;
  Future<void> getStadistics() async {
    try {
      final responseweek = await http.get(Uri.parse(
          'http://${dotenv.env['BASE_URL']}:5000/entrytime/summary/1/2'));
      final responsemonth = await http.get(Uri.parse(
          'http://${dotenv.env['BASE_URL']}:5000/entrytime/summary/1/30'));
      if (responseweek.statusCode == 200 && responsemonth.statusCode == 200) {
        _statsweek = DateTimes.fromJson(json.decode(responseweek.body));
        _stats = _statsweek;
        _statsmonth = DateTimes.fromJson(json.decode(responsemonth.body));
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
  final double total = 20;
  double? ready;

  final colorList = <Color>[Colors.greenAccent, Colors.redAccent];

  @override
  Widget build(BuildContext context) {
    /*final DataMap = <String,double>{
      "Horas realizadas": ((timetoHour(_stats.totalHoursWorked) * 100) / total),
      "Horas faltantes":
          ((total - timetoHour(_stats.totalHoursWorked)) * 100) / total,
    };*/
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
                      child: DropdownButtonFormField<String>(
                        /*decoration: InputDecoration(
                          labelText: 'Unidad',
                        ),*/
                        value: list.first,
                        items: list
                            .map((item) => DropdownMenuItem(
                                value: item, child: Text(item)))
                            .toList(),
                        onChanged: (value) {
                          dropdownValue = value!;

                          if (dropdownValue == "Última Semana") {
                            _stats = _statsweek;
                            ready = timetoHour(_stats.totalHoursWorked);
                          } else {
                            _stats = _statsmonth;
                            ready = timetoHour(_stats.totalHoursWorked);
                          } // This is called when the user selects an item.
                          setState(
                            () {},
                          );
                          //setState(() {});
                        },
                        /*width: 170,
                        initialSelection: list.first,
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
                            ready = timetoHour(_stats.totalHoursWorked);
                          } else {
                            _stats = _statsmonth;
                            ready = timetoHour(_stats.totalHoursWorked);
                          } // This is called when the user selects an item.
                          /*setState(
                            () {},
                          );*/
                        },
                        dropdownMenuEntries: list
                            .map<DropdownMenuEntry<String>>(
                              (String value) => DropdownMenuEntry<String>(
                                  value: value, label: value),
                            )
                            .toList(),
                      ),*/
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            navigatorKey.currentState?.pushNamed(
                                tableRegister.route,
                                arguments: _stats.entries);
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
                      child:
                          Datahour(time: _stats.totalHoursWorked, register: 1),
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
                        dataMap: <String, double>{
                          "Horas realizadas":
                              (timetoHour(_stats.totalHoursWorked)) >= total
                                  ? total
                                  : timetoHour(_stats.totalHoursWorked),
                          "Horas faltantes":
                              total - timetoHour(_stats.totalHoursWorked) < 0
                                  ? 0
                                  : total - timetoHour(_stats.totalHoursWorked),
                        },
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
                          showChartValuesInPercentage: true,
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
