import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class PageDropButton extends StatelessWidget {
  const PageDropButton({
    Key? key,
    required this.label,
    required this.hint,
    this.padding = const EdgeInsets.fromLTRB(5, 0, 0, 0),
    this.validator,
    this.items,
    this.value,
    this.onChanged,
    this.bckgrndColor,
    this.style
  }) : super(key: key);

  final TextStyle? style;
  final String label;
  final String hint;
  final dynamic value;
  final EdgeInsets padding;
  final String? Function(dynamic)? validator;
  final Color? bckgrndColor;
  final List<DropdownMenuItem<dynamic>>? items;
  final Function(dynamic)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(label,style: style),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )
            : const SizedBox.shrink(),
        AppDropdownButton(
          value: value,
          borderRadius: 10,
          hint: hint,
          borderSide: const BorderSide(
            width: 1,
            color: Color(0xFF828282),
          ),
          validator: validator,
          padding: padding,
          onChanged: onChanged,
          items: items,
        ),
      ],
    );
  }
}

class AppDropdownButton<T> extends StatelessWidget {
  const AppDropdownButton({
    Key? key,
    this.borderRadius = 8,
    this.borderSide = BorderSide.none,
    this.padding = const EdgeInsets.fromLTRB(25, 20, 19, 20),
    required this.hint,
    this.validator,
    this.items,
    this.onChanged,
    this.value,
  }) : super(key: key);

  final EdgeInsets padding;
  final double borderRadius;
  final String hint;
  final BorderSide borderSide;
  final String? Function(T?)? validator;

  final List<DropdownMenuItem<T>>? items;
  final Function(T?)? onChanged;
  final T? value;
  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: borderSide,
    );

    return DropdownButtonFormField<T>(
      onChanged: onChanged,
      value: value,
      validator: validator,
      items: items,
      hint: Center(child: Text(hint)),
      style: const TextStyle(color: Colors.black),
      alignment: AlignmentDirectional.center,
      decoration: InputDecoration(
          enabledBorder: outlineInputBorder,
          border: outlineInputBorder,
          contentPadding: padding
      ),
      icon:  const Icon(Icons.arrow_drop_down,color: Colors.black,),
      dropdownColor: Colors.white,
    );
  }
}

