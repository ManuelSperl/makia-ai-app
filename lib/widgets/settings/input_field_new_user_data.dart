import 'package:flutter/material.dart';

import 'package:makia_ai/constant_values.dart';

/*
    Renders the Input-Field for new User-Data Widget
 */
class InputFieldNewUserData extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Function onChanged;
  final TextEditingController controller;
  final Widget suffixIcon;
  final bool obscureText;
  final Function validator;

  InputFieldNewUserData({
    this.labelText,
    this.hintText,
    this.onChanged,
    this.controller,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
          borderSide: BorderSide(
            color: primaryColor,
            width: 2.5,
          ),
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey[500],
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500],
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
          borderSide: BorderSide(
            color: primaryColor,
            width: 2.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
          borderSide: BorderSide(
            color: primaryColor,
            width: 2.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
          borderSide: BorderSide(
            color: errorColor,
            width: 2.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
          borderSide: BorderSide(
            color: errorColor,
            width: 2.5,
          ),
        ),
        floatingLabelStyle: TextStyle(
          color: primaryColor,
          backgroundColor: Colors.white,
        ),
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
