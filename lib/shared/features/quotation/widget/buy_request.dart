import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';

class QuotationBuyRequestWidget extends StatefulWidget {
  final BuyRequestModel data;
  final int index;
  final QuotationsNotifier notifier;

  // Construct.
  const QuotationBuyRequestWidget({
    super.key,
    required this.data,
    required this.index,
    required this.notifier,
  });

  @override
  State<QuotationBuyRequestWidget> createState() => _QuotationBuyRequestWidgetState();
}

class _QuotationBuyRequestWidgetState extends State<QuotationBuyRequestWidget> {
  final timeNotifier = ValueNotifier(Duration.zero);
  late final Timer timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //? If the status is not started, then we need to calculate the time left
      //? until the bid starts.
      if (widget.data.status == BuyRequestStatus.notStarted) {
        timeNotifier.value = widget.data.bidStart.difference(DateTime.now()).abs();
      }

      //? If the status is active, then we need to calculate the time left until
      //? bidding ends.
      else {
        timeNotifier.value = widget.data.bidEnd.difference(DateTime.now()).abs();
      }

      //? Now, let the timer keep ticking.
      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        final eval = timeNotifier.value - const Duration(seconds: 1);

        //? Update this guy in the list.
        if (eval.isNegative) {
          await widget.notifier.getBuyRequest(widget.data.id).then((_) {
            timer.cancel();
          });
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
    timer.cancel();
    super.dispose();
  }

  Future<void> _placeBid() async {}

  Future<void> _viewBids() async {}

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? The component itself.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: wayaTheme.colorScheme.greyColor200,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                width: 110,
                decoration: BoxDecoration(
                  color: widget.data.status == BuyRequestStatus.notStarted
                      ? wayaTheme.colorScheme.pending.withAlpha(30)
                      : wayaTheme.colorScheme.success50,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  spacing: 5,
                  children: [
                    //? The icons.
                    WayaAssets.icons.bBid.svg(
                      colorFilter: ColorFilter.mode(
                        widget.data.status == BuyRequestStatus.notStarted
                            ? wayaTheme.colorScheme.pending
                            : wayaTheme.colorScheme.success,
                        BlendMode.srcIn,
                      ),
                    ),

                    //? The status description text.
                    Text(
                      widget.data.status == BuyRequestStatus.notStarted ? "Not Started" : "Open Bid",
                      style: wayaTheme.textTheme.descriptionStyle.copyWith(
                        color: widget.data.status == BuyRequestStatus.notStarted
                            ? wayaTheme.colorScheme.pending
                            : wayaTheme.colorScheme.success,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),

              // Some space
              const Gap(10),

              //? The category of this quotation
              Text(
                widget.data.category.toUpperCase(),
                style: wayaTheme.textTheme.hintStyle,
              ),

              // Some space.
              const Gap(20),

              //? The name of the product.
              Text(
                widget.data.fullname,
                style: wayaTheme.textTheme.titleLarge,
              ),

              // Some space.
              const Gap(20),

              //? Our description.
              WayaCollapsibleText(
                widget.data.description,
                initialState: true,
                maxLines: 3,
                textColor: wayaTheme.colorScheme.greyColor500,
                buttonColor: wayaTheme.colorScheme.primary,
                style: wayaTheme.textTheme.descriptionStyle,
              ),

              // Some space.
              const Gap(20),

              //? Where we keep our current time left.
              ValueListenableBuilder(
                valueListenable: timeNotifier,
                builder: (context, timeLeft, _) {
                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.data.status == BuyRequestStatus.notStarted
                              ? 'Bidding Starts in '
                              : 'Bidding Ends in ',
                          style: wayaTheme.textTheme.hintStyle,
                        ),
                        TextSpan(
                          text: WayaDateHelper.convertDurationToCountdown(timeNotifier.value),
                          style: wayaTheme.textTheme.descriptionStyle.copyWith(
                            color: wayaTheme.colorScheme.customPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Some space.
              const Gap(20),

              //? Now, for the starting bid amount.
              RichText(
                text: TextSpan(
                  children: [
                    //* For the section title.
                    TextSpan(text: 'Starting Price: ', style: wayaTheme.textTheme.hintStyle),

                    //* For the starting amount.
                    TextSpan(
                      text: '₦ ${widget.data.bidStartingAmount}',
                      style: wayaTheme.textTheme.bodyBold.copyWith(
                        color: wayaTheme.colorScheme.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Some space.
              const Gap(20),

              //? The button that we use to place a bid.
              WayaButton(
                callback: widget.data.buyerId == ConversationState.self.id ? _viewBids : _placeBid,
                text: widget.data.buyerId == ConversationState.self.id ? 'View Bids' : 'Place Bid',
                height: 48,
                isDisabled: widget.data.status != BuyRequestStatus.active,
              ),
            ],
          ),
        ),

        //? Closing space.
        const Gap(30),
      ],
    );
  }
}
