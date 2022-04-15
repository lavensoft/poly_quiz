import "package:flutter/material.dart";

class TextBox extends StatefulWidget {
  TextBox({Key? key,required this.controller, this.hintText, this.obscureText = false}) : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;

  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16)
      ),
      child: TextField(
        obscureText: widget.obscureText,
        controller: widget.controller,
        style: const TextStyle(
          fontSize: 14
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}