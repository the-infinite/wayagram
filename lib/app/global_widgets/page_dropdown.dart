import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import 'helpers/dark_mode_helper.dart';

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
    this.style,
    this.isCompulsory = false,
    this.isMultiple = false,
  }) : super(key: key);

  final bool isCompulsory;
  final bool isMultiple;
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
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(label.isNotEmpty)
                Text(
                  label,
                  style: AppTextStyle.bodyText2.copyWith(
                    fontWeight: FontWeight.w400,
                    color:getAppColor( const Color(0xFF828282)),
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
        AppDropdownButton(
          value: value,
          borderRadius: 10,
          hint: hint,
          borderSide: BorderSide(
            width: 1,
            color:getAppColor( const Color(0xFF828282)),
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
    this.isMultiple = false,
    this.value,
  }) : super(key: key);

  final bool isMultiple;
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
      isExpanded: true,
      hint: Center(child: Text(hint)),
      style: TextStyle(color: getAppColor(Colors.black)),
      alignment: AlignmentDirectional.center,
      decoration: InputDecoration(
          enabledBorder: outlineInputBorder,
          border: outlineInputBorder,
          contentPadding: padding
      ),
      icon:  Icon(Icons.arrow_drop_down,color: getAppColor(Colors.black),),
      dropdownColor: getAppColor(Colors.white),
    );
  }
}

