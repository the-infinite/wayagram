import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';

class WayaTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final int? line;
  final int? maxLength;
  final bool hasError;
  final String errorMessage;
  final EdgeInsets? padding;
  final String? label;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Color? fillColor;
  final bool showBorder, showFocusedBorder;
  final Color? borderColor;
  final Widget? prefixIcon;
  final Color? prefixIconColor;
  final Widget? suffixIcon;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final void Function(String?)? onSaved;
  final Iterable<String>? autofillHints;
  final TextStyle? hintStyle;
  final bool? obscureText;
  final VoidCallback? callback;
  final bool? isReadOnly;

  const WayaTextFormField(
      {Key? key,
      required this.controller,
      this.keyboardType = TextInputType.text,
      required this.hintText,
      this.line = 1,
      this.maxLength,
      this.hasError = false,
      this.errorMessage = "",
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
      this.isReadOnly = false})
      : super(key: key);

  @override
  State<WayaTextFormField> createState() => _AppFieldState();
}

class _AppFieldState extends State<WayaTextFormField> {
  late FocusNode _focusNode;
  late Color fillColor;
  late Color borderColor;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    fillColor = widget.fillColor ?? WayaColors.scaffoldColor;
    borderColor = WayaColors.greyColor300;

    _focusNode.addListener(() {
      setState(() {
        borderColor = _focusNode.hasFocus
            ? WayaColors.customPrimary
            : WayaColors.greyColor300;
        fillColor = _focusNode.hasFocus
            ? Colors.transparent
            : widget.fillColor ?? WayaColors.scaffoldColor;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context).colorScheme;
    Widget textFormField = TextFormField(
      readOnly: widget.isReadOnly ?? false,
      focusNode: _focusNode,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText ?? false,
      maxLines: widget.line ?? 1,
      maxLength: widget.maxLength,
      validator: widget.validator,
      autofillHints: widget.autofillHints,
      inputFormatters: widget.inputFormatters,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      onSaved: widget.onSaved,
      decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: widget.padding,
          fillColor: Colors.transparent,
          filled: true,
          prefixIcon: widget.prefixIcon,
          prefixIconColor: widget.prefixIconColor,
          hintText: widget.hintText,
          suffixIcon: widget.suffixIcon,
          hintStyle: WayaTextStyles.hintStyle,
          labelStyle: WayaTextStyles.labelSmall),
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
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        Container(
          height: 55,
          decoration: BoxDecoration(
            //color: fillColor,
            border: Border.all(
              color: widget.showBorder
                  ? (widget.borderColor ?? borderColor)
                  : WayaColors.scaffoldColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: textFormField,
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
