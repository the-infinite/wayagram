// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/helpers/value.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class WayaBackButton extends StatelessWidget {
  final Function()? onTap;
  final Color? buttonBackgroundColor;
  final Color? arrowColor;
  const WayaBackButton({super.key, this.onTap, this.buttonBackgroundColor, this.arrowColor});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        const Gap(15),
        Container(
          decoration: BoxDecoration(
            color: buttonBackgroundColor ?? wayaTheme.secondaryColor2,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(7),
          child: InkWell(
            onTap: onTap ??
                () {
                  WayaNav.goBack();
                  try {
                    HapticFeedback.lightImpact();
                  } catch (_) {}
                },
            child: SvgPicture.asset('assets/icons/arrow-back.svg', color: arrowColor, fit: BoxFit.none),
          ),
        )
      ],
    );
  }
}

class WayaStatefulButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback callback;
  final String text;

  // Construct.
  const WayaStatefulButton({super.key, required this.isSelected, required this.callback, required this.text});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return WayaButton(
      callback: callback,
      border: Border.all(color: isSelected ? wayaTheme.colorScheme.customPrimary : wayaTheme.colorScheme.greyColor300),
      horizontalPadding: 8.w,
      color: isSelected ? wayaTheme.colorScheme.primaryBrown50 : wayaTheme.colorScheme.transparent,
      radius: 10.r,
      height: 40.h,
      text: text,
      textColor: WayaTextStyles.hintStyle.color,
      textStyle: WayaTextStyles.hintStyle,
    );
  }
}

class WayaButton extends StatelessWidget {
  const WayaButton({
    super.key,
    this.text = '',
    this.color,
    this.radius,
    this.border,
    this.textStyle,
    this.trailingIcon,
    this.isLoading = false,
    this.leadingIcon,
    required this.callback,
    this.textColor,
    this.centerWidget,
    this.horizontalPadding = 6,
    this.verticalPadding = 0,
    this.height = 48,
    this.isDisabled,
    this.fontSize,
    this.shape = BoxShape.rectangle,
    this.alignment = Alignment.center,
  });
  final String text;
  final Color? color;
  final Widget? leadingIcon;
  final bool isLoading;
  final BoxShape shape;
  final Widget? trailingIcon;
  final Alignment alignment;
  final double? radius;
  final BoxBorder? border;
  final VoidCallback? callback;
  final Color? textColor;
  final TextStyle? textStyle;
  final Widget? centerWidget;
  final bool? isDisabled;
  final double horizontalPadding;
  final double verticalPadding;
  final double? height;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final isButtonDisabled = callback == null || isDisabled == true;

    return InkWell(
      splashFactory: NoSplash.splashFactory,
      onTap: isButtonDisabled || isLoading
          ? null
          : () async {
              callback?.call();
              try {
                FocusScope.of(context).unfocus();
                await HapticFeedback.heavyImpact();
              } catch (_) {}
            },
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        decoration: BoxDecoration(
          shape: shape,
          color: isButtonDisabled || isLoading
              ? wayaTheme.colorScheme.greyColor300
              : (color ?? wayaTheme.colorScheme.customPrimary),
          border: border,
          borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(radius ?? 8) : null,
        ),
        alignment: alignment,
        child: leadingIcon != null
            ? Row(
                mainAxisAlignment: alignment == Alignment.center ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  leadingIcon ?? SizedBox.shrink(),
                  if (leadingIcon != null)
                    SizedBox(
                      width: 10,
                    ),
                  Text(
                    text,
                    style: textStyle?.copyWith(
                          fontSize: fontSize,
                          color: textColor ?? wayaTheme.colorScheme.scaffoldColor2,
                        ) ??
                        wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: fontSize,
                          color: textColor ?? wayaTheme.colorScheme.scaffoldColor2,
                        ),
                  ),
                  Gap(10),
                  trailingIcon ?? SizedBox.shrink()
                ],
              )
            : centerWidget ??
                (isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: wayaTheme.colorScheme.white,
                        ),
                      )
                    : Text(
                        text,
                        style: textStyle?.copyWith(
                              fontSize: fontSize,
                              color: textColor ?? wayaTheme.colorScheme.scaffoldColor2,
                            ) ??
                            wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: fontSize,
                              color: textColor ?? wayaTheme.colorScheme.scaffoldColor2,
                            ),
                      )),
      ),
    );
  }
}

class WayaActionNav extends StatelessWidget {
  final BuildContext context;
  final VoidCallback? onTap;
  final Widget asset;
  final String text;
  final Color color;

