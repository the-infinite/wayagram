import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

class BuyerCheckoutVm extends ChangeNotifier {
  final Ref ref;
  BuyerCheckoutVm(this.ref);

  void checkout(BuildContext context) {
    WayaUtils.showNotice(
      context: context,
      title: 'Payment Unsuccessful',
      message: 'Payment failed. Top up your WayaGram Wallet to complete your \n purchase seamlessly',
      onPress: () => Navigator.of(context).pop(),
      icon: Image.asset('assets/images/d-code-invalid.png'),
      buttonCenterWidget: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
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
                      color: Theme.of(context).colorScheme.white, fontSize: 14, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),

          // Some space.
          const Gap(8),
        ],
      ),
    );
  }
}

final buyerCheckoutVmProvider = ChangeNotifierProvider((ref) => BuyerCheckoutVm(ref));
