import 'package:flutter/material.dart';

class buttonMenu extends StatefulWidget {
  final Color color;
  final String text;
  final IconData icon;
  const buttonMenu({
    required this.color,
    required this.text,
    required this.icon,
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
            print(DateTime.now());
          },
          icon: Icon(widget.icon),
          label: Text(widget.text)),
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
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.person, color: Colors.white),
        ),
      ],
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
