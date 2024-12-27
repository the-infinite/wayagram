import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';

class PriceRangeInput extends StatelessWidget {
  final String minPrice;
  final String maxPrice;
  final Function(String, String) onPriceRangeChanged;

  const PriceRangeInput({
    super.key,
    required this.minPrice,
    required this.maxPrice,
    required this.onPriceRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Gap(12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                hintText: 'Min',
                value: minPrice,
                context: context,
                onChanged: (value) => onPriceRangeChanged(value, maxPrice),
              ),
            ),
            const Gap(16),
            Expanded(
              child: _buildTextField(
                hintText: 'Max',
                value: maxPrice,
                context: context,
                onChanged: (value) => onPriceRangeChanged(minPrice, value),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(
      {required String hintText,
      required String value,
      required ValueChanged<String> onChanged,
      required BuildContext context}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.hintStyle,
        suffixText: 'NGN',
        fillColor: Theme.of(context).colorScheme.transparent,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.greyColor300, width: 1.w)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.greyColor300, width: 1.w),
          borderRadius: BorderRadius.circular(10.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 1.w),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      onChanged: onChanged,
      keyboardType: TextInputType.number,
    );
  }
}
