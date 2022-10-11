import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';
import 'app_input.dart';

class PageInput extends StatelessWidget {
  const PageInput({
    Key? key,
    required this.hint,
    required this.label,
    this.prefix,
    this.suffix,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.autovalidateMode,
    this.readOnly = false,
    this.isCompulsory = false
  }) : super(key: key);

  final String hint;
  final String label;
  final AutovalidateMode? autovalidateMode;
  final Widget? prefix;
  final TextInputType keyboardType;
  final Widget? suffix;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final bool isCompulsory;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: AppTextStyle.bodyText2.copyWith(
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF828282),
                ),
              ),
              if(isCompulsory)
                const SizedBox(width: 5),
              if(isCompulsory)
                Text(
                "*",
                style: AppTextStyle.bodyText2.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        AppInput(
          hintText: hint,
          keyboardType: keyboardType,
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          autovalidateMode: autovalidateMode,
          //  contentPadding: const EdgeInsets.only(top: 13),
          readOnly: readOnly,
          prefexIcon: prefix,
          suffixIcon: suffix,
        ),
      ],
    );
  }
}
