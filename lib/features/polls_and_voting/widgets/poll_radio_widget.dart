import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

class AppRadioGroup<T> extends StatelessWidget {
  final ValueNotifier<T?> controller;
  final bool showBorder;
  final Iterable<T> optionData;
  final Widget Function(BuildContext context, T data) optionBuilder;
  final void Function(T data)? onSelected;
  final double? borderRadius;
  final EdgeInsets? padding;
  final double? spacing;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? activeBackgroundColor;
  final Color? inactiveBackgroundColor;

  // Construct.
  const AppRadioGroup({
    super.key,
    required this.controller,
    required this.optionData,
    required this.optionBuilder,
    this.showBorder = true,
    this.onSelected,
    this.borderRadius,
    this.padding,
    this.spacing,
    this.activeColor,
    this.inactiveColor,
    this.activeBackgroundColor,
    this.inactiveBackgroundColor,
  });

  void _select(int index) {
    final value = optionData.elementAt(index);
    onSelected?.call(value);
    controller.value = value;
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, groupValue, _) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: spacing ?? 0,
        children: List.generate(
          optionData.length,
          (index) => InkWell(
            onTap: () => _select(index),
            borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
            child: Container(
              padding: padding ?? EdgeInsets.all(10.dg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
                border: showBorder
                    ? Border.all(
                        color: optionData.elementAt(index) == groupValue
                            ? activeColor ?? wayaTheme.colorScheme.customPrimary
                            : inactiveColor ??
                                wayaTheme.colorScheme.greyColor200,
                        width: 1.5,
                      )
                    : null,
                color: optionData.elementAt(index) == groupValue
                    ? activeBackgroundColor ??
                        wayaTheme.colorScheme.customPrimary
                    : inactiveBackgroundColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: spacing ?? 0,
                children: [
                  //? First, the option indicator.
                  Expanded(
                      child:
                          optionBuilder(context, optionData.elementAt(index))),

                  //? Second, the radio button.
                  Radio(
                    value: optionData.elementAt(index),
                    onChanged: (_) => _select(index),
                    groupValue: groupValue,
                    overlayColor: WidgetStateColor.resolveWith(
                      (states) {
                        //? If this is selected...
                        if (states.contains(WidgetState.selected)) {
                          return activeBackgroundColor ??
                              wayaTheme.colorScheme.customPrimary;
                        }

                        // Since it is not.
                        return inactiveBackgroundColor ??
                            wayaTheme.colorScheme.greyColor200;
                      },
                    ),
                    fillColor: WidgetStateColor.resolveWith(
                      (states) {
                        //? If this is selected...
                        if (states.contains(WidgetState.selected)) {
                          return activeColor ??
                              wayaTheme.colorScheme.customPrimary;
                        }

                        // Since it is not.
                        return inactiveColor ??
                            wayaTheme.colorScheme.greyColor200;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
