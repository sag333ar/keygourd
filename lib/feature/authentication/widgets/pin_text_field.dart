import 'package:flutter/material.dart';

class PinTextField extends StatelessWidget {
  const PinTextField({super.key, required this.textEditingController, this.validator});

  final TextEditingController textEditingController;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      validator: validator,
      obscureText: true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(),
    );
  }
}
