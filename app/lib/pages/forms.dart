import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class forms extends StatefulWidget {
  const forms({super.key});

  @override
  State<forms> createState() => _formsState();
}

class _formsState extends State<forms> {
  // Form fields
  final _formKeyAceite = GlobalKey<FormState>();
  TextEditingController _AceiteController = TextEditingController();
  TextEditingController _ObservacionController = TextEditingController();

  double? _enteredValue; // Valor ingresado en el campo de texto
  String? tipo;
  String? unidad;
  String? observacion;
  double? nivelDeAceite;

  // Dropdown menu items
  final List<String> tipoItems = ['Bitacora', 'Formulario 2', 'Formulario 3'];
  final List<String> unidadItems = ['Unidad 1', 'Unidad 2', 'Unidad 3'];

  // Validate the form
  bool _validateForm() {
    if (tipo == null || tipo!.isEmpty) {
      return false;
    }

    if (unidad == null || unidad!.isEmpty) {
      return false;
    }

    if (nivelDeAceite == null || nivelDeAceite! <= 0) {
      return false;
    }

    return true;
  }

  Future<void> sendpush(String titulo, String observacion) async {
    final response = await http.post(
      Uri.parse('http://${dotenv.env['BASE_URL']}:5000/user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{"titulo": titulo, "observacion": observacion}),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Formulario enviado con exito",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      throw Exception('Error.');
    }
  }

  Widget formBitacora() {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16),
      child: Column(
        children: [
          // Unidad
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Unidad',
            ),
            value: unidad,
            items: unidadItems
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) {
              setState(() {
                unidad = value;
              });
            },
          ),

          // Observación
          TextFormField(
            controller: _ObservacionController,
            decoration: InputDecoration(
              labelText: 'Observación',
            ),
            maxLines: 3,
            maxLength: 255,
            onChanged: (value) {
              observacion = value;
            },
          ),

          // Nivel de aceite
          Form(
            key: _formKeyAceite,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              controller: _AceiteController,
              decoration: InputDecoration(
                labelText: 'Nivel de aceite',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor ingrese un número válido';
                }
                final enteredNumber = double.tryParse(value);
                if (enteredNumber == null || enteredNumber <= 0) {
                  return 'Ingrese un número válido mayor que 0';
                }
                return null; // La validación pasó correctamente
              },
              onChanged: (value) {
                _formKeyAceite.currentState!
                    .validate(); // Realiza la validación en tiempo real
              },
            ),
          )
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKeyAceite.currentState!.validate()) {
      // La validación pasó correctamente

      print('Form submitted successfully!');
    } else {
      print('Form validation failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
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
              ),
              tipo == "Bitacora" ? formBitacora() : Container(),

              // Tipo

              // Submit button

              ElevatedButton(
                onPressed: () {
                  if (_formKeyAceite.currentState!.validate()) {
                    // La validación pasó correctamente
                  }
                  ;
                  print('Form submitted successfully!');

                  print('Form validation failed.');
                },
                child: const Text('Enviar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
