import 'package:chatapp_realtime_firebase/consts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({super.key, required this.hintText, required this.height, required this.validationRegExp});
  final String hintText;
  final double height;
  final RegExp validationRegExp;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        validator: (String? value) {
          if (value != null && validationRegExp.hasMatch(value)) {
            return null;
          }
          return 'Enter a valid ${hintText.toLowerCase()}';
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
      ),
    );
  }
}
