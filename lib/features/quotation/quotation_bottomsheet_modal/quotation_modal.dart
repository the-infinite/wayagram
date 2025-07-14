import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/modals/error.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/shared/components/multi_select.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/quotation/widget/bid_timer.dart';
import 'package:wayagram/shared/features/shop/resource/default.dart';

class QuotationModal extends StatelessWidget {
  final QuotationBidModel bid;
  final BuyRequestModel request;
  final BidActionAuthor user;

  // Construct.
  const QuotationModal({
    super.key,
    required this.bid,
    required this.request,
    required this.user,
  });

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
              "Congratulations! Your offer was accepted by\n${user == BidActionAuthor.buyer ? "this vendor" : "the buyer"}",
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
                      WayaFutureSubscriber(
                        future: ShopResource.getShopById(bid.shopId),
                        suspense: (context) => const SizedBox(),
                        builder: (context, data) {
                          if (data == null) {
                            return const SizedBox();
                          }

                          //? This is fine.
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WayaDp(
                                image: data.shop.coverImage,
                                radius: 24.r,
                                isSelf: false,
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
                                                  fontSize: 11.sp,
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
                                      data.shop.name,
                                      style: TextStyle().wayaCopyWith(
                                        color: wayaTheme.colorScheme.customBlack,
                                        fontSize: 14.sp,
                                      ),
                                    ),

                                    // Some more space.
                                    const Gap(8),
                                    Row(
                                      children: [
                                        // RichText(
                                        //   text: TextSpan(
                                        //     children: [
                                        //       TextSpan(
                                        //         text: '15min ',
                                        //         style: TextStyle().wayaCopyWith(
                                        //           color: wayaTheme.colorScheme.black,
                                        //           fontSize: 12.sp,
                                        //           fontWeight: FontWeight.w400,
                                        //         ),
                                        //       ),
                                        //       TextSpan(
                                        //         text: '2km ',
                                        //         style: TextStyle().wayaCopyWith(
                                        //           color: WayaColors.greyColor400,
                                        //           fontSize: 12.sp,
                                        //           fontWeight: FontWeight.w400,
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/bid/star.png',
                                              height: 16.h,
                                              width: 16.w,
                                            ),
                                            Text(
                                              " ${data.averageRating} (${data.ratings.length} reviews)",
                                              style: TextStyle().wayaCopyWith(
                                                color: WayaColors.greyColor400,
                                                //color: wayaTheme.colorScheme.,
                                                fontSize: 12.sp,
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
                          );
                        },
                      ),
                      const Divider(
                        thickness: 1,
                        color: WayaColors.greyColor100,
                      ),
                      const Gap(10),
                      Text(
                        WayaValueHelper.formatPrice(bid.usedAmount),
                        style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.customBlack,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(10),
              ],
            ),

            //? The
            if (user == BidActionAuthor.vendor)
              WayaButton(
                callback: () async => WayaNav.toNamed(WayaAppRoutes.getQuotationOrderDetailsScreen(bid.requestId)),
                text: "Proceed to Order Fulfillment",
              )
            else
              WayaButton(
                callback: () async => WayaNav.toNamed(WayaAppRoutes.getQuotationCheckoutScreen(bid.id, bid.requestId)),
                text: "Proceed to Payment",
              ),
          ],
        ),
      ),
    );
  }
}

class BidWonModal extends StatelessWidget {
  final QuotationBidModel bid;
  final BuyRequestModel request;
  final BidActionAuthor user;

  // Construct.
  const BidWonModal({
    super.key,
    required this.bid,
    required this.request,
    required this.user,
  });

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

