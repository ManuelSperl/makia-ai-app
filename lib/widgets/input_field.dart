import 'package:flutter/material.dart';

import 'package:makia_ai/constant_values.dart';
import 'package:makia_ai/executing_device.dart';

/*
    Renders the Imput-Field Widget
 */
class InputField extends StatelessWidget {
  final double borderRadius;
  final TextInputType textInputType;
  final Widget suffixIcon;
  final bool obscureText;
  final String labelText;
  final String hintText;
  final Function onChanged;
  final Function validator;
  final TextEditingController controller;

  InputField({
    this.borderRadius = 40.0,
    @required this.textInputType,
    this.suffixIcon,
    this.obscureText = false,
    @required this.labelText,
    @required this.hintText,
    this.onChanged,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = Colors.black38;
    double padding = !ExecutingDevice.isMobile(context) ? defaultPadding * 20 : defaultPadding;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: textInputType,
        style: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          helperText: "",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: primaryColor,
              width: 2.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: primaryColor,
              width: 2.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: errorColor,
              width: 2.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: errorColor,
              width: 2.5,
            ),
          ),
          counterStyle: TextStyle(
            fontSize: 30,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: defaultPadding / 2,
            horizontal: 25,
          ),
          floatingLabelStyle: TextStyle(
            color: primaryColor,
            backgroundColor: Colors.white,
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 16,
            color: textColor,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            color: textColor,
          ),
          errorStyle: TextStyle(
            fontSize: 12,
            color: errorColor,
          ),
          suffixIcon: suffixIcon,
          fillColor: Colors.white,
          filled: true,
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
