import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;

  InputField(
      {super.key,
      required this.hintText,
      this.isPass = false,
      required this.textEditingController,
      required this.textInputType});

  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        fillColor: Colors.grey.shade900,
        filled: true,
      ),
      obscureText: isPass,
      keyboardType: textInputType,
    );
  }
}
