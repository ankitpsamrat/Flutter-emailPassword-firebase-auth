import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  const TextInputField({
    Key? key,
    required this.inputController,
    required this.formValidator,
    required this.onSaved,
    required this.textInputAction,
    required this.icon,
    required this.textName,
    this.toHide = false,
  }) : super(key: key);

  final TextEditingController inputController;
  final FormFieldValidator formValidator;
  final FormFieldSetter onSaved;
  final TextInputAction textInputAction;
  final IconData icon;
  final String textName;
  final bool toHide;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      controller: inputController,
      obscureText: toHide,
      validator: formValidator,
      onSaved: onSaved,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: textName,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
