import 'package:flutter/material.dart';
import 'package:reservation_app/constants.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  void Function(String?) newValue;
  final String labelText;
  final String hintText;

  TextFieldWidget(
      {Key? key,
      required this.controller,
      required this.newValue,
      required this.labelText,
      required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      margin: const EdgeInsets.all(15.0),
      child: TextFormField(
        controller: controller,
        decoration: kTextFieldDecoration.copyWith(
            labelText: labelText, hintText: hintText),
        style: kGoogleFonts,
        onChanged: newValue,
      ),
    );
  }
}
