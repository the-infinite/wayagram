import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

InputDecoration inputDecoration(
    {String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? labelText,
    bool isDense = true,
    Color fillColor = Colors.white,
    required ThemeData wayaTheme,
    Color? borderColor,
    TextStyle? hintStyle,
    double? heightPadding = 16.0,
    double radius = 4.0,
    bool addVPadding = false}) {
  return InputDecoration(
    alignLabelWithHint: true,
    hintStyle: hintStyle ?? const TextStyle(color: Colors.white),
    contentPadding: EdgeInsets.symmetric(
        horizontal: 16, vertical: addVPadding ? heightPadding ?? 12 : 0.0),
    filled: true,
    fillColor: fillColor,

    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    //  isDense: isDense,
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: borderColor ?? wayaTheme.colorScheme.greyColor300,
        )),
    disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: borderColor ?? wayaTheme.colorScheme.greyColor300,
        )),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: borderColor ?? wayaTheme.colorScheme.customPrimary,
        )),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(
          color: Colors.red,
        )),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(
          color: Colors.red,
        )),
    hintText: hintText,
    labelText: labelText,
  );
}
