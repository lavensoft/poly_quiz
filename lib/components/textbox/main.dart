import "package:flutter/material.dart";

class TextBox extends StatefulWidget {
  TextBox({Key? key,
    this.placeholder = '', 
    this.obscureText = false,
    this.controller,
    this.onChanged
  }) : super(key: key);

  final String placeholder;
  final bool obscureText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

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
        onChanged: (e) {
          widget.onChanged!(e);
        },
        autofillHints: [],
        controller: widget.controller,
        obscureText: widget.obscureText,
        style: const TextStyle(
          fontSize: 14
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.placeholder,
          hintStyle: const TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}