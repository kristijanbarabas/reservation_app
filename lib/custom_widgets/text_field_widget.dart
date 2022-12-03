import 'package:flutter/material.dart';
import 'package:reservation_app/services/constants.dart';

// TODO delete if not used
class CustomTextFieldWidget extends StatelessWidget {
  CustomTextFieldWidget(
      {Key? key,
      required this.newValue,
      this.textInputType = TextInputType.text,
      required this.hintText,
      this.obscureText = false})
      : super(key: key);
  late final String newValue;
  final TextInputType textInputType;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      style: kTextFieldInputStyle,
      keyboardType: textInputType,
      textAlign: TextAlign.center,
      onChanged: (value) {
        newValue = value;
      },
      decoration: kTextFieldDecoration.copyWith(hintText: hintText),
    );
  }
}
