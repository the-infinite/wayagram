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

  /// Construct.
  const QuotationBidTimer({
    super.key,
    required this.request,
  });

  @override
  State<QuotationBidTimer> createState() => _QuotationBidTimerState();
}

class _QuotationBidTimerState extends State<QuotationBidTimer> {
  late final isClosed = [BuyRequestStatus.cancelled, BuyRequestStatus.closed].contains(widget.request.status);
  final timeNotifier = ValueNotifier(Duration.zero);
  Timer? timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

    //? The component itself.
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.primary50,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ValueListenableBuilder(
        valueListenable: timeNotifier,
        builder: (context, timeLeft, _) => Text(
          WayaDateHelper.convertDurationToCountdown(timeLeft, true),
          textAlign: TextAlign.center,
          style: wayaTheme.textTheme.descriptionStyle.copyWith(
            color: wayaTheme.colorScheme.customPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
