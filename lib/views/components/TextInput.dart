
import 'package:flutter/material.dart';


class TextInput extends StatefulWidget {
  final String? placeholder;
  final bool obscureText;
  final TextEditingController? controller;

  const TextInput({super.key, this.placeholder, this.obscureText = false, this.controller});

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}
