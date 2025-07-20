// ignore_for_file: use_build_context_synchronously
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/modals/error.dart';
import 'package:wayagram/core/controller/preloader.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';
import 'package:wayagram/features/wallet/view/fund_wallet_options_screen.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/wallet/model/dto.dart';
import 'package:wayagram/shared/features/wallet/resource/default.dart';

class BuyerCheckout extends ConsumerStatefulWidget {
  static const route = '/quotation/buyer/checkout';
  final String id;
  final String requestId;

  // Construct.
  const BuyerCheckout({
    super.key,
    required this.id,
    required this.requestId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuyerCheckoutState();
}

class _BuyerCheckoutState extends ConsumerState<BuyerCheckout> {
  late final notifier = ref.read(userQuotationsProvider.notifier);
  late final walletNotifier = ref.read(walletVmProvider.notifier);
  final loadingController = ValueNotifier(false);
  double subtotal = 0;
  double deliveryCharge = 0;
  double totalCharge = 0;
  QuotationBidModel? bid;
  BuyRequestModel? request;
  bool payWithWallet = false;
  bool payWithWayaQuick = false;

  Future<void> _checkout() async {
    //? Validate that a payment method has been selected.
    if (!(payWithWallet || payWithWayaQuick)) {
      await WayaUtils.showModalSheet(
        context,
        child: WayaErrorDialog(title: "You must select a payment method."),
      );
      return;
    }

    //? Necessities to have this painted out.
    final wayaTheme = Theme.of(context);

    //? First, check if the user has enough funds in their wallet.
    await walletNotifier.getUserWallet();
    final walletState = ref.read(walletVmProvider);

    //? Now, read the wallet balance.
    if (walletState.data == null ||
        walletState.data!.balanceNumber < totalCharge) {
      final balanceCheck = await WayaUtils.showNotice<bool>(
        context: context,
        title: 'Payment Unsuccessful',
        message:
            'Payment failed. Top up your WayaGram Wallet to complete your \n purchase seamlessly',
        onCancel: () => WayaNav.goBack(),
        onPress: () async {
          WayaNav.goBack(result: true);
        },
        icon: WayaAssets.images.dCodeInvalid.image(),
        buttonLeadingWidget: Icon(
          Icons.wallet_outlined,
          color: wayaTheme.colorScheme.white,
        ),
        buttonText: "Fund your wallet",
      );

      //? Then try funding the wallet.
      if (balanceCheck ?? false) {
        await WayaNav.toNamed(
          FundWalletOptionsScreen.route,
          arguments: WayaAppRoutes.getQuotationCheckoutScreen(
              widget.id, widget.requestId),
        );
        return;
      }
    }

    //? Second, we now know the user has enough money. Therefore, we want to
    //? charge the account of this user.
    final chargeResult =
        await WalletResource.instance.payForService(WalletPaymentData.build(
      recipientId: bid!.vendorId,
      amount: totalCharge,
      purpose: WalletServiceType.shopping,
      description: "quot-${widget.requestId}",
      metadata: {
        "bidId": widget.id,
        "requestId": widget.requestId,
        "initiator": BidActionAuthor.buyer.name,
        "bid": bid,
        "request": request,
      },
    ));

    //? If this is not bad.
    if (chargeResult == false) return;

    //? Third, get the order that this order corresponds to.
    final order = await notifier.getOrderDetails(widget.requestId);

    //? If you are unable to retrieve the order, fail.
    if (order == null) {
      await WayaUtils.showModalSheet(
        context,
        child: WayaErrorDialog(
            title:
                "Unable to generate the order details for this buy request."),
      );
      return;
    }

    //? If this charge result was successful.
    final status = await notifier.verifyPaymentStatus(order.id, chargeResult);

    //? Since it was fine, do something else here.
    if (status) {
      WayaSnackBar.showToast("You have successfully placed this order");
    }
  }

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        //? First, show the preloader.
        WayaPreloaderController.instance.show();

        //? This is fine.
        final foundBid = notifier.getBid(widget.id) ??
            await notifier.getSingleBid(widget.id);
        final foundQuote = notifier.getBidQuote(widget.requestId) ??
            await notifier.getBuyRequest(widget.requestId);

        //? Update these values in state.
        setState(() {
          bid = foundBid;
          request = foundQuote;
          deliveryCharge = foundBid?.deliveryCharge ?? 0;
          subtotal = (foundBid?.usedAmount ?? 0) * (foundQuote?.quantity ?? 0);
          totalCharge = deliveryCharge + subtotal;
        });

        //? Finally, hide the preloader.
        WayaPreloaderController.instance.hide();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? This is fine.
    return WayaScaffold(
      title: "Checkout",
      isLoading: false,
      isScrollable: true,
      body: request == null || bid == null
          ? const SizedBox()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Container(
                  padding: EdgeInsets.all(8.dg),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: wayaTheme.colorScheme.greyColor300,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaAssets.icons.map.svg(),

                      // Some space.
                      const Gap(5),

                      //? The delivery address
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Delivery Address",
                              style: wayaTheme.textTheme.bodyMedium),
                          const Gap(5),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              request!.deliveryAddress ?? "N/A",
                              style: TextStyle().wayaCopyWith(
                                color: wayaTheme.colorScheme.greyColor500,
                                fontSize: 13.sp,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(30),
                AboutProduct(
                    title: 'Product Name', content: request!.productName),
                const Gap(15),
                if (request?.brand != null) ...[
                  AboutProduct(title: 'Brand Name', content: request!.brand!),
                  const Gap(15),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AboutProduct(
                          title: 'Product Category',
                          content: request!.category),
                    ),
                    Expanded(
                      child: AboutProduct(
                        title: 'Product Condition',
                        content: request!.condition == "new"
                            ? "Brand New"
                            : "Fairly Used",
                      ),
                    )
                  ],
                ),
                const Gap(15),
                AboutProduct(
                    title: 'Product Description',
                    content: request!.description),
                const Gap(15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AboutProduct(
                          title: 'Quantity',
                          content:
                              WayaValueHelper.formatNumber(request!.quantity)),
                    ),
                    Expanded(
                      flex: 2,
                      child: AboutProduct(
                          title: 'State of Purchase',
                          content: request!.stateOfPurchase),
                    ),
                    Expanded(
                      child: AboutProduct(
                          title: 'LGA',
                          content:
                              request!.lga == "all" ? "Any" : request!.lga),
                    )
                  ],
                ),
                const Gap(15),
                DottedBorder(
                  borderType: BorderType.RRect,
                  color: wayaTheme.colorScheme.greyColor300,
                  radius: Radius.circular(8),
                  padding: EdgeInsets.all(14),
                  dashPattern: [5, 5],
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Bid Amount",
                            style: TextStyle().wayaCopyWith(
                                color: wayaTheme.colorScheme.greyColor400,
                                fontSize: 13.sp),
                          ),
                          const Gap(6),
                          Text(
                            WayaValueHelper.formatPrice(bid!.usedAmount),
                            style: TextStyle().wayaCopyWith(
                                color: wayaTheme.colorScheme.customBlack,
                                fontSize: 14.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                DottedBorder(
                  borderType: BorderType.RRect,
                  color: wayaTheme.colorScheme.greyColor300,
                  radius: Radius.circular(8),
                  padding: EdgeInsets.all(14),
                  dashPattern: [5, 5],
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Delivery Charges",
                            style: TextStyle().wayaCopyWith(
                                color: wayaTheme.colorScheme.greyColor400,
                                fontSize: 13.sp),
                          ),
                          const Gap(6),
                          Text(
                            WayaValueHelper.formatPrice(deliveryCharge),
                            style: TextStyle().wayaCopyWith(
                                color: wayaTheme.colorScheme.customBlack,
                                fontSize: 14.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                DottedBorder(
                  borderType: BorderType.RRect,
                  color: wayaTheme.colorScheme.greyColor300,
                  radius: Radius.circular(8),
                  padding: EdgeInsets.all(14),
                  dashPattern: [5, 5],
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle().wayaCopyWith(
                                color: wayaTheme.colorScheme.greyColor400,
                                fontSize: 13.sp),
                          ),
                          const Gap(6),
                          Text(
                            WayaValueHelper.formatPrice(totalCharge),
                            style: TextStyle().wayaCopyWith(
                                color: wayaTheme.colorScheme.customBlack,
                                fontSize: 18.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(25),
                Text("Payment Method", style: wayaTheme.textTheme.bodyMedium),
                const Gap(10),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.scaffoldColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/wallet-icon.svg'),
                          const Gap(8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Wayagram Wallet",
                                style: TextStyle().wayaCopyWith(
                                  color: wayaTheme.colorScheme.customBlack,
                                  fontSize: 16.sp,
                                ),
                              ),
                              const Gap(6),
                              Text(
                                "This transaction will be deducted from \n your wallet  balance",
                                style: TextStyle().wayaCopyWith(
                                  color: wayaTheme.colorScheme.greyColor400,
                                  fontSize: 14.sp,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          setState(
                            () {
                              payWithWallet = true;
                              payWithWayaQuick = false;
                            },
                          );
                        },
                        child: payWithWallet
                            ? Image.asset(
                                'assets/images/polls/check.png',
                                height: 20.h,
                              )
                            : Image.asset(
                                'assets/images/polls/uncheck.png',
                                height: 20.h,
                              ),
                      )
                    ],
                  ),
                ),
                const Gap(10),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: wayaTheme.colorScheme.scaffoldColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/quick-icon.svg'),
                          const Gap(8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pay With Wayaquick",
                                style: TextStyle().wayaCopyWith(
                                  color: wayaTheme.colorScheme.customBlack,
                                  fontSize: 16.sp,
                                ),
                              ),
                              const Gap(6),
                              Text(
                                "Pay with waya's payment gateway",
                                style: TextStyle().wayaCopyWith(
                                  color: wayaTheme.colorScheme.greyColor400,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            payWithWallet = false;
                            payWithWayaQuick = true;
                          });
                        },
                        child: payWithWayaQuick
                            ? Image.asset(
                                'assets/images/polls/check.png',
                                height: 20.h,
                              )
                            : Image.asset(
                                'assets/images/polls/uncheck.png',
                                height: 20.h,
                              ),
                      )
                    ],
                  ),
                )
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          margin: EdgeInsets.only(bottom: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: context.width * 0.35,
                height: 50,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Positioned(
                      top: 8,
                      child: Text(
                        "Total",
                        style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.greyColor500,
                          fontWeight: FontWeight.normal,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 25,
                      child: Text(
                        WayaValueHelper.formatPrice(totalCharge),
                        style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.customBlack,
                          fontSize: 18.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 40.w,
              ),
              SizedBox(
                width: context.width * 0.45,
                child: WayaProgressiveButton(
                  notifier: loadingController,
                  callback: _checkout,
                  text: 'Checkout',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
