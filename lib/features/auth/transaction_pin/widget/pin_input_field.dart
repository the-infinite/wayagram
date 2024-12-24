import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/theme.dart';

class PinInputField extends StatelessWidget {
  final String pin;
  final String label;

  const PinInputField({
    super.key,
    required this.pin,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: WayaTextStyles.labelMedium,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          
          children: List.generate(
            4,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: context.width * 0.17,
              height: 55,
              decoration: BoxDecoration(
                border: Border.all(color: WayaColors.greyColor300, width: 1),
                borderRadius: BorderRadius.circular(6),
              
              ),
              child:  Center(
                child: Text(
                  index < pin.length ? '*' : '',
                  style: TextStyle(
                   // color: index < pin.length ? Colors.white : Colors.transparent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}