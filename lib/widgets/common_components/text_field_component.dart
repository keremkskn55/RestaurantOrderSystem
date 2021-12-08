import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class TextFieldComponent extends StatelessWidget {
  Icon? sentPrefixIcon;
  String? sentHintText;
  final TextEditingController ctr;

  TextFieldComponent(
      {this.sentPrefixIcon, this.sentHintText, required this.ctr});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctr,
      validator: (_val) {
        if (sentHintText == 'E-mail') {
          if (!EmailValidator.validate(_val!)) {
            return 'Please enter valid email address';
          } else {
            return null;
          }
        }
        if (sentHintText == 'Password' || sentHintText == 'Password Again') {
          if (_val!.length < 6) {
            return 'Please enter password more 6 character';
          } else {
            return null;
          }
        }
        if (sentHintText == 'Restaurant Name') {
          if (_val!.isEmpty) {
            return 'Please enter a name';
          }
        }
      },
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
