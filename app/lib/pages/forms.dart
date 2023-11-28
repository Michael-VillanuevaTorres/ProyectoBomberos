import 'dart:convert';

import 'package:app/pages/widget.dart';
import 'package:app/token/accces_token-dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class forms extends StatefulWidget {
  const forms({super.key});

  @override
  State<forms> createState() => _formsState();
}

double transformFraction(String number) {
  if (number == "0") {
    return 0;
  }
  final List<String> split = number.split("/");
  final double actualRatio =
      double.parse(split.first) / double.parse(split.last);
  return actualRatio;
  //print("value: ${actualRatio}");
}

class _formsState extends State<forms> {
  // Form fields
  Auth auth = Auth();
  final _formKeyAceite = GlobalKey<FormState>();
  final _formKeyAgua = GlobalKey<FormState>();
  final _formKeyUnidad = GlobalKey<FormState>();
  final _formKeyCombustible = GlobalKey<FormState>();
  final _formKeytype = GlobalKey<FormState>();

  final TextEditingController _observacionController = TextEditingController();

  final TextEditingController _unidadController = TextEditingController();

  String? tipo;
  List<Map<String, dynamic>> types = [
    {'label': 'Uso común', 'value': "Single_use"},
    {'label': 'Mantención', 'value': "Maintenance"},
    {'label': 'Reparación', 'value': "Repair"},
  ];
  List<Map<String, dynamic>> unit = [
    {'label': '0', 'value': "0"},
    {'label': '1/4', 'value': "1/4"},
    {'label': '1/3', 'value': "1/3"},
    {'label': '1/2', 'value': "1/2"},
    {'label': '2/3', 'value': "2/3"},
    {'label': '3/4', 'value': "3/4"},
    {'label': '1', 'value': "1"},
  ];
  String? selectedWater, selectedFuel, selectedOil, selected;
  bool validarTodosLosFormularios() {
    bool todosLosFormulariosValidos = true;
    for (var formKey in [
      _formKeyUnidad,
      _formKeytype,
      _formKeyCombustible,
      _formKeyAgua,
      _formKeyAceite
    ]) {
      if (formKey.currentState!.validate() == false) {
        // Marcar que al menos un formulario no es válido
        todosLosFormulariosValidos = false;
      }
    }
    return todosLosFormulariosValidos;
  }

  // Dropdown menu items
  final List<String> tipoItems = [
    'Bitacora'
  ]; //, 'Formulario 2', 'Formulario 3'];
  final List<String> unidadItems = ['Unidad 1', 'Unidad 2', 'Unidad 3'];

  @override
  void initState() {
    super.initState();
    auth.loadToken();
  }
  // Validate the form

  Future<void> sendpush() async {
    double? selectedOilR, selectedFuelR, selectedWaterR;
    selectedOil == null
        ? selectedOilR = null
        : selectedOilR = transformFraction(selectedOil!);
    selectedWater == null
        ? selectedWaterR = null
        : selectedWaterR = transformFraction(selectedWater!);
    selectedWater == null
        ? selectedWaterR = null
        : selectedWaterR = transformFraction(selectedWater!);
    try {
      final response = await http.post(
        Uri.parse('http://${dotenv.env['BASE_URL']}:5000/logs'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "type": selected!,
          "description": _observacionController.text,
          "user_id": returnId(auth.token),
          "truck_patent": _unidadController.text,
          "oil_level": selectedOilR,
          "water_level": selectedWaterR,
          "fuel_level": selectedFuelR,
        }),
      );
      /*final respondeTruck = await http.put(
      Uri.parse(
          'http://${dotenv.env['BASE_URL']}:5000/trucks/${_unidadController.text}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{}),
    );*/
      if (response.statusCode == 201) {
        Fluttertoast.showToast(
            msg: "Formulario enviado con exito",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      throw Exception('Error.');
    }
  }

  /*void _submitForm() {
    if (_formKeyAceite.currentState!.validate()) {
      // La validación pasó correctamente

      print('Form submitted successfully!');
    } else {
      print('Form validation failed.');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Center(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                /*Container(
                  height: 60,
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  width: MediaQuery.of(context).size.width * 2,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Formulario',
                    ),
                    value: tipo,
                    items: tipoItems
                        .map((item) =>
                            DropdownMenuItem(value: item, child: Text(item)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        tipo = value;
                      });
                    },
                  ),
                ),*/
                //tipo == "Bitacora" ? formBitacora() : Container(),

                // Tipo
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16),
                  child: Column(
                    children: [
                      // Unidad
                      Form(
                        key: _formKeytype,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Tipo bitacora',
                          ),
                          value: selected,
                          items: types
                              .map((Map<String, dynamic> item) =>
                                  DropdownMenuItem<String>(
                                      value: item['value'],
                                      child: Text(item['label'])))
                              .toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese el motivo de la bitacora';
                            }
                            return null; // La validación pasó correctamente
                          },
                          onChanged: (value) {
                            setState(() {
                              selected = value!;
                            });
                          },
                        ),
                      ),
                      Form(
                        key: _formKeyUnidad,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                          controller: _unidadController,
                          decoration: InputDecoration(
                            labelText: 'Unidad',
                          ),
                          maxLines: 1,
                          maxLength: 50,
                          onChanged: (value) {
                            _formKeyUnidad.currentState!
                                .validate(); // Realiza la validación en tiempo real
                          },
                        ),
                      ),

                      // Observación
                      TextFormField(
                        controller: _observacionController,
                        decoration: InputDecoration(
                          labelText: 'Observación',
                        ),
                        maxLines: 3,
                        maxLength: 255,
                      ),
                      Form(
                        key: _formKeyCombustible,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Nivel de Combustible",
                          ),
                          value: selectedFuel,
                          items: unit
                              .map((Map<String, dynamic> item) =>
                                  DropdownMenuItem<String>(
                                      value: item['value'],
                                      child: Text(item['label'])))
                              .toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese el nivel de combustible la unidad seleccionada';
                            }
                            return null; // La validación pasó correctamente
                          },
                          onChanged: (value) {
                            setState(() {
                              selectedFuel = value;
                            });
                          },
                        ),
                      ),
                      Form(
                        key: _formKeyAceite,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Nivel de Aceite",
                          ),
                          value: selectedOil,
                          items: unit
                              .map((Map<String, dynamic> item) =>
                                  DropdownMenuItem<String>(
                                      value: item['value'],
                                      child: Text(item['label'])))
                              .toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese el nivel de aceite de la unidad seleccionada';
                            }
                            return null; // La validación pasó correctamente
                          },
                          onChanged: (value) {
                            setState(() {
                              selectedOil = value;
                            });
                          },
                        ),
                      ),
                      Form(
                        key: _formKeyAgua,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Nivel de Agua",
                          ),
                          value: selectedWater,
                          items: unit
                              .map((Map<String, dynamic> item) =>
                                  DropdownMenuItem<String>(
                                      value: item['value'],
                                      child: Text(item['label'])))
                              .toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese el nivel de agua de la unidad seleccionada';
                            }
                            return null; // La validación pasó correctamente
                          },
                          onChanged: (value) {
                            setState(() {
                              selectedWater = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Submit button
                ElevatedButton(
                  onPressed: () async {
                    if (validarTodosLosFormularios()) {
                      // La validación pasó correctamente
                      await sendpush();
                    } else {
                      Fluttertoast.showToast(
                          msg: "Error al enviar formulario",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: const Text('Enviar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