            // Some space.
            SizedBox(height: 20.h),
            Text(
              "Bid Won",
              style: wayaTheme.textTheme.headlineLarge,
            ),
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
                                  request.fullname,
                                  style: wayaTheme.textTheme.bodyBold.copyWith(
                                    color: wayaTheme.colorScheme.customBlack,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                //const Gap(8),
                                Row(
                                  children: [
                                    Text(
                                      'Time Remaining | ',
                                      style: wayaTheme.textTheme.hintStyle.copyWith(
                                        fontSize: 13.sp,
                                      ),
                                    ),

                                    //? Finally the timer.
                                    QuotationBidTimer(
                                      request: request,
                                      isShortTime: true,
                                      fontSize: 13.sp,
                                      isStandalone: false,
                                    ),
                                  ],
                                ),
                                // const Gap(10),
                                Row(
                                  children: [
                                    Text(
                                      request.condition == "new" ? " Brand New " : " Fairly Used ",
                                      style: TextStyle().wayaCopyWith(
                                        color: WayaColors.greyColor400,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    Text(
                                      " ${request.stateOfPurchase}",
                                      style: TextStyle().wayaCopyWith(
                                        color: WayaColors.greyColor400,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(10),
                              ],
                            ),
                          ),
                          Image.asset(
                            'assets/images/bid/coin_in_hand.png',
                            height: 45.h,
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: WayaColors.greyColor100,
                      ),
                      const Gap(10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            WayaValueHelper.formatPrice(bid.usedAmount),
                            style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          WayaButton(
                            horizontalPadding: 15.w,
                            verticalPadding: 5.h,
                            callback: () {},
                            text: 'Won Bid',
                            height: null,
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
                //? For a buyer.
                if (user == BidActionAuthor.buyer) {
                  WayaNav.toNamed(WayaAppRoutes.getQuotationCheckoutScreen(bid.id, bid.requestId));
                }

                //? For the seller.
                else {
                  WayaNav.toNamed(WayaAppRoutes.getQuotationOrderDetailsScreen(bid.requestId));
                }
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
    required this.title,
    required this.hint,
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
              style: wayaTheme.textTheme.headlineLarge,
            ),

            // Some space.
            SizedBox(height: 3.h),

            //? The subtitle.
            Text(
              widget.hint,
              style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 14.sp,
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
                          fontSize: 14.sp,
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
                      fontSize: 36.sp,
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
                          fontSize: 14.sp,
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
  final bool enabled;

  const NumPadButton({
    super.key,
    required this.onTap,
    this.enabled = true,
    this.text,
    this.icon,
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
        onTap: enabled ? onTap : null,
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
                    fontSize: 24.sp,
                    color: Colors.grey.shade800,
                  ),
                ),
        ),
      ),
    );
  }
}

class ExtendBidTime extends StatelessWidget {
  final BuyRequestModel request;
  final QuotationsNotifier notifier;
  final ValueNotifier<String?> time;
  final ValueNotifier<bool> isLoading;

  //? Added button
  const ExtendBidTime({
    super.key,
    required this.request,
    required this.notifier,
    required this.time,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    //? Parametric to build the modal.
    final wayaTheme = Theme.of(context);

    //? Return the modal.
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //? Our title.
            Text(
              "Extend Bid Time",
              style: wayaTheme.textTheme.headlineLarge,
            ),

            // Some space.
            Gap(3.h),

            //? The subtitle.
            Text(
              "Give vendors more time to respond. Choose the additional time you'd like to add",
              style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: wayaTheme.colorScheme.greyColor500,
              ),
            ),

            // Some more space.
            Gap(30.h),

            //? The text for extending time.
            WayaTextStrip(
              "Select the time you want to add",
              dividerColor: wayaTheme.colorScheme.greyColor100,
              textColor: wayaTheme.colorScheme.customBlack,
              backgroundColor: wayaTheme.colorScheme.scaffoldColor2,
              style: wayaTheme.textTheme.bodyMedium!.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),

            // Some space.
            Gap(30.h),

            //? The time options.
            ValueListenableBuilder(
              valueListenable: time,
              builder: (context, selectedTime, _) => WayaSelectField(
                hintText: "Select Time Increment",
                multi: false,
                items: [
                  Select(label: "1 hour", value: "1"),
                  ...List.generate(
                    11,
                    (index) => Select(
                      label: "${index + 2} hours",
                      value: "${index + 2}",
                    ),
                  ),
                ],
                value: selectedTime,
                onSelected: (value) {
                  time.value = value.first.value;
                },
              ),
            ),

            // Some space.
            Gap(50.h),

            //? Confirm the extension.
            WayaProgressiveButton(
              notifier: isLoading,
              callback: () async {
                //? Doing well.
                if (time.value == null) {
                  WayaUtils.showModalSheet(
                    context,
                    child: WayaErrorDialog(
                      title: "You must select a bid time.",
                    ),
                  );
                  return;
                }

                //? Now, the new time.
                final newTime = request.bidEnd.add(Duration(hours: int.parse(time.value!)));

                //? Now, go back.
                await notifier.extendBidTime(request.id, newTime.toIso8601String());
                WayaNav.goBack();
              },
              text: "Extend Bid Time",
            ),

            // Some space.
            Gap(10.h),

            //? Cancel this one.
            WayaButton(
              callback: () => WayaNav.goBack(),
              textColor: wayaTheme.colorScheme.greyColor500,
              color: wayaTheme.colorScheme.transparent,
              border: Border.all(color: wayaTheme.colorScheme.greyColor500, width: 1),
              text: "Cancel",
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateOrderStatusModal extends StatelessWidget {
  final QuotationsNotifier notifier;
  final ValueNotifier<QuotationOrderStatus?> controller;
  final ValueNotifier<bool> isLoading;
  final String orderId;

  // Construct.
  const UpdateOrderStatusModal({
    super.key,
    required this.controller,
    required this.notifier,
    required this.isLoading,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    //? Parametric.
    final wayaTheme = Theme.of(context);

    //? The component.
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, selected, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //? Our title.
              Text(
                "Update Order Status",
                style: wayaTheme.textTheme.headlineLarge,
              ),

              // Some space.
              Gap(3.h),

              //? The subtitle.
              Text(
                "Choose the new order status you want this order to display for the buyer and yourself",
                style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: wayaTheme.colorScheme.greyColor500,
                ),
              ),

              // Some more space.
              Gap(30.h),

              //? The text for extending time.
              WayaTextStrip(
                "Choose New Order Status",
                dividerColor: wayaTheme.colorScheme.greyColor100,
                textColor: wayaTheme.colorScheme.customBlack,
                backgroundColor: wayaTheme.colorScheme.scaffoldColor2,
                style: wayaTheme.textTheme.bodyMedium!.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),

              // Some space.
              Gap(30.h),

              //? The first order option.
              WayaMultipleSelectionButton(
                name: "In Progress",
                controller: controller,
                value: QuotationOrderStatus.inProgress,
              ),

              // Some space.
              Gap(5.h),

              //? The second order option.
              WayaMultipleSelectionButton(
                name: "Delivered",
                controller: controller,
                value: QuotationOrderStatus.completed,
              ),

              // Some space.
              Gap(5.h),

              //? The second order option.
              WayaMultipleSelectionButton(
                name: "Cancelled",
                controller: controller,
                value: QuotationOrderStatus.failed,
              ),

              // Some space.
              Gap(50.h),

              //? Confirm the extension.
              WayaProgressiveButton(
                notifier: isLoading,
                callback: () async {
                  //? Doing well.
                  if (controller.value == null) {
                    WayaUtils.showModalSheet(
                      context,
                      child: WayaErrorDialog(
                        title: "You must select an order status.",
                      ),
                    );
                    return;
                  }

                  //? Now, go back.
                  await notifier.updateOrderStatus(orderId, controller.value!);
                  WayaNav.goBack();
                  WayaSnackBar.showToast("Order status updated successfully");
                },
                text: "Confirm",
              ),

              // Some space.
              Gap(10.h),

              //? Cancel this one.
              WayaButton(
                callback: () => WayaNav.goBack(),
                textColor: wayaTheme.colorScheme.greyColor500,
                color: wayaTheme.colorScheme.transparent,
                border: Border.all(color: wayaTheme.colorScheme.greyColor500, width: 1),
                text: "Cancel",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateDeliveryStatusModal extends StatelessWidget {
  final QuotationsNotifier notifier;
  final String orderId;
  final ValueNotifier<QuotationDeliveryStatus?> controller;
  final ValueNotifier<bool> isLoading;

  // Construct.
  const UpdateDeliveryStatusModal({
    super.key,
    required this.notifier,
    required this.controller,
    required this.isLoading,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    //? Parametric.
    final wayaTheme = Theme.of(context);

    //? The component.
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, selected, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //? Our title.
              Text(
                "Update Delivery Status",
                style: wayaTheme.textTheme.headlineLarge,
              ),

              // Some space.
              Gap(3.h),

              //? The subtitle.
              Text(
                "Choose the new delivery status you want this order to display for the buyer and yourself",
                style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: wayaTheme.colorScheme.greyColor500,
                ),
              ),

              // Some more space.
              Gap(30.h),

              //? The text for extending time.
              WayaTextStrip(
                "Choose New Delivery Status",
                dividerColor: wayaTheme.colorScheme.greyColor100,
                textColor: wayaTheme.colorScheme.customBlack,
                backgroundColor: wayaTheme.colorScheme.scaffoldColor2,
                style: wayaTheme.textTheme.bodyMedium!.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),

              // Some space.
              Gap(30.h),

              //? The first order option.
              WayaMultipleSelectionButton(
                name: "Pending",
                controller: controller,
                value: QuotationDeliveryStatus.pending,
              ),

              // Some space.
              Gap(5.h),

              //? The second order option.
              WayaMultipleSelectionButton(
                name: "Processing",
                controller: controller,
                value: QuotationDeliveryStatus.processing,
              ),

              // Some space.
              Gap(5.h),

              //? The third order option.
              WayaMultipleSelectionButton(
                name: "Ready for Dispatch",
                controller: controller,
                value: QuotationDeliveryStatus.readyForDispatch,
              ),

              // Some space.
              Gap(5.h),

              //? The fourth order option.
              WayaMultipleSelectionButton(
                name: "In Transit",
                controller: controller,
                value: QuotationDeliveryStatus.inTransit,
              ), // Some space.
              Gap(5.h),

              //? The fifth order option.
              WayaMultipleSelectionButton(
                name: "Out For Delivery",
                controller: controller,
                value: QuotationDeliveryStatus.outForDelivery,
              ),

              // Some space.
              Gap(5.h),

              //? The final order option.
              WayaMultipleSelectionButton(
                name: "Delivered",
                controller: controller,
                value: QuotationDeliveryStatus.delivered,
              ),

              // Some space.
              Gap(50.h),

              //? Confirm the extension.
              WayaProgressiveButton(
                notifier: isLoading,
                callback: () async {
                  //? Doing well.
                  if (controller.value == null) {
                    WayaUtils.showModalSheet(
                      context,
                      child: WayaErrorDialog(
                        title: "You must select a delivery status.",
                      ),
                    );
                    return;
                  }

                  //? Now, go back.
                  await notifier.updateDeliveryStatus(orderId, controller.value!);
                  WayaNav.goBack();
                  WayaSnackBar.showToast("Delivery status updated successfully");
                },
                text: "Confirm",
              ),

              // Some space.
              Gap(10.h),

              //? Cancel this one.
              WayaButton(
                callback: () => WayaNav.goBack(),
                textColor: wayaTheme.colorScheme.greyColor500,
                color: wayaTheme.colorScheme.transparent,
                border: Border.all(color: wayaTheme.colorScheme.greyColor500, width: 1),
                text: "Cancel",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdatePickupStatusModal extends StatelessWidget {
  final QuotationsNotifier notifier;
  final String orderId;
  final ValueNotifier<QuotationPickupStatus?> controller;
  final ValueNotifier<bool> isLoading;

  const UpdatePickupStatusModal({
    super.key,
    required this.notifier,
    required this.orderId,
    required this.controller,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    //? Parametric.
    final wayaTheme = Theme.of(context);

    //? The component.
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, selected, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //? Our title.
              Text(
                "Update Pick-up Status",
                style: wayaTheme.textTheme.headlineLarge,
              ),

              // Some space.
              Gap(3.h),

              //? The subtitle.
              Text(
                "Choose the new pick-up status you want this order to display for the buyer and yourself",
                style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: wayaTheme.colorScheme.greyColor500,
                ),
              ),

              // Some more space.
              Gap(30.h),

              //? The text for extending time.
              WayaTextStrip(
                "Choose New Pick-up Status",
                dividerColor: wayaTheme.colorScheme.greyColor100,
                textColor: wayaTheme.colorScheme.customBlack,
                backgroundColor: wayaTheme.colorScheme.scaffoldColor2,
                style: wayaTheme.textTheme.bodyMedium!.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),

              // Some space.
              Gap(30.h),

              //? The first order option.
              WayaMultipleSelectionButton(
                name: "Pending",
                controller: controller,
                value: QuotationPickupStatus.pending,
              ),

              // Some space.
              Gap(5.h),

              //? The second order option.
              WayaMultipleSelectionButton(
                name: "Ready for Pick-up",
                controller: controller,
                value: QuotationPickupStatus.ready,
              ),

              // Some space.
              Gap(5.h),

              //? The third order option.
              WayaMultipleSelectionButton(
                name: "Pick-up scheduled",
                controller: controller,
                value: QuotationPickupStatus.scheduled,
              ),

              // Some space.
              Gap(5.h),

              //? The final order option.
              WayaMultipleSelectionButton(
                name: "Pick-up completed",
                controller: controller,
                value: QuotationPickupStatus.collected,
              ),

              // Some space.
              Gap(50.h),

              //? Confirm the extension.
              WayaProgressiveButton(
                notifier: isLoading,
                callback: () async {
                  //? Doing well.
                  if (controller.value == null) {
                    WayaUtils.showModalSheet(
                      context,
                      child: WayaErrorDialog(
                        title: "You must select a pick-up status.",
                      ),
                    );
                    return;
                  }

                  //? Now, go back.
                  await notifier.updatePickupStatus(orderId, controller.value!);
                  WayaNav.goBack();
                  WayaSnackBar.showToast("Pickup status updated successfully");
                },
                text: "Confirm",
              ),

              // Some space.
              Gap(10.h),

              //? Cancel this one.
              WayaButton(
                callback: () => WayaNav.goBack(),
                textColor: wayaTheme.colorScheme.greyColor500,
                color: wayaTheme.colorScheme.transparent,
                border: Border.all(color: wayaTheme.colorScheme.greyColor500, width: 1),
                text: "Cancel",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