  const WayaActionNav({
    super.key,
    required this.context,
    required this.asset,
    required this.text,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          asset,
          const Gap(4),
          Text(
            text,
            style: wayaTheme.textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
          )
        ],
      ),
    );
  }
}

class WayaTabButton extends StatelessWidget {
  final bool isSelected;
  final bool isLongerTab;
  final int? count;
  final String text;
  final VoidCallback onTap;

  final double? width;
  final Widget? end;

  const WayaTabButton({
    super.key,
    required this.isSelected,
    required this.text,
    required this.onTap,
    this.isLongerTab = false,
    this.count,
    this.width,
    this.end,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = context.width;
    double fontSize = 0;
    if (isLongerTab) {
      fontSize = screenWidth * 0.030;
    } else {
      fontSize = screenWidth * 0.038;
    }

    //?
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.greyColor300,
                width: isSelected ? 2 : 0.9,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            spacing: 5,
            children: [
              //? Fill available space.
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.greyColor500,
                  ),
                ),
              ),

              //? Finally, the other thing.
              if (count != null)
                ClipPath(
                  clipper: ShapeBorderClipper(
                    shape: StadiumBorder(),
                  ),
                  child: ColoredBox(
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.scaffoldColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        WayaValueHelper.formatNumber(count!),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isSelected ? theme.colorScheme.white : theme.colorScheme.greyColor500,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                ),

              //? Put the thing here if needed.
              if (end != null) end!,
            ],
          ),
        ),
      ),
    );
  }
}

class WayaCheckButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isSelected;
  final String text;
  final double fontSize;
  final bool hasBackground;
  final bool isExpanded;
  final bool isClickable;
  final double? verticalPadding;
  final double? horizontalPadding;

  const WayaCheckButton({
    super.key,
    required this.isSelected,
    required this.text,
    this.verticalPadding,
    this.horizontalPadding,
    this.onTap,
    this.isClickable = true,
    this.isExpanded = true,
    this.fontSize = 16,
    this.hasBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // The real widget.
    final contents = Container(
      padding: EdgeInsets.only(
        top: verticalPadding ?? 7.h,
        bottom: verticalPadding ?? 7.h,
        left: horizontalPadding ?? 15.w,
        // right: horizontalPadding ?? 0,
      ),
      decoration: hasBackground
          ? BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.customPrimary.withAlpha(30)
                  : theme.colorScheme.greyColor400.withAlpha(30),
              borderRadius: BorderRadius.circular(2000.r),
              border: Border.all(
                color: isSelected ? theme.colorScheme.customPrimary : theme.colorScheme.greyColor300,
              ),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
        children: [
          //? First, the title.
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: fontSize,
              color: hasBackground
                  ? isSelected
                      ? theme.colorScheme.customPrimary
                      : theme.colorScheme.greyColor400
                  : null,
            ),
          ),

          // Boundless space.
          if (isExpanded) const Spacer() else SizedBox(width: 10.w),

          //? Finally, the toggling checkbox.
          Checkbox(
            value: isSelected,
            tristate: false,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            splashRadius: hasBackground ? 1 : 12,
            fillColor: WidgetStateColor.resolveWith(
              (states) {
                //? If this is selected...
                if (states.contains(WidgetState.selected)) {
                  return theme.colorScheme.primary;
                }

                // Since it is not.
                return Colors.transparent;
              },
            ),
            side: BorderSide(
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.greyColor300,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100000),
            ),
            onChanged: (value) {
              if (value == true) onTap?.call();
            },
          ),
        ],
      ),
    );

    //? If this is not clickable..
    if (!isClickable) {
      return contents;
    }

    // This is fine.
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: contents,
    );
  }
}

class WayaExpandedTab {
  final bool isSelected;
  final String text;
  final VoidCallback onTap;

  const WayaExpandedTab({
    required this.isSelected,
    required this.text,
    required this.onTap,
  });
}

class ExpandedTabController {
  final _selected = ValueNotifier("");
  WayaExpandedTabButton? _widget;
  OverlayEntry? _current;

  void dispose() {
    close();
    try {
      _selected.dispose();
    } catch (_) {}
  }

  void away() {
    _selected.value = _widget?.text ?? "";
  }

  void close() {
    try {
      _current?.remove();
    } catch (_) {}
  }
}

class WayaExpandedTabButton extends StatefulWidget {
  final bool isSelected;
  final String text;
  final ExpandedTabController controller;
  final double? width;
  final double? verticalPadding;
  final double? horizontalPadding;
  final Offset? offset;
  final List<WayaExpandedTab> tabs;

