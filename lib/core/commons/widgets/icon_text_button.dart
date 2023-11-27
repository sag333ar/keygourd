import 'package:flutter/material.dart';

class StyledIconTextButton extends StatelessWidget {
  const StyledIconTextButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.text});

  final VoidCallback onPressed;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
          backgroundColor: Colors.orange, shape: const StadiumBorder()),
      onPressed: onPressed,
      icon: Icon(icon,color: Colors.white,),
      label: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
