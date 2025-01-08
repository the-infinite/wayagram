import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class WayaBackButton extends StatelessWidget {
  final Function()? onTap;
  const WayaBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        const Gap(15),
        Container(
          decoration: BoxDecoration(
            color: wayaTheme.secondaryColor2,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(7),
          child: InkWell(
            onTap: onTap ??
                () {
                  WayaNav.goBack();
                  HapticFeedback.lightImpact();
                },
            child: SvgPicture.asset('assets/icons/arrow-back.svg', fit: BoxFit.none),
          ),
        )
      ],
    );
  }
}

class WayaButton extends StatelessWidget {
  const WayaButton(
      {super.key,
      this.text = '',
      this.color,
      this.radius,
      this.border,
      this.textStyle,
      this.trailingIcon,
      this.isLoading = false,
      this.leadingIcon,
      required this.callback,
      this.textColor,
      this.centerWidget,
      this.horizontalPadding = 6,
      this.height = 48,
      this.isDisabled});
  final String text;
  final Color? color;
  final Widget? leadingIcon;
  final bool isLoading;
  final Widget? trailingIcon;

  final double? radius;
  final BoxBorder? border;
  final VoidCallback? callback;
  final Color? textColor;
  final TextStyle? textStyle;
  final Widget? centerWidget;
  final bool? isDisabled;
  final double horizontalPadding;
  final double height;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final isButtonDisabled = callback == null || isDisabled == true;

    return InkWell(
      splashFactory: NoSplash.splashFactory,
      onTap: isButtonDisabled || isLoading
          ? null
          : () async {
              FocusScope.of(context).unfocus();
              await HapticFeedback.heavyImpact();
              callback?.call();
            },
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: isButtonDisabled || isLoading
              ? wayaTheme.colorScheme.greyColor300
              : (color ?? wayaTheme.colorScheme.customPrimary),
          border: border,
          borderRadius: BorderRadius.circular(radius ?? 8),
        ),
        alignment: Alignment.center,
        child: leadingIcon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  leadingIcon ?? SizedBox.shrink(),
                  if (leadingIcon != null)
                    SizedBox(
                      width: 10,
                    ),
                  Text(text,
                      style: wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                          fontWeight: FontWeight.w600, color: textColor ?? wayaTheme.colorScheme.scaffoldColor2)),
                  Gap(10),
                  trailingIcon ?? SizedBox.shrink()
                ],
              )
            : centerWidget ??
                (isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: wayaTheme.colorScheme.white,
                        ),
                      )
                    : Text(text,
                        style: textStyle ??
                            wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                                fontWeight: FontWeight.w600,
                                color: textColor ?? wayaTheme.colorScheme.scaffoldColor2))),
      ),
    );
  }
}


class WayaTabButton extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback onTap;

  const WayaTabButton({
    super.key,
    required this.isSelected,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.greyColor300,
                width: isSelected ? 2 : 0.9,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.greyColor500,
            ),
          ),
        ),
      ),
    );
  }
}