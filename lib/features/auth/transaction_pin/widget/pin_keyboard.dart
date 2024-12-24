import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';
import 'pin_keyboard_button.dart';
import 'package:gap/gap.dart';

class PinKeyboard extends StatelessWidget {
  final Function(String) onKeyTap;
  final VoidCallback onBackspace;
  final VoidCallback onSubmit;

  const PinKeyboard(
      {super.key,
      required this.onKeyTap,
      required this.onBackspace,
      required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 1; i <= 3; i++)
                PinKeyboardButton(
                  text: i.toString(),
                  onTap: () => onKeyTap(i.toString()),
                ),
            ],
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 4; i <= 6; i++)
                PinKeyboardButton(
                  text: i.toString(),
                  onTap: () => onKeyTap(i.toString()),
                ),
            ],
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 7; i <= 9; i++)
                PinKeyboardButton(
                  text: i.toString(),
                  onTap: () => onKeyTap(i.toString()),
                ),
            ],
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PinKeyboardButton(
                text: '',
                onTap: onBackspace,
                icon: Icon(
                  Icons.backspace,
                  size: 24,
                ),
              ),
              PinKeyboardButton(
                text: '0',
                onTap: () => onKeyTap('0'),
              ),
              PinKeyboardButton(
                text: '',
                onTap: onSubmit,
                icon: SvgPicture.asset('assets/icons/icon-right.svg'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
