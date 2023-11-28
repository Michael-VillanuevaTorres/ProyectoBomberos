import 'package:app/main.dart';
import 'package:app/pages/perfil.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/notifications.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

int returnId(String? token) {
  if (token == null) return -1;
  Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  return decodedToken["sub"];
}

String transformTodouble(String value) {
  var num = double.parse(value);
  if (num == 0) {
    return "0";
  } else if (num == (1 / 4)) {
    return "1/4";
  } else if (num == (1 / 3)) {
    return "1/3";
  } else if (num == (1 / 2)) {
    return "1/2";
  } else if (num == (2 / 3)) {
    return "2/3";
  } else if (num == (3 / 4)) {
    return "3/4";
  } else {
    return "1";
  }
}

class buttonMenu extends StatefulWidget {
  final Color color;
  final String text;
  final IconData icon;
  final Function onPressed;
  final int type;
  const buttonMenu({
    required this.color,
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.type,
  });
  @override
  State<buttonMenu> createState() => _buttonMenuState();
}

class _buttonMenuState extends State<buttonMenu> {
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
            setState(() {
              widget
                  .onPressed(); // Call the onPressed callback instead of setTime
            });
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
            navigatorKey.currentState?.pushNamed(notification.route);
          },
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            navigatorKey.currentState?.pushNamed(perfil.route);
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
