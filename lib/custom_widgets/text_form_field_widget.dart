import 'package:flutter/material.dart';
import 'package:reservation_app/services/constants.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  final void Function(String?) newValue;
  final String initialValue;

  const CustomTextFormFieldWidget(
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
