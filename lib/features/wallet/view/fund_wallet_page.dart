import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

import 'components/components.dart';

class FundWalletPage extends StatelessWidget {
  const FundWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            PaymentMethodTile(
              iconPath: WayaAssests.icons.wallet.wallet,
              paymentMethod: 'Fund with Bank Transfer',
              description: 'Add money via mobile or internet banking',
              // onTap: () => Navigator.of(context).pushNamed(FundWithBankTransfer.route),
            ),
            PaymentMethodTile(
              iconPath: WayaAssests.icons.wallet.card,
              paymentMethod: 'Fund with WayaQuick Card',
              description: 'Add money directly from your bank card',
              onTap: () async {
                // Navigator.of(context).pushNamed(FundWithBankAccount.route, arguments: true);
              },
            ),
            PaymentMethodTile(
              iconPath: WayaAssests.icons.wallet.card,
              paymentMethod: 'Fund with Paystack Card',
              description: 'Add money directly from your bank card',
              onTap: () async {},
            ),
          ],
        ),
      ),
    );
  }
}
