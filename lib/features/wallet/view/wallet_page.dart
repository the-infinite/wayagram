import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/wallet/view/components/wallet_cards.dart';

class WalletPage extends ConsumerStatefulWidget {
  static const route = '/wallet';
  const WalletPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      color: wayaTheme.colorScheme.scaffoldColor2,
      title: 'Wallet',
      body: SingleChildScrollView(
        child: Column(
          children: [
            WalletBalanceCard(),
            Gap(10),
            AccountDetailsCard(),
            Gap(20),
            _buildHistoryHeader(wayaTheme),
            Gap(Get.height * 0.05),
            WayaAssests.images.wallet.searchDocu.image(scale: 1.5),
            Text('No transaction yet',
                style: wayaTheme.textTheme.headlineMedium),
            SizedBox(
              width: 310,
              child: Text(
                'Looks like you haven’t performed any transaction yet',
                textAlign: TextAlign.center,
                style: wayaTheme.textTheme.labelMedium
                    ?.wayaCopyWith(color: wayaTheme.colorScheme.greyColor500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildHistoryHeader(ThemeData wayaTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Transaction History',
          style: wayaTheme.textTheme.titleMedium,
        ),
        GestureDetector(
          child: Text(
            'See All',
            style: wayaTheme.textTheme.titleMedium
                ?.wayaCopyWith(color: wayaTheme.colorScheme.primary500),
          ),
        ),
      ],
    );
  }
}
