import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/theme.dart';

class PinKeyboardButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Widget? icon;

  const PinKeyboardButton(
      {super.key, this.text = '', required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: width * 0.22,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: WayaColors.greyColor300,
              width: 1,
            ),
          ),
          child: Center(
            child: icon ??
                Text(
                  text,
                  style: WayaTextStyles.titleMedium,
                ),
          ),
        ),
      ),
    );
  }
}
