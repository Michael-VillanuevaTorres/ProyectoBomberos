import 'package:flutter/material.dart';

class available extends StatefulWidget {
  @override
  State<available> createState() => _availableState();
}

class _availableState extends State<available> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: 100,
        height: MediaQuery.of(context).size.height * 0.5,
        color: Colors.red,
        child: Text("hola"),
      ),
    );
  }
}
