import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';

class QuotationModal extends StatefulWidget {
  const QuotationModal({super.key});

  @override
  State<QuotationModal> createState() => _QuotationModalState();
}

class _QuotationModalState extends State<QuotationModal> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/bid/accept.png',
              height: 100.h,
            ),
            SizedBox(height: 20.h),
            Text("Offer Accepted", style: wayaTheme.textTheme.bodyMedium),
            SizedBox(height: 3.h),
            Text(
              "Congratulations! Your offer was accepted by\nthis vendor",
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 17.h),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                  decoration: BoxDecoration(
                    color: wayaTheme.colorScheme.scaffoldColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/bid/store.png',
                            height: 48,
                          ),
                          const Gap(10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
                                      decoration: BoxDecoration(
                                        color: wayaTheme.colorScheme.success,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/bid/check.png',
                                            height: 9.h,
                                            width: 9.w,
                                          ),
                                          const Gap(5),
                                          Text(
                                            "Accepted",
                                            style: TextStyle().wayaCopyWith(
                                              color: wayaTheme.colorScheme.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // Some space.
                                const Gap(8),

                                //? The name of the store.
                                Text(
                                  "SURAJ STORES",
                                  style: TextStyle().wayaCopyWith(
                                    color: wayaTheme.colorScheme.customBlack,
                                    fontSize: 14,
                                  ),
                                ),

                                // Some more space.
                                const Gap(8),
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '15min ',
                                            style: TextStyle().wayaCopyWith(
                                              color: wayaTheme.colorScheme.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '2km ',
                                            style: TextStyle().wayaCopyWith(
                                              color: WayaColors.greyColor400,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/bid/star.png',
                                          height: 16.h,
                                          width: 16.w,
                                        ),
                                        Text(
                                          " 4.5 (250 reviews)",
                                          style: TextStyle().wayaCopyWith(
                                            color: WayaColors.greyColor400,
                                            //color: wayaTheme.colorScheme.,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const Gap(10),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: WayaColors.greyColor100,
                      ),
                      const Gap(10),
                      Text(
                        "₦ 19,000.00",
                        style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.customBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(10),
              ],
            ),
            WayaButton(
              callback: () async {
                WayaNav.toNamed("/buyer-checkout");
              },
              text: "Proceed to Payment",
            ),
          ],
        ),
      ),
    );
  }
}

class BidWonModal extends StatefulWidget {
  const BidWonModal({super.key});

  @override
  State<BidWonModal> createState() => _BidWonModalState();
}

class _BidWonModalState extends State<BidWonModal> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/bid/accept.png',
              height: 100.h,
            ),
            SizedBox(height: 20.h),
            Text("Bid Won", style: wayaTheme.textTheme.bodyMedium),
            SizedBox(height: 3.h),
            Text(
              "Congratulations! You've successfully secured\nthe winning bid!",
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 17.h),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                  decoration: BoxDecoration(
                    color: wayaTheme.colorScheme.scaffoldColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset('assets/icons/bid-icon.svg'),
                          const Gap(10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Samsung S24 Ultra",
                                  style: TextStyle().wayaCopyWith(
                                    color: wayaTheme.colorScheme.customBlack,
                                    fontSize: 14,
                                  ),
                                ),
                                //const Gap(8),
                                Row(
                                  children: [
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: 'Time Remaining | ',
                                          style: TextStyle().wayaCopyWith(
                                              color: WayaColors.greyColor400,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400)),
                                      TextSpan(
                                          text: '11h: 20m: 30s',
                                          style: TextStyle().wayaCopyWith(
                                              color: wayaTheme.colorScheme.customPrimary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400)),
                                    ])),
                                    Spacer(),
                                    Image.asset(
                                      'assets/images/bid/coin_in_hand.png',
                                      height: 30.h,
                                    ),
                                  ],
                                ),
                                // const Gap(10),
                                Row(
                                  children: [
                                    Text(
                                      " Fairly Used  ",
                                      style: TextStyle().wayaCopyWith(
                                        color: WayaColors.greyColor400,
                                        //color: wayaTheme.colorScheme.,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      " Lagos State",
                                      style: TextStyle().wayaCopyWith(
                                        color: WayaColors.greyColor400,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(10),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: WayaColors.greyColor100,
                      ),
                      const Gap(10),
                      Row(
                        children: [
                          Text(
                            "₦ 350,500.00",
                            style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          WayaButton(
                            callback: () {},
                            text: 'Won Bid',
                            height: 36,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(30),
              ],
            ),
            WayaButton(
              callback: () async {
                WayaNav.toNamed("/buyer-checkout");
              },
              text: "Proceed to Order Fulfillment",
            ),
          ],
        ),
      ),
    );
  }
}

