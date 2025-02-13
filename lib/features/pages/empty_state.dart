import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

class PostEmptyState extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final String message;
 PostEmptyState({super.key, required this.onPressed, required this.buttonText, required this.message});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(30),
      child: EmptyState(
          hasButton: false,
          onTap: onPressed,
          buttontext: buttonText,
          buttonTrailingIcon: SvgPicture.asset(
            WayaAssets.icons.addEventIcon.path,
            colorFilter:
            ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
          ),
          assetImage: Image.asset(
            WayaAssets.images.emptyEvent.path,
            scale: 1.5,
          ),
          message: message),
    );
  }
}