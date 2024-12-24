import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class WayaBackButton extends StatelessWidget {
  final Function()? onTap;
  const WayaBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: wayaTheme.secondaryColor2,
        shape: BoxShape.circle,
      ),
      margin: EdgeInsets.all(7),
      child: InkWell(
        onTap: onTap ??
            () {
              WayaNav.goBack();
              HapticFeedback.lightImpact();
            },
        child:
            SvgPicture.asset('assets/icons/arrow-back.svg', fit: BoxFit.none),
      ),
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
      required this.callback,
      this.textColor,
      this.centerWidget,
      this.horizontalPadding = 6,
      this.height = 55,
      this.isDisabled});
  final String text;
  final Color? color;
  final double? radius;
  final BoxBorder? border;
  final VoidCallback? callback;
  final Color? textColor;
  final Widget? centerWidget;
  final bool? isDisabled;
  final double horizontalPadding;
  final double height;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context).colorScheme;
    final isButtonDisabled = callback == null || isDisabled == true;

    return InkWell(
      splashFactory: NoSplash.splashFactory,
      onTap: isButtonDisabled
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
          color: isButtonDisabled
              ? wayaTheme.greyColor300
              : (color ?? wayaTheme.customPrimary),
          border: border,
          borderRadius: BorderRadius.circular(radius ?? 8),
        ),
        alignment: Alignment.center,
        child: centerWidget ??
            Text(text,
                style: TextStyle().wayaCopyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: WayaColors.scaffoldColor,
                )),
      ),
    );
  }
}