class EditOfferModal extends StatefulWidget {
  final String hint;
  final String title;
  final double maxAmount;
  final double delta;

  // Construct.
  const EditOfferModal({
    super.key,
    required this.delta,
    this.title = 'Edit your Offer',
    this.hint = 'Update your base price for this request',
    this.maxAmount = 5000000,
  });

  @override
  State<EditOfferModal> createState() => _EditOfferModalState();
}

class _EditOfferModalState extends State<EditOfferModal> {
  double raw = 0;
  String? errorMessage;

  void _updateAmount(String value) {
    String amount = raw.toStringAsFixed(0);
    setState(() {
      raw = double.tryParse('$amount$value') ?? 0;

      // Clear error when user starts typing again
      errorMessage = null;
    });
  }

  void _deleteAmount() {
    String amount = raw.toStringAsFixed(0);

    if (amount.length > 1) {
      amount = amount.substring(0, amount.length - 1);
      if (amount.isEmpty) {
        amount = "0";
      }
    } else {
      amount = "0";
    }

    //? This is fine.
    setState(() {
      raw = double.tryParse(amount) ?? 0;
      errorMessage = null;
    });
  }

  void _handleSubmit() async {
    // Validate amount
    if (raw == 0 || raw.isNegative) {
      setState(() {
        errorMessage = "Please enter a valid amount";
      });
      return;
    }

    // Return the number as a result.
    WayaNav.goBack(result: raw);
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //? Our title.
            Text(
              widget.title,
              style: wayaTheme.textTheme.titleLarge,
            ),

            // Some space.
            SizedBox(height: 3.h),

            //? The subtitle.
            Text(
              widget.hint,
              style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: wayaTheme.colorScheme.greyColor500,
              ),
            ),

            // Some more space.
            const Gap(20),

            //? Our price modifiers.
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //? Button for reducing this one.
                GestureDetector(
                  onTap: () {
                    setState(() {
                      raw = max(raw - widget.delta, 0);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: WayaColors.greyColor200,
                    ),
                    child: Center(
                      child: Text(
                        '-${widget.delta}',
                        style: wayaTheme.textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: wayaTheme.colorScheme.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // Some space.
                const Gap(5),

                //? The price after calculating it.
                Expanded(
                  child: Text(
                    WayaValueHelper.formatPrice(raw, 0),
                    style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: raw == 0 ? wayaTheme.colorScheme.greyColor400 : wayaTheme.colorScheme.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Some space.
                const Gap(5),

                //? Our button to increase the price by the delta amount.
                GestureDetector(
                  onTap: () {
                    setState(() {
                      raw = min(widget.delta + raw, widget.maxAmount);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: WayaColors.primary,
                    ),
                    child: Center(
                      child: Text(
                        '+${widget.delta}',
                        style: wayaTheme.textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: wayaTheme.colorScheme.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            //? Some space.
            const Gap(20),

            //? Some more data.
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                for (var i = 1; i <= 9; i++)
                  NumPadButton(
                    text: '$i',
                    onTap: () => _updateAmount('$i'),
                  ),
                NumPadButton(
                  icon: Icons.backspace_outlined,
                  onTap: _deleteAmount,
                ),
                NumPadButton(
                  text: '0',
                  onTap: () => _updateAmount('0'),
                ),
                NumPadButton(
                  icon: Icons.arrow_forward,
                  iconColor: wayaTheme.primaryColor,
                  onTap: _handleSubmit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NumPadButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  const NumPadButton({
    super.key,
    this.text,
    this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
        side: BorderSide(
          color: backgroundColor != null ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Center(
          child: icon != null
              ? Icon(
                  icon,
                  color: iconColor ?? Colors.grey.shade600,
                )
              : Text(
                  text!,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey.shade800,
                  ),
                ),
        ),
      ),
    );
  }
}
