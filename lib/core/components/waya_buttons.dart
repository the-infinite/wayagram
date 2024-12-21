import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
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
        child: SvgPicture.asset('assets/icons/arrow-back.svg', fit: BoxFit.none),
      ),
    );
  }
}
