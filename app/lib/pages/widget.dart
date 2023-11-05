import 'package:flutter/material.dart';
import 'package:app/utils/globals.dart';

class buttonMenu extends StatefulWidget {
  final Color color;
  final String text;
  final IconData icon;
  final Function setTime;
  final int type;
  const buttonMenu({
    required this.color,
    required this.text,
    required this.icon,
    required this.setTime,
    required this.type,
  });
  @override
  State<buttonMenu> createState() => _buttonMenuState();
}

class _buttonMenuState extends State<buttonMenu> {
  int idUser = Globals.returnID(Globals.token);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(20),
      ),
      width: 200,
      height: 50,
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.black,
            elevation: 7,
            backgroundColor: widget.color,
          ),
          onPressed: () {
            setState(
              () {
                widget.setTime(widget.type, idUser);
              },
            );
          },
          icon: Icon(widget.icon, color: Colors.white, size: 30),
          label: Text(
            widget.text,
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
    );
  }
}

class CustomAppBarAcceso extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  final String text;
  CustomAppBarAcceso({required this.text});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, 'actives');
          },
          icon: Icon(
            Icons.people,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, 'perfil');
          },
          icon: Icon(Icons.settings, color: Colors.white),
        ),
      ],
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.white, fontSize: 23),
        ),
      ),
    );
  }
}

class Datahour extends StatefulWidget {
  //const Datahour({super.key});
  DateTime time;
  int register;
  Datahour({required this.time, required this.register});
  @override
  State<Datahour> createState() => _DatahourState();
}

class _DatahourState extends State<Datahour> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Horas Realizadas",
          style: TextStyle(fontSize: 15),
        ),
        Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black), // Quitar el borde
          ),
          child: Center(
            child: Text("${widget.time.hour}:${widget.time.minute}"),
          ),
        ),
      ],
    );
  }
}

class Dataregister extends StatefulWidget {
  //const _Dataregister({super.key});
  String title;
  int register;
  //int register;
  Dataregister({required this.title, required this.register});
  @override
  State<Dataregister> createState() => _DataregisterState();
}

class _DataregisterState extends State<Dataregister> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.title,
          style: TextStyle(fontSize: 15),
        ),
        Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black), // Quitar el borde
          ),
          child: Center(
            child: Text("${widget.register}"), // Entregar numero de registros
          ),
        ),
      ],
    );
  }
}
