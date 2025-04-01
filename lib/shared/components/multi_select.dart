import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/theme.dart';

class WayaMultipleSelectionButton<T> extends StatelessWidget {
  final String name;
  final ValueNotifier<T> controller;
  final T value;

  // This is fine.
  const WayaMultipleSelectionButton({
    super.key,
    required this.name,
    required this.controller,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => controller.value = value,
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, selectedValue, _) => Container(
            padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: selectedValue == value ? null : WayaColors.greyColor100,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //? First, the title.
                Text(
                  name,
                  style: WayaTextStyles.bodyMedium,
                ),

                // Boundless space.
                const Spacer(),

                //? Finally, the toggling checkbox.
                if (selectedValue == value)
                  WayaAssets.icons.notifFilterSelected.svg(
                    height: 20,
                    width: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
