import 'package:flutter/material.dart';
import 'package:reservation_app/services/constants.dart';

class CustomRoundedButton extends StatelessWidget {
  const CustomRoundedButton(
      {Key? key,
      required this.title,
      required this.onPressed,
      required this.iconData,
      required this.textStyle})
      : super(key: key);
  final TextStyle textStyle;
  final String title;
  final VoidCallback onPressed;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: kButtonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(iconData),
              const SizedBox(
                width: 20.0,
              ),
              Text(title, style: textStyle),
            ],
          ),
        ),
      ),
    );
  }
}
