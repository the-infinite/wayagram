import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:wayagram/core/components/components.dart';

import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/quotation/widgets/single_negotiation_bid.dart';

import '../../vm/cancel_buy_request_vm.dart';




class SeeBuyerBids extends ConsumerStatefulWidget {
  static const route = '/seeBuyer-bids';
  const SeeBuyerBids({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SeeBuyerBidsState();
}

class _SeeBuyerBidsState extends ConsumerState<SeeBuyerBids> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(cancelBuyRequestVmProvider);
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        padding: EdgeInsets.zero,
        body: ListView.builder(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return SingleNegotiationBidWidget(
                  isSeller: true,
                );
            }),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           /* SizedBox(
                width: context.width * 0.35,
                height: 50,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [

                    Text(
                      "₦ 19,000.00",
                      style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.customBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Positioned(
                      top: 12,
                      child: Text(
                        "Your Offer",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.greyColor500, fontWeight: FontWeight.normal, fontSize: 14),
                      ),
                    ),


                  ],
                )),
            SizedBox(width: 40.w,),*/
            SizedBox(
              width: context.width * 0.45,
              child: WayaButton(
                callback: () {
                  viewModel.cancelRequest(context);
                },
                text: 'Cancel Buy Request',
                color: WayaColors.error500,
              ),
            ),
            const Gap(5),
            SizedBox(
              width: context.width * 0.45,
              child: WayaButton(
                callback: () {
                  //viewModel.checkout(context);
                },
                text: 'Extend Bid Time',
              ),
            )
          ],
        ),
      ),
    );
  }

}

