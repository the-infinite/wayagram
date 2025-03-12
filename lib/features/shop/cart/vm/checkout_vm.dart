import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/shop/cart/data/repo/cart_repository.dart';
import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';
import 'package:wayagram/features/wallet/view/fund_wallet_options_screen.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';
import 'package:wayagram/features/shop/order/data/repo/order_repository.dart';

class CheckoutState {
  final bool isLoading;

  CheckoutState({this.isLoading = false});

  CheckoutState copyWith({bool? isLoading}) {
    return CheckoutState(isLoading: isLoading ?? this.isLoading);
  }
}

class CheckoutVm extends StateNotifier<CheckoutState> {
  final Ref ref;
  final OrderRepository _orderRepository;
  final WayaSecureDataSource _secureDataSource;

  CheckoutVm(this._orderRepository, this._secureDataSource, this.ref)
      : super(CheckoutState());

  Future<void> checkout(
      {required BuildContext context,
      required String cartId,
      required String shopId,
      required int amount,
      String? pickupAddress}) async {
    try {
      final balanceData = ref.watch(walletVmProvider).data;

      final balance = balanceData == null ? "0" : balanceData.balance;

      if (double.parse(balance).toInt() <= amount && context.mounted) {
        return WayaUtils.showNotice(
            context: context,
            title: 'Payment Unsuccessful',
            onCancel: () => WayaNav.goBack(),
            message:
                'Payment failed. Top up your WayaGram Wallet to complete your purchase seamlessly',
            onPress: () => WayaNav.toNamed(FundWalletOptionsScreen.route),
            icon: Image.asset('assets/images/d-code-invalid.png'),
            buttonCenterWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.wallet_outlined,
                  color: Theme.of(context).colorScheme.white,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  "Fund your Wallet",
                  style: TextStyle().wayaCopyWith(
                      color: Theme.of(context).colorScheme.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                )
              ],
            ));
      }

      await placOrder(
          cartId: cartId,
          shopId: shopId,
          pickupAddress: pickupAddress,
          context: context);
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> placOrder(
      {required String cartId,
      required String shopId,
      String? pickupAddress,
      required BuildContext context}) async {
    state = state.copyWith(isLoading: true);
    try {
      final userId = await _secureDataSource.getUserId();

      final response = await _orderRepository.createOrder(
          cartId: cartId,
          shopId: shopId,
          userId: userId!,
          pickupAddress: pickupAddress
         );
      if (response.success && context.mounted) {
        WayaUtils.showNotice(
          context: context,
          title: 'Payment Successful',
          onCancel: () => WayaNav.goBack(),
          message:
              'Your payment has been processed successfully, you can download your reciept and track your order progress',
          onPress: () => WayaNav.toNamed(BottomView.route,
              arguments: {'index': 1, 'current': 1}),
          icon: Image.asset('assets/images/d-code-valid.png'),
          buttonCenterWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(WayaAssets.icons.vanIcon.path,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.white, BlendMode.srcIn)),
              const SizedBox(
                width: 4,
              ),
              Text(
                "Track your delivery here",
                style: TextStyle().wayaCopyWith(
                    color: Theme.of(context).colorScheme.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final checkoutVmProvider = StateNotifierProvider<CheckoutVm, CheckoutState>(
    (ref) => CheckoutVm(OrderRepository(), WayaSecureDataSource(), ref));
