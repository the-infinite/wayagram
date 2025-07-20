import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

class ConfirmQuotationOrder extends StatefulWidget {
  final BuyRequestModel request;
  final QuotationBidModel bid;
  final BidOrderModel order;
  final CachedUserDataTuple user;
  final QuotationsNotifier notifier;

  // Construct.
  const ConfirmQuotationOrder({
    super.key,
    required this.request,
    required this.bid,
    required this.order,
    required this.user,
    required this.notifier,
  });

  @override
  State<ConfirmQuotationOrder> createState() => _ConfirmQuotationOrderState();
}

class _ConfirmQuotationOrderState extends State<ConfirmQuotationOrder> {
  String raw = "";
  String? errorMessage;

  void updateAmount(String value) {
    if (raw.length == 10) return;

    setState(() {
      raw = "$raw$value";

      // Clear error when user starts typing again
      errorMessage = null;
    });
  }

  void deleteAmount() {
    if (raw.isEmpty) return;

    //? This is fine.
    setState(() {
      raw = raw.substring(0, raw.length - 1);
    });
  }

  void _handleSubmit() async {
    // Validate amount
    if (raw.isEmpty || raw.length < 10) {
      setState(() {
        errorMessage = "Please enter a valid 10-digit code";
      });
      return;
    }

    //? Now, let us move forward with confirming the order.
    final result = await widget.notifier.completeOrder(widget.order.id, raw);

    //? If this was done well...
    if (result) {
      WayaSnackBar.showToast("This order has been completed successfully",
          showSuccess: true);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    //? Retrieve the building blocks.
    final wayaTheme = Theme.of(context);

    //? Build the screen.
    return WayaScaffold(
      isLoading: false,
      isScrollable: false,
      title: 'Confirm Order Delivery',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //? Header 1.
          Text(
            "Enter 10-Digit Code",
            textAlign: TextAlign.center,
            style: wayaTheme.textTheme.headlineLarge,
          ),

          // Some space.
          Gap(3.h),

          //? Subtitle.
          Text(
            'Enter the 10-digit token to complete the handover.',
            textAlign: TextAlign.center,
            style: wayaTheme.textTheme.hintStyle,
          ),

          //? For the OTP fields
          OtpTextField(
            numberOfFields: 10,
            borderColor: wayaTheme.colorScheme.greyColor300,
            focusedBorderColor: wayaTheme.colorScheme.primary,
            showFieldAsBox: true,
            onCodeChanged: (value) {
              raw = value;
            },
            onSubmit: (value) {
              raw = value;
              _handleSubmit();
            },
          ),
        ],
      ),
    );
  }
}
