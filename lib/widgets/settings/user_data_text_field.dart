import 'package:flutter/material.dart';

import 'package:makia_ai/constant_values.dart';

/*
    Renders the SUser-Data Text-Field Widget
 */
class UserDataTextField extends StatelessWidget {
  final String initialValue;
  final bool obscureText;
  final String labelText;
  final Function validator;
  final TextEditingController controller;
  final double letterSpacing;
  final bool readOnly;

  UserDataTextField({
    this.initialValue,
    this.obscureText = false,
    this.labelText,
    this.validator,
    this.controller,
    this.letterSpacing,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      obscureText: obscureText,
      initialValue: initialValue,
      style: TextStyle(
        letterSpacing: letterSpacing,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(
            color: primaryColor,
            width: 2.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(
            color: primaryColor,
            width: 2.5,
          ),
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          color: primaryColor,
          letterSpacing: 0.0,
        ),
        floatingLabelStyle: TextStyle(
          color: primaryColor,
          backgroundColor: Colors.white,
          letterSpacing: 0.0,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: defaultPadding,
          horizontal: 25,
        ),
      ),
    );
  }
}
