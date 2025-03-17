import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';

class WayaTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String hintText;
  final int? line;
  final int? maxLines;
  final int? maxLength;
  final bool hasError;
  final String? helperText;
  final String errorMessage;
  final EdgeInsets? padding;
  final String? label;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Color? fillColor;
  final bool showBorder, showFocusedBorder;
  final Color? borderColor;
  final Widget? prefixIcon;
  final Color? suffixIconColor;
  final Color? prefixIconColor;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final void Function(String?)? onSaved;
  final Iterable<String>? autofillHints;
  final TextStyle? hintStyle, style;
  final bool? obscureText;
  final VoidCallback? callback;
  final bool isPassword;
  final VoidCallback? onTap;
  final bool? isReadOnly;
  final bool? isDense;

  const WayaTextFormField({
    super.key,
    this.controller,
    this.onChanged,
    this.suffixIconColor,
    this.keyboardType = TextInputType.text,
    required this.hintText,
    this.line = 1,
    this.maxLines,
    this.isDense,
    this.style ,
    this.maxLength,
    this.hasError = false,
    this.onTap,
    this.errorMessage = "",
    this.isPassword = false,
    this.padding,
    this.label,
    this.validator,
    this.inputFormatters,
    this.fillColor,
    this.showBorder = true,
    this.showFocusedBorder = true,
    this.borderColor = WayaColors.greyColor300,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.textInputAction,
    this.onSaved,
    this.autofillHints,
    this.hintStyle,
    this.obscureText,
    this.callback,
    this.helperText,
    this.isReadOnly = false,
  });

  @override
  State<WayaTextFormField> createState() => _AppFieldState();
}

class _AppFieldState extends State<WayaTextFormField> {
  late FocusNode _focusNode;
  late Color fillColor;
  late Color borderColor;
  bool isObscure = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    fillColor = widget.fillColor ?? WayaColors.scaffoldColor;
    borderColor = WayaColors.greyColor300;

