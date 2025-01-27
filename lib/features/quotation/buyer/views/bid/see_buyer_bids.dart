import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/quotation/buyer/vm/create_request_vm.dart';
import 'package:wayagram/features/quotation/quotation_bottomsheet_modal/quotation_modal.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createRequestProvider.notifier).getBuyerRequest();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final provider = ref.watch(cancelBuyRequestVmProvider);
    final viewModel = ref.watch(createRequestProvider);
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        padding: EdgeInsets.zero,
        backgroundColor: WayaColors.greyColor200,
        body: Column(
          children: [
            SizedBox(
              height: 500.h,
              child: ListView.builder(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  itemCount: viewModel.buyerRequest.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return SingleNegotiationBidWidget(
                        isSeller: true,
                      product: viewModel.buyerRequest[index],
                      );
                  }),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.w, right: 10.w, top: 20.h),
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                      "₦ 19,000.00",
                      style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.customBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                        onTap: (){
                          WayaUtils.showModalSheet(
                            context,
                            child: EditOfferModal(),
                          );
                        },
                        child: Image.asset('assets/images/bid/edit.png', height: 26.h,))
                  ],),

                  Text(
                    "Your Offer",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.greyColor500, fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: context.width * 0.45,
                        child: WayaButton(
                          callback: () {
                            provider.cancelRequest(context);
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
                ],
              ),
            )
          ],
        ),
      /*      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           */
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
      /*
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
      ),*/
    );
  }

}

