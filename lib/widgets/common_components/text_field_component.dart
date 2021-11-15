import 'package:flutter/material.dart';

class TextFieldComponent extends StatelessWidget {
  Icon? sentPrefixIcon;
  String? sentHintText;

  TextFieldComponent({this.sentPrefixIcon, this.sentHintText});
  final TextEditingController _ctr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _ctr,
      decoration: InputDecoration(
        prefixIcon: sentPrefixIcon,
        hintText: sentHintText,
        hintStyle: TextStyle(color: Colors.black),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
    );
  }
}