    _focusNode.addListener(() {
      setState(() {
        borderColor = _focusNode.hasFocus
            ? Theme.of(context).colorScheme.customPrimary
            : Theme.of(context).colorScheme.greyColor300;
        fillColor = _focusNode.hasFocus
            ? Theme.of(context).colorScheme.customPrimary
            : widget.fillColor ?? Theme.of(context).colorScheme.scaffoldColor;
      });
    });
  }

  void toggleObscure() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context).colorScheme;
    Widget textFormField = TextFormField(
      readOnly: widget.isReadOnly ?? false,

      onTap: widget.onTap,
      onChanged: widget.onChanged,
      focusNode: _focusNode,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText ?? isObscure,
      maxLines: widget.maxLines ?? widget.line ?? 1,
      maxLength: widget.maxLength,
      minLines: widget.line ?? 1,
      // validator: widget.validator, // Commented out to handle validation manually
      autofillHints: widget.autofillHints,
      inputFormatters: widget.inputFormatters,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      onSaved: widget.onSaved,
      style: widget.style??WayaTextStyles.labelMedium,
      decoration: InputDecoration(
        isDense: widget.isDense,
        errorBorder: OutlineInputBorder(
          borderSide: widget.showBorder
              ? BorderSide(color: wayaTheme.error200, width: 1.w)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(8.r),
        ),
        border: OutlineInputBorder(
          borderSide: widget.showBorder
              ? BorderSide(
                  color: widget.borderColor ?? wayaTheme.greyColor300,
                  width: 1.w)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(8.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: widget.showBorder
              ? BorderSide(
                  color: widget.borderColor ?? wayaTheme.greyColor300,
                  width: 1.w)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(8.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: widget.showBorder
              ? BorderSide(color: wayaTheme.primary, width: 1.w)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(8.r),
        ),
        contentPadding: widget.padding ?? EdgeInsets.fromLTRB(12, 1, 12, 1),
        fillColor:
            widget.fillColor ?? Theme.of(context).colorScheme.transparent,
        filled: true,
        prefixIcon: widget.prefixIcon,
        prefixIconColor: widget.prefixIconColor,
        hintText: widget.hintText,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () => toggleObscure(),
                icon: Icon(
                  isObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: widget.suffixIconColor ?? wayaTheme.greyColor500,
                ),
              )
            : widget.suffixIcon,
        hintStyle: WayaTextStyles.hintStyle,
        labelStyle: WayaTextStyles.labelSmall,
      ),
    );

    if (widget.callback != null) {
      textFormField = GestureDetector(
        onTap: widget.callback,
        child: AbsorbPointer(
          child: textFormField,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              widget.label!,
              style: Theme.of(context).textTheme.bodyMedium?.wayaCopyWith(
                    fontSize: 14,
                    color: wayaTheme.greyColor900,
                  ),
            ),
          ),
        textFormField,
        if (widget.helperText != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              widget.helperText!,
              style: Theme.of(context).textTheme.bodyMedium?.wayaCopyWith(
                    fontSize: 13,
                    color: wayaTheme.greyColor400,
                  ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}

class WayaFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final int? line;
  final int? maxLength;
  final bool hasError;
  final String? helperText;
  final String errorMessage;
  final EdgeInsets? padding;
  final String? label;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Color? fillColor;
  final bool showBorder, showFocusedBorder;
  final Color? borderColor;
  final Widget? prefixIcon;
  final Color? suffixIconColor;
  final Color? prefixIconColor;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final void Function(String?)? onSaved;
  final Iterable<String>? autofillHints;
  final TextStyle? hintStyle;
  final bool? obscureText;
  final VoidCallback? callback;
  final bool isPassword;
  final VoidCallback? onTap;
  final bool? isReadOnly;

  const WayaFormField({
    super.key,
    required this.controller,
    this.onChanged,
    this.suffixIconColor,
    this.keyboardType = TextInputType.text,
    required this.hintText,
    this.line = 1,
    this.maxLength,
    this.hasError = false,
    this.onTap,
    this.errorMessage = "",
    this.isPassword = false,
    this.padding,
    this.label,
    this.validator,
    this.inputFormatters,
    this.fillColor,
    this.showBorder = true,
    this.showFocusedBorder = true,
    this.borderColor = WayaColors.greyColor300,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.textInputAction,
    this.onSaved,
    this.autofillHints,
    this.hintStyle,
    this.obscureText,
    this.callback,
    this.helperText,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context).colorScheme;

    return FormField<String>(
      validator: validator,
      builder: (formState) {
        bool isFocused = formState.hasError && controller.text.isEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WayaTextFormField(
              controller: controller,
              keyboardType: keyboardType,
              hintText: hintText,
              line: line,
              maxLength: maxLength,
              hasError: hasError,
              helperText: helperText,
              errorMessage: errorMessage,
              padding: padding,
              label: label,
              validator: validator,
              inputFormatters: inputFormatters,
              fillColor: fillColor,
              showBorder: showBorder,
              showFocusedBorder: showFocusedBorder,
              borderColor: isFocused ? wayaTheme.error : borderColor,
              prefixIcon: prefixIcon,
              prefixIconColor: prefixIconColor,
              suffixIcon: suffixIcon,
              suffixIconColor: suffixIconColor,
              onChanged: onChanged,
              onEditingComplete: onEditingComplete,
              onFieldSubmitted: onFieldSubmitted,
              textInputAction: textInputAction,
              onSaved: onSaved,
              autofillHints: autofillHints,
              hintStyle: hintStyle,
              obscureText: obscureText,
              callback: callback,
              isPassword: isPassword,
              onTap: onTap,
              isReadOnly: isReadOnly,
            ),
            if (formState.hasError && controller.text.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  formState.errorText!,
                  style: TextStyle(
                    color: wayaTheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
