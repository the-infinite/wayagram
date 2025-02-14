import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
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
                  HapticFeedback.lightImpact();
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

  const WayaCheckButton({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // This is fine.
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //? First, the title.
            Text(
              text,
              style: theme.textTheme.bodyMedium,
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
