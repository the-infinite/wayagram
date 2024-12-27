import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

class WayaDp extends StatelessWidget {
  final double? radius;
  final Function()? onTap;
  const WayaDp({
    this.radius = 75,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: wayaTheme.colorScheme.greyColor200,
        child: Icon(
          Icons.person,
          color: wayaTheme.colorScheme.greyColor600,
        ),
      ),
    );
  }
}
