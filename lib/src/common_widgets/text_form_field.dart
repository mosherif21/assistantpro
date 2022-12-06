import 'package:assistantpro/src/constants/app_init_constants.dart';
import 'package:flutter/material.dart';

class TextFormFieldRegular extends StatelessWidget {
  const TextFormFieldRegular({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.prefixIconData,
    required this.textController,
    required this.inputType,
  }) : super(key: key);
  final String labelText;
  final String hintText;
  final IconData prefixIconData;
  final TextEditingController textController;
  final InputType inputType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      keyboardType: inputType == InputType.email
          ? TextInputType.emailAddress
          : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefixIconData,
        ),
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
