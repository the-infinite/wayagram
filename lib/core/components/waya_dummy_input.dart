import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enum for Text Field
enum TextFieldType {
  email,
  emailEnhanced,
  password,
  passwordEnhanced,
  name,
  multiline,
  other,
  phone,
  url,
  number,
  username,
}

/// Default Text Form Field
///
/// ChatGPT Parameters:
/// - `enableChatGPT`: A flag to enable or disable the ChatGPT feature.
/// - `promptFieldInputDecoration`: Custom input decoration for the prompt field in the chatGpt widget.
/// - `suffixChatGPTIcon`: An optional widget to be displayed as a suffix icon in the ChatGPT input field.
/// - `loadingChatGPT`: An optional widget to be displayed as a loading indicator during ChatGPT response generation.
/// - `shortReply`: If true, it will generate a 1-2 line reply. Default is false.
/// - `testWithoutKey`: If true, it will provide a static test response without using the actual API key. Default is false.
///
class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextFieldType textFieldType;

  final InputDecoration? decoration;
  final FocusNode? focus;
  final FormFieldValidator<String>? validator;
  final bool isValidationRequired;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final FocusNode? nextFocus;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final int? maxLines;
  final int? minLines;
  final bool? enabled;
  final bool autoFocus;
  final bool readOnly;
  final bool? enableSuggestions;
  final int? maxLength;
  final Color? cursorColor;
  final Widget? suffix;
  final Color? suffixIconColor;
  final TextInputType? keyboardType;
  final Iterable<String>? autoFillHints;
  final EdgeInsets? scrollPadding;
  final double? cursorWidth;
  final double? cursorHeight;
  final Function()? onTap;
  final InputCounterWidgetBuilder? buildCounter;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlignVertical? textAlignVertical;
  final bool expands;
  final bool? showCursor;
  final TextSelectionControls? selectionControls;
  final StrutStyle? strutStyle;
  final String obscuringCharacter;
  final String? initialValue;
  final Brightness? keyboardAppearance;
  final Widget? suffixPasswordVisibleWidget;
  final Widget? suffixPasswordInvisibleWidget;
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  final String? errorThisFieldRequired;
  final String? errorInvalidEmail;
  final String? errorMinimumPasswordLength;
  final String? errorInvalidURL;
  final String? errorInvalidUsername;

  final String? title;
  final TextStyle? titleTextStyle;
  final int spacingBetweenTitleAndTextFormField;

  //ChatGPT Params
  final bool enableChatGPT;
  final Widget? suffixChatGPTIcon;
  final Widget? loaderWidgetForChatGPT;
  final InputDecoration? promptFieldInputDecorationChatGPT;
  final bool shortReplyChatGPT;
  final bool testWithoutKeyChatGPT;

  @Deprecated('Use TextFieldType.PASSWORD instead')
  final bool? isPassword;

  const AppTextField({
    this.controller,
    required this.textFieldType,
    this.decoration,
    this.focus,
    this.validator,
    this.isPassword,
    this.buildCounter,
    this.isValidationRequired = true,
    this.textCapitalization,
    this.textInputAction,
    this.onFieldSubmitted,
    this.nextFocus,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.minLines,
    this.enabled,
    this.onChanged,
    this.cursorColor,
    this.suffix,
    this.suffixIconColor,
    this.enableSuggestions,
    this.autoFocus = false,
    this.readOnly = false,
    this.maxLength,
    this.keyboardType,
    this.autoFillHints,
    this.scrollPadding,
    this.onTap,
    this.cursorWidth,
    this.cursorHeight,
    this.inputFormatters,
    this.errorThisFieldRequired,
    this.errorInvalidEmail,
    this.errorMinimumPasswordLength,
    this.errorInvalidURL,
    this.errorInvalidUsername,
    this.textAlignVertical,
    this.expands = false,
    this.showCursor,
    this.selectionControls,
    this.strutStyle,
    this.obscuringCharacter = '•',
    this.initialValue,
    this.keyboardAppearance,
    this.suffixPasswordVisibleWidget,
    this.suffixPasswordInvisibleWidget,
    this.contextMenuBuilder,
    this.title,
    this.titleTextStyle,
    this.spacingBetweenTitleAndTextFormField = 4,

    //ChatGpt Params
    this.enableChatGPT = false,
    this.loaderWidgetForChatGPT,
    this.suffixChatGPTIcon,
    this.promptFieldInputDecorationChatGPT,
    this.shortReplyChatGPT = false,
    this.testWithoutKeyChatGPT = false,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool isPasswordVisible = false;
  List<String> recentChat = [];

  TextInputAction? applyTextInputAction() {
    if (widget.textInputAction != null) {
      return widget.textInputAction;
    } else if (widget.textFieldType == TextFieldType.multiline) {
      return TextInputAction.newline;
    } else if (widget.nextFocus != null) {
      return TextInputAction.next;
    } else {
      return TextInputAction.done;
    }
  }

  TextInputType? applyTextInputType() {
    if (widget.keyboardType != null) {
      return widget.keyboardType;
    } else if (widget.textFieldType == TextFieldType.email ||
        widget.textFieldType == TextFieldType.emailEnhanced) {
      return TextInputType.emailAddress;
    } else if (widget.textFieldType == TextFieldType.multiline) {
      return TextInputType.multiline;
    } else if (widget.textFieldType == TextFieldType.password) {
      return TextInputType.phone;
    } else if (widget.textFieldType == TextFieldType.phone ||
        widget.textFieldType == TextFieldType.number) {
      return TextInputType.number;
    } else if (widget.textFieldType == TextFieldType.url) {
      return TextInputType.url;
    } else {
      return TextInputType.text;
    }
  }

  void onPasswordVisibilityChange(bool val) {
    isPasswordVisible = val;
    setState(() {});
  }

  Widget? suffixIcon() {
    if (widget.textFieldType == TextFieldType.password ||
        widget.textFieldType == TextFieldType.passwordEnhanced) {
      if (widget.suffix != null) {
        return widget.suffix;
      } else {
        if (isPasswordVisible) {
          if (widget.suffixPasswordVisibleWidget != null) {
            return widget.suffixPasswordVisibleWidget;
          } else {
            return Icon(
              Icons.visibility,
              color:
                  widget.suffixIconColor ?? Theme.of(context).iconTheme.color,
            );
          }
        } else {
          if (widget.suffixPasswordInvisibleWidget != null) {
            return widget.suffixPasswordInvisibleWidget;
          } else {
            return Icon(
              Icons.visibility_off,
              color:
                  widget.suffixIconColor ?? Theme.of(context).iconTheme.color,
            );
          }
        }
      }
    } else {
      return widget.suffix;
    }
  }

  Iterable<String>? applyAutofillHints() {
    if (widget.textFieldType == TextFieldType.email ||
        widget.textFieldType == TextFieldType.emailEnhanced) {
      return [AutofillHints.email];
    } else if (widget.textFieldType == TextFieldType.password) {
      return [AutofillHints.password];
    }
    return null;
  }

  Widget textFormFieldWidget() {
    return TextFormField(
      controller: widget.controller,
      obscureText:
          widget.textFieldType == TextFieldType.password && !isPasswordVisible,
      textInputAction: applyTextInputAction(),
      onFieldSubmitted: (s) {
        if (widget.nextFocus != null) {
          FocusScope.of(context).requestFocus(widget.nextFocus);
        }

        if (widget.onFieldSubmitted != null) widget.onFieldSubmitted!.call(s);
      },
      keyboardType: applyTextInputType(),
      decoration: widget.decoration != null
          ? (widget.decoration!.copyWith(
              suffixIcon: suffixIcon(),
            ))
          : InputDecoration(counterText: ""),
      focusNode: widget.focus,
      style: widget.textStyle,
      textAlign: widget.textAlign,
      autofocus: widget.autoFocus,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      cursorColor: widget.cursorColor ??
          Theme.of(context).textSelectionTheme.cursorColor,
      readOnly: widget.readOnly,
      maxLength: widget.maxLength,
      autofillHints: widget.autoFillHints ?? applyAutofillHints(),
      scrollPadding: widget.scrollPadding ?? EdgeInsets.all(20),
      cursorHeight: widget.cursorHeight,
      onTap: widget.onTap,
      buildCounter: widget.buildCounter,
      scrollPhysics: BouncingScrollPhysics(),
      enableInteractiveSelection: true,
      inputFormatters: widget.inputFormatters,
      textAlignVertical: widget.textAlignVertical,
      expands: widget.expands,
      showCursor: widget.showCursor,
      selectionControls:
          widget.selectionControls ?? MaterialTextSelectionControls(),
      strutStyle: widget.strutStyle,
      obscuringCharacter: widget.obscuringCharacter,
      initialValue: widget.initialValue,
      keyboardAppearance: widget.keyboardAppearance,
      contextMenuBuilder: widget.contextMenuBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return textFormFieldWidget();
  }
}
