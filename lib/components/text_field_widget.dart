import 'package:flutter/material.dart';
import 'package:reservation_app/constants.dart';

class TextFieldWidget extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  void Function(String?) newValue;

  TextFieldWidget(
      {Key? key,
      required this.text,
      required this.controller,
      required this.newValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      margin: const EdgeInsets.all(15.0),
      child: TextField(
        controller: controller,
        decoration: kTextFieldDecoration.copyWith(hintText: text),
        style: kReservationDetails,
        onChanged: newValue,
      ),
    );
  }
}
