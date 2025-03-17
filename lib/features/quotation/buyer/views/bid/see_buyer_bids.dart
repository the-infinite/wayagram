import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/quotation/quotation_bottomsheet_modal/quotation_modal.dart';
import 'package:wayagram/features/quotation/widgets/single_negotiation_bid.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';

class SeeBuyerBids extends ConsumerStatefulWidget {
  static const route = '/quotation/buyer/bids';
  final String id;

  // Construct.
  const SeeBuyerBids({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SeeBuyerBidsState();
}

class _SeeBuyerBidsState extends ConsumerState<SeeBuyerBids> {
  late final notifier = ref.read(userQuotationsProvider.notifier);
  final cancelNotifier = ValueNotifier(false);
  final extendNotifier = ValueNotifier(false);
  final requestState = ValueNotifier<BuyRequestModel?>(null);
  Timer? _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //? Now, let the timer keep ticking.
      final result = await notifier.getBuyRequest(widget.id);
      if (result != null) requestState.value = result;

      //? Now, listen to this periodically.
      _timer = Timer.periodic(const Duration(seconds: 7), (timer) async {
        //? Update this guy in the list.
        final result = await notifier.getBuyRequest(widget.id);
        if (result != null) requestState.value = result;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    requestState.dispose();
    cancelNotifier.dispose();
    extendNotifier.dispose();
    super.dispose();
  }

  Future<void> _extendBidTime() async {}

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final _ = ref.watch(userQuotationsProvider);

    //? This is fine too.
    return WayaScaffold(
      isLoading: false,
      isScrollable: false,
      padding: EdgeInsets.zero,
      backgroundColor: WayaColors.greyColor200,
      body: ValueListenableBuilder(
        valueListenable: requestState,
        builder: (context, request, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  itemCount: request?.bids?.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final bid = request!.bids![index];

                    //? Return this one.
                    return SingleNegotiationBidWidget(
                      negotiator: BidActionAuthor.buyer,
                      request: request,
                      bid: bid,
                    );
                  },
                ),
              ),

              //? This is fine.
              Container(
                padding: EdgeInsets.only(left: 20.w, right: 10.w, top: 20.h),
                height: 200.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //? First,
                    Row(
                      children: [
                        Text(
                          WayaValueHelper.formatPrice(request?.maxBidAmount ?? request?.bidStartingAmount ?? 0),
                          style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.customBlack,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        //? Boundless space.
                        Spacer(),

                        //? So, let us see how well we are doing.
                        InkWell(
                          onTap: () {
                            WayaUtils.showModalSheet(
                              context,
                              child: EditOfferModal(
                                delta: 100,
                              ),
                            );
                          },
                          child: WayaAssets.images.bid.edit.image(
                            height: 26.h,
                          ),
                        )
                      ],
                    ),

                    // Some space.
                    const Gap(20),

                    //? The title offer.
                    Text(
                      "Your Offer",
                      style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.greyColor500,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),

                    // Some space.
                    const Gap(20),

                    //? The buttons in the
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //? The button to close a bid.
                        Expanded(
                          child: WayaProgressiveButton(
                            callback: () async {
                              final result = await notifier.cancelRequest(widget.id);
                              if (result) WayaNav.goBack();
                            },
                            text: 'Cancel Buy Request',
                            color: WayaColors.error500,
                            notifier: cancelNotifier,
                          ),
                        ),

                        // Some space.
                        const Gap(5),

                        //? The button to extend a bid's time.
                        Expanded(
                          child: WayaProgressiveButton(
                            callback: _extendBidTime,
                            text: 'Extend Bid Time',
                            notifier: extendNotifier,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
