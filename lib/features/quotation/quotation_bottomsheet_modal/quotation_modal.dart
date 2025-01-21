import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';

import '../../../core/components/waya_buttons.dart';
import '../../../core/utils/waya_navigation.dart';
import '../../../core/utils/waya_utils.dart';
import '../../wallet/view/components/wallet_cards.dart';

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
            Image.asset('assets/images/bid/accept.png', height: 100.h, ),
            SizedBox(height: 20.h),
            Text(
                "Offer Accepted",
                style: wayaTheme.textTheme.bodyMedium),
            SizedBox(height: 3.h),
            Text(
              "Congratulations! Your offer was accepted by\nthis vendor",

              style: wayaTheme.textTheme.hintStyle, textAlign: TextAlign.center,),

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
                                          Image.asset('assets/images/bid/check.png', height: 9.h, width: 9.w,),
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
                                const Gap(8),
                                Text(
                                  "SURAJ STORES",
                                  style: TextStyle().wayaCopyWith(
                                    color: wayaTheme.colorScheme.customBlack,
                                    fontSize: 14,
                                  ),
                                ),
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
                                    Row(children: [
                                      Image.asset('assets/images/bid/star.png', height: 16.h, width: 16.w,),
                                      Text(
                                        " 4.5 (250 reviews)",
                                        style: TextStyle().wayaCopyWith(
                                          color: WayaColors.greyColor400,
                                          //color: wayaTheme.colorScheme.,
                                          fontSize: 12,
                                        ),
                                      ),


                                    ],)
                                  ],
                                ),
                                const Gap(10),


                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 1, color: WayaColors.greyColor100,),
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
              callback: () async{
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
            Image.asset('assets/images/bid/accept.png', height: 100.h, ),
            SizedBox(height: 20.h),
            Text(
                "Bid Won",
                style: wayaTheme.textTheme.bodyMedium),
            SizedBox(height: 3.h),
            Text(
              "Congratulations! You've successfully secured\nthe winning bid!",

              style: wayaTheme.textTheme.hintStyle, textAlign: TextAlign.center,),

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
                                                  color:  WayaColors.greyColor400,
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
                                    Image.asset('assets/images/bid/coin_in_hand.png', height: 30.h,),
                                  ],
                                ),
                               // const Gap(10),
                                Row(children: [
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


                                ],),
                                const Gap(10),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 1, color: WayaColors.greyColor100,),
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
                            callback: (){},
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
              callback: () async{
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
  const EditOfferModal({super.key});

  @override
  State<EditOfferModal> createState() => _EditOfferModalState();
}

class _EditOfferModalState extends State<EditOfferModal> {
  String amount = "0";

  final double maxAmount = 50000000;
  String? errorMessage;

  void _updateAmount(String value) {
    setState(() {
      if (amount == "0.00") {
        amount = value;
      } else {
        // Prevent leading zeros
        if (amount == "0") {
          amount = value;
        } else {
          if (amount.length > 8) return;
          amount += value;
        }
      }

      // Clear error when user starts typing again
      errorMessage = null;
    });
  }

  void _deleteAmount() {
    setState(() {
      if (amount.length > 1) {
        amount = amount.substring(0, amount.length - 1);
        if (amount.isEmpty) {
          amount = "0.00";
        }
      } else {
        amount = "0.00";
      }
      errorMessage = null;
    });
  }

  void _handleSubmit() async {
    // Convert amount string to double for comparison
    double numericAmount = double.tryParse(amount) ?? 0;

    // Validate amount
    if (amount == "0.00" || amount == "0" || amount.startsWith("00")) {
      setState(() {
        errorMessage = "Please enter a valid amount";
      });
      return;
    }else{
      Navigator.of(context).pop();
      // WayaUtils.showModalSheet(
      //   context,
      //   child: ConfirmVoteOptionModal(amount: amount,),
      // );
    }

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

            Text(
                "Edit your Offer",
                style: wayaTheme.textTheme.titleLarge),
            SizedBox(height: 3.h),
            Text(
              'Update your base price for this request',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.greyColor500 ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
             _offerCard(WayaColors.greyColor200, '-100'),
                const Gap(5),
              Text(
                amount,
                style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                    color: amount == '0' ?Theme.of(context).colorScheme.greyColor400 : Theme.of(context).colorScheme.black),
                textAlign: TextAlign.center,
              ),
                const Gap(5),
             _offerCard(WayaColors.primary, '+100'),
            ],),


            SizedBox(height: 17.h),
            const Gap(20),
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
           /* Column(
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
                                                  color:  WayaColors.greyColor400,
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
                                    Image.asset('assets/images/bid/coin_in_hand.png', height: 30.h,),
                                  ],
                                ),
                                // const Gap(10),
                                Row(children: [
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


                                ],),
                                const Gap(10),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 1, color: WayaColors.greyColor100,),
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
                            callback: (){},
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
              callback: () async{
                WayaNav.toNamed("/buyer-checkout");
              },
              text: "Proceed to Order Fulfillment",
            ),

            WayaButton(
                text: 'Cancel',
                color: wayaTheme.colorScheme.transparent,
                textColor: wayaTheme.colorScheme.customBlack,
                border:
                Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
                callback: () {
                  //widget.gotoPreviousTab();
                })*/

          ],
        ),
      ),
    );
  }
  Widget _offerCard(color, txt){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color
      ),
      height: 70.h,
      width: 90.w,
      child:  Center(
        child: Text(
          '+100',
          style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.white),
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
          color: backgroundColor != null
              ? Colors.transparent
              : Colors.grey.shade300,
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