  //? This is fine.
  WayaExpandedTabButton({
    super.key,
    required this.isSelected,
    required this.text,
    required this.tabs,
    required this.controller,
    this.offset,
    this.verticalPadding,
    this.horizontalPadding,
    this.width,
  }) {
    controller._widget = this;

    //? Only when this is empty.
    if (controller._selected.value.isEmpty) {
      controller._selected.value = text;
    }
  }

  @override
  State<WayaExpandedTabButton> createState() => _WayaExpandedTabButtonState();
}

class _WayaExpandedTabButtonState extends State<WayaExpandedTabButton> {
  void _do(WayaExpandedTab tab) {
    widget.controller._selected.value = tab.text;
    tab.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = context.width;
    final fontSize = screenWidth * 0.040;

    //?
    return Expanded(
      child: PopupMenuButton(
        position: PopupMenuPosition.under,
        offset: widget.offset ?? const Offset(0, 5),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: theme.colorScheme.greyColor300, width: 1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        onSelected: (value) => widget.controller._selected.value = value,
        itemBuilder: (context) => List.generate(
          widget.tabs.length,
          (index) {
            final tab = widget.tabs[index];

            //? This is fine.
            return PopupMenuItem(
              value: tab.text,
              onTap: () => _do(tab),
              child: WayaCheckButton(
                verticalPadding: widget.verticalPadding,
                horizontalPadding: widget.horizontalPadding,
                isSelected: tab.isSelected,
                text: tab.text,
                fontSize: fontSize,
                isClickable: false,
              ),
            );
          },
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14.5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: widget.isSelected ? theme.colorScheme.primary : theme.colorScheme.greyColor300,
                width: widget.isSelected ? 2 : 0.9,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            spacing: 5,
            children: [
              //? Fill available space.
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: widget.controller._selected,
                  builder: (context, text, _) => Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: widget.isSelected ? theme.colorScheme.primary : theme.colorScheme.greyColor500,
                    ),
                  ),
                ),
              ),

              //? Put the thing here if needed.
              WayaAssets.icons.mChevronDown.svg(
                colorFilter: ColorFilter.mode(
                  widget.isSelected ? theme.colorScheme.primary : theme.colorScheme.greyColor500,
                  BlendMode.srcIn,
                ),
                height: 16,
                width: 16,
              ),

              //? Some space.
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class WayaActionButton extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final double iconSize;
  final double spacing;
  final Color? iconBackground;
  final FutureOr<void> Function() callback;

  // Construct.
  const WayaActionButton({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.callback,
    this.iconSize = 24,
    this.spacing = 2,
    this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = iconBackground ?? theme.colorScheme.primary.withAlpha(30);

    // This is fine.
    return InkWell(
      onTap: callback,
      borderRadius: BorderRadius.circular(10),
      splashColor: accentColor,
      focusColor: accentColor,
      highlightColor: accentColor,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: spacing,
          children: [
            //* First, the icon for this attachment action button.
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor,
              ),
              child: SvgPicture.asset(
                icon,
                height: iconSize,
                width: iconSize,
              ),
            ),

            //* Second, the title of this section.
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyBold,
            ),

            //* The body of this action button.
            Text(
              description,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: theme.textTheme.descriptionStyle.copyWith(
                fontSize: 13.sp,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WayaProgressiveButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Widget? leadingIcon;
  final BoxShape shape;
  final Widget? trailingIcon;
  final Alignment alignment;
  final double? radius;
  final BoxBorder? border;
  final Future<void> Function() callback;
  final Color? textColor;
  final TextStyle? textStyle;
  final Widget? centerWidget;
  final bool? isDisabled;
  final double horizontalPadding;
  final double verticalPadding;
  final double? height;
  final ValueNotifier<bool> notifier;

  const WayaProgressiveButton({
    super.key,
    required this.callback,
    required this.notifier,
    this.text = '',
    this.color,
    this.radius,
    this.border,
    this.textStyle,
    this.trailingIcon,
    this.leadingIcon,
    this.textColor,
    this.centerWidget,
    this.horizontalPadding = 6,
    this.verticalPadding = 0,
    this.height = 48,
    this.isDisabled,
    this.shape = BoxShape.rectangle,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (controller, isLoading, _) => WayaButton(
        callback: isLoading
            ? null
            : () async {
                notifier.value = true;
                await callback();
                try {
                  notifier.value = false;
                } catch (_) {}
              },
        text: text,
        color: color,
        radius: radius,
        border: border,
        textStyle: textStyle,
        trailingIcon: trailingIcon,
        isLoading: isLoading,
        leadingIcon: leadingIcon,
        textColor: textColor,
        centerWidget: centerWidget,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        height: height,
        isDisabled: isDisabled,
        shape: shape,
        alignment: alignment,
      ),
    );
  }
}
