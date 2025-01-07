// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shared/components/loading_dialog.dart';
import 'package:wayagram/features/shared/routes/shared_routes.dart';
import 'package:wayagram/features/wallet/view/components/fund_amount_dialog.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';

import 'components/components.dart';

class FundWalletPage extends ConsumerStatefulWidget {
  const FundWalletPage({super.key});

  @override
  ConsumerState<FundWalletPage> createState() => _FundWalletPageState();
}

class _FundWalletPageState extends ConsumerState<FundWalletPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(walletFundingOptionsVmProvider.notifier)
          .getWalletFundingOptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(walletFundingOptionsVmProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      backgroundColor: wayaTheme.colorScheme.scaffoldColor,
      title: 'Fund Wallet',
      body: SizedBox(
        height: 1.sh,
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Payment Method',
              style: wayaTheme.textTheme.headlineLarge,
            ),
            Text(
              'Choose the way you want to fund your \naccount',
              style: wayaTheme.textTheme.labelMedium,
            ),
            Gap(20),
            if (viewModel.isLoading!)
              const Center(child: CircularProgressIndicator.adaptive()),
            if (viewModel.fundingOptions != null &&
                viewModel.fundingOptions!.isEmpty &&
                viewModel.isLoading == false)
              const Text("No funding options available at the moment"),
            if (viewModel.fundingOptions != null)
              ...viewModel.fundingOptions!.map(
                (e) => PaymentMethodTile(
                  iconPath: WayaAssests.icons.wallet.wallet,
                  paymentMethod: e.name,
                  description: e.description,
                  onTap: () async {
                    switch (e.name) {
                      case "PAYSTACK":
                        final amount = await showDialog(
                            context: context,
                            builder: (context) {
                              return const FundAmountDialog(initialAmount: 0);
                            });

                        if (amount != null) {
                          log("$amount");
                          WayaLoadingDialog.show(context);
                          final data = await ref
                              .read(walletFundingOptionsVmProvider.notifier)
                              .walletFunding(
                                  amount: amount, fundOptionCode: e.code);
                          WayaLoadingDialog.hide(context);
                          if (data != null) {
                            WayaNav.toNamed(SharedRoutes.webview, arguments: {
                              "url": data["authorizationUrl"],
                              "title": "Waya Webview",
                              "transactionId": data["transactionId"],
                              "fundingOption": e.name
                            });
                          }
                        }
                        break;

                      default:
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
