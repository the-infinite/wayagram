import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/helpers/date.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';

class QuotationBidTimer extends StatefulWidget {
  /// The quotation buy request for the timer we are displaying.
  final BuyRequestModel request;

  /// Is this bid timer one that exists inside another component, or does it
  /// stand alone?
  final bool isStandalone;

  /// Is the time in short format?
  final bool isShortTime;

  /// The size of font to use in the timer.
  final double? fontSize;

  /// The color of text to use in the timer.
  final Color? textColor;

  /// The color of the background to use.
  final Color? backgroundColor;

  /// Is this thing expanded in width, or does it only take up as much space as
  /// it should?
  final bool isExpanded;

  /// The font weight we are going to be using here on the text.
  final FontWeight? fontWeight;

  /// Construct.
  const QuotationBidTimer({
    super.key,
    required this.request,
    this.isExpanded = false,
    this.isStandalone = true,
    this.isShortTime = false,
    this.fontWeight,
    this.fontSize,
    this.textColor,
    this.backgroundColor,
  });

  @override
  State<QuotationBidTimer> createState() => _QuotationBidTimerState();
}

class _QuotationBidTimerState extends State<QuotationBidTimer> {
  late final isClosed = [BuyRequestStatus.cancelled, BuyRequestStatus.closed].contains(widget.request.status) ||
      widget.request.bidEnd.isBefore(DateTime.now());
  final timeNotifier = ValueNotifier(Duration.zero);
  Timer? timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //? If this is no longer open for any reason.
      if (isClosed) return;

      //? If the status is not started, then we need to calculate the time left
      //? until the bid starts.
      if (widget.request.status == BuyRequestStatus.notStarted) {
        timeNotifier.value = widget.request.bidStart.difference(DateTime.now()).abs();
      }

      //? If the status is active, then we need to calculate the time left until
      //? bidding ends.
      else {
        timeNotifier.value = widget.request.bidEnd.difference(DateTime.now()).abs();
      }

      //? Now, let the timer keep ticking.
      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        final eval = timeNotifier.value - const Duration(seconds: 1);

        //? Update this guy in the list.
        if (eval.isNegative) {
          return;
        }

        //? Update the time we think it would take.
        timeNotifier.value = eval;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timeNotifier.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final view = ValueListenableBuilder(
      valueListenable: timeNotifier,
      builder: (context, timeLeft, _) => Text(
        WayaDateHelper.convertDurationToCountdown(timeLeft, !widget.isShortTime),
        textAlign: TextAlign.center,
        style: wayaTheme.textTheme.descriptionStyle.copyWith(
          color:
              widget.textColor ?? (isClosed ? wayaTheme.colorScheme.greyColor400 : wayaTheme.colorScheme.customPrimary),
          fontSize: widget.fontSize ?? 16.sp,
          fontWeight: widget.fontWeight ?? FontWeight.w400,
        ),
      ),
    );

    //? If this is not a standalone component, then we need to return just the
    //? timer and nothing else.
    if (!widget.isStandalone) {
      return view;
    }

    //? The component itself.
    return Container(
      width: widget.isExpanded ? double.infinity : null,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      decoration: BoxDecoration(
        color:
            widget.backgroundColor ?? (isClosed ? wayaTheme.colorScheme.greyColor50 : wayaTheme.colorScheme.primary50),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: view,
    );
  }
}
