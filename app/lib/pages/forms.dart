import 'package:flutter/material.dart';

class forms extends StatefulWidget {
  const forms({super.key});

  @override
  State<forms> createState() => _formsState();
}

class _formsState extends State<forms> {
  // Form fields
  String? tipo;
  String? unidad;
  String? observacion;
  double? nivelDeAceite;

  // Dropdown menu items
  final List<String> tipoItems = ['Tipo 1', 'Tipo 2', 'Tipo 3'];
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

  void _submitForm() {
    if (_validateForm()) {
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
              // Tipo
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Tipo',
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

              // Unidad
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Unidad',
                ),
                value: unidad,
                items: unidadItems
                    .map((item) =>
                        DropdownMenuItem(value: item, child: Text(item)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    unidad = value;
                  });
                },
              ),

              // Observación
              TextFormField(
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nivel de aceite',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  nivelDeAceite = double.tryParse(value);
                },
              ),

              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
