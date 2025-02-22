import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class WayaBackButton extends StatelessWidget {
  final Function()? onTap;
  const WayaBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        const Gap(15),
        Container(
          decoration: BoxDecoration(
            color: wayaTheme.secondaryColor2,
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
            child: SvgPicture.asset('assets/icons/arrow-back.svg', fit: BoxFit.none),
          ),
        )
      ],
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
                          color: textColor ?? wayaTheme.colorScheme.scaffoldColor2,
                        ) ??
                        wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                          fontWeight: FontWeight.w600,
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
                              color: textColor ?? wayaTheme.colorScheme.scaffoldColor2,
                            ) ??
                            wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                              fontWeight: FontWeight.w600,
                              color: textColor ?? wayaTheme.colorScheme.scaffoldColor2,
                            ),
                      )),
      ),
    );
  }
}

class WayaActionNav extends StatelessWidget {
  final BuildContext context;
  final VoidCallback onTap;
  final Widget asset;
  final String text;
  final Color color;

  const WayaActionNav({
    super.key,
    required this.context,
    required this.onTap,
    required this.asset,
    required this.text,
    required this.color,
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
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}

class WayaTabButton extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback onTap;
  final double? width;
  final Widget? end;

  const WayaTabButton({
    super.key,
    required this.isSelected,
    required this.text,
    required this.onTap,
    this.width,
    this.end,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = context.width;
    final fontSize = screenWidth * 0.040;

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
  final VoidCallback onTap;
  final bool isSelected;
  final String text;
  final double fontSize;

  const WayaCheckButton({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.text,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // This is fine.
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //? First, the title.
            Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: fontSize,
              ),
            ),

            // Boundless space.
            const Spacer(),

            //? Finally, the toggling checkbox.
            Checkbox(
              value: isSelected,
              tristate: false,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              splashRadius: 12,
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
                color: isSelected ? theme.colorScheme.greyColor300 : theme.colorScheme.primary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100000),
              ),
              onChanged: (value) {
                if (value == true) onTap();
              },
            ),
          ],
        ),
      ),
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
  OverlayEntry? _current;

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
  final List<WayaExpandedTab> tabs;

  const WayaExpandedTabButton({
    super.key,
    required this.isSelected,
    required this.text,
    required this.tabs,
    required this.controller,
    this.width,
  });

  @override
  State<WayaExpandedTabButton> createState() => _WayaExpandedTabButtonState();
}

class _WayaExpandedTabButtonState extends State<WayaExpandedTabButton> {
  OverlayEntry? _entry;

  @override
  void dispose() {
    _entry?.dispose();
    super.dispose();
  }

  void _showActions(BuildContext context, ThemeData theme) async {
    //? If this is not undefined, leave.
    if (_entry?.mounted ?? false) {
      _entry?.remove();
      _entry = null;
      return;
    }

    // If this is defined, remove it.
    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size;
    final screenSize = MediaQuery.sizeOf(context);
    final fontSize = screenSize.width * 0.040;

    // If we do  not find the renderBox
    if (size == null || renderBox == null) {
      return;
    }

    // This is fine.
    final offset = renderBox.localToGlobal(Offset.zero);

    //? The distance between the top of the screen and the popup we want here.
    double top = offset.dy + size.height + 15;

    // This is fine.
    _entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          right: 15,
          top: top,
          child: Material(
            child: Container(
              width: screenSize.width * 0.50,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: theme.colorScheme.transparent,
                border: Border.all(width: 1, color: theme.colorScheme.greyColor300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.tabs
                    .map((tab) => WayaCheckButton(
                          onTap: () {
                            tab.onTap();
                            _entry?.remove();
                            _entry = null;
                          },
                          isSelected: tab.isSelected,
                          text: tab.text,
                          fontSize: fontSize,
                        ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );

    // This is fine.
    widget.controller._current = _entry;

    //* Now, insert this overlay here.
    Overlay.of(context).insert(_entry!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = context.width;
    final fontSize = screenWidth * 0.040;

    //?
    return PopScope(
      onPopInvokedWithResult: (doing, _) {
        if (doing) _entry?.remove();
      },
      child: Expanded(
        child: GestureDetector(
          onTap: () => _showActions(context, theme),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
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
                  child: Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: widget.isSelected ? theme.colorScheme.primary : theme.colorScheme.greyColor500,
                    ),
                  ),
                ),

                //? Put the thing here if needed.
                WayaAssets.icons.mChevronDown.svg(
                  color: widget.isSelected ? theme.colorScheme.primary : theme.colorScheme.greyColor500,
                  height: 18,
                  width: 18,
                ),

                //? Some space.
                const SizedBox.shrink(),
              ],
            ),
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
                fontSize: 13,
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
        verticalPadding: horizontalPadding,
        height: height,
        isDisabled: isDisabled,
        shape: shape,
        alignment: alignment,
      ),
    );
  }
}
