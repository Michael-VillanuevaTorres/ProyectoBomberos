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
  final _formKeyAgua = GlobalKey<FormState>();
  final _formKeyUnidad = GlobalKey<FormState>();
  final _formKeyCombustible = GlobalKey<FormState>();
  final _formKeytype = GlobalKey<FormState>();

  TextEditingController _AceiteController = TextEditingController();
  TextEditingController _AguaController = TextEditingController();
  TextEditingController _ObservacionController = TextEditingController();
  TextEditingController _CombustibleController = TextEditingController();
  TextEditingController _UnidadController = TextEditingController();

  String? tipo;
  List<String> types = ['Uso común', 'Mantención', 'Reparación'];
  String? selected;
  bool validarTodosLosFormularios() {
    bool todosLosFormulariosValidos = true;

    for (var formKey in [
      _formKeyAceite,
      _formKeyUnidad,
      _formKeyAgua,
      _formKeyCombustible,
      _formKeytype
    ]) {
      if (formKey.currentState!.validate() == false) {
        // Marcar que al menos un formulario no es válido
        todosLosFormulariosValidos = false;
      }
    }
    return todosLosFormulariosValidos;
  }

  Widget nivelesNrico(String labelT, GlobalKey<FormState> formKey,
          TextEditingController controller) =>
      Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelT,
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
      );
  // Dropdown menu items
  final List<String> tipoItems = [
    'Bitacora'
  ]; //, 'Formulario 2', 'Formulario 3'];
  final List<String> unidadItems = ['Unidad 1', 'Unidad 2', 'Unidad 3'];

  // Validate the form

  Future<void> sendpush(String titulo, String observacion) async {
    final response = await http.post(
      Uri.parse('http://${dotenv.env['BASE_URL']}:1522/user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "Unidad": _UnidadController.text,
        "Observacion": _ObservacionController.text,
        "Nivel de aceite": _AceiteController.text,
      }),
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
          Form(
            key: _formKeytype,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Tipo bitacora',
              ),
              value: selected,
              items: types
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el motivo de la bitacora';
                }
                return null; // La validación pasó correctamente
              },
              onChanged: (salutation) {
                setState(() {
                  selected = salutation!;
                });
              },
            ),
          ),
          Form(
            key: _formKeyUnidad,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              controller: _UnidadController,
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
            controller: _ObservacionController,
            decoration: InputDecoration(
              labelText: 'Observación',
            ),
            maxLines: 3,
            maxLength: 255,
          ),

          nivelesNrico("Nivel de Aceite", _formKeyAceite, _AceiteController),
          nivelesNrico("Nivel de Agua", _formKeyAgua, _AguaController),
          nivelesNrico("Nivel de Combustible", _formKeyCombustible,
              _CombustibleController)
        ],
      ),
    );
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
                tipo == null
                    ? Container()
                    : ElevatedButton(
                        onPressed: () {
                          if (validarTodosLosFormularios()) {
                            // La validación pasó correctamente
                            print('Form submitted successfully!');
                          } else {
                            print('Form validation failed.');
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
