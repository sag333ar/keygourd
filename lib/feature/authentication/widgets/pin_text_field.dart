import 'package:flutter/material.dart';

class PinTextField extends StatelessWidget {
  const PinTextField(
      {super.key,
      required this.textEditingController,
      this.validator,
      this.onChanged,
      this.textInputType,
      this.isObscure = true,
      this.readOnly = false});

  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextInputType? textInputType;
  final bool isObscure;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: isObscure ? 6 : null,
      readOnly: readOnly,
      controller: textEditingController,
      validator: validator,
      onChanged: onChanged,
      obscureText: isObscure,
      keyboardType: textInputType ?? TextInputType.number,
      decoration: const InputDecoration(),
    );
  }
}
