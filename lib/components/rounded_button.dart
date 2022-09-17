import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {Key? key,
      required this.color,
      required this.title,
      required this.onPressed,
      required this.textStyle,
      required this.iconData})
      : super(key: key);
  final TextStyle textStyle;
  final Color color;
  final String title;
  final VoidCallback onPressed;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
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
