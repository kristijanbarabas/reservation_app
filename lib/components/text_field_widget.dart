import 'package:flutter/material.dart';
import 'package:reservation_app/constants.dart';

class TextFieldWidget extends StatelessWidget {
  void Function(String?) newValue;
  final String initialValue;

  TextFieldWidget(
      {Key? key, required this.newValue, required this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      margin: const EdgeInsets.all(15.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: kTextFieldDecoration,
        style: kMainMenuFonts,
        onChanged: newValue,
      ),
    );
  }
}
