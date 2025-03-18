import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';

class SuccessfulSetup extends ConsumerWidget {
  static const route = '/account-setup-success';
  const SuccessfulSetup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(successfulSetupVmProvider);
    return WayaScaffold(
      removeAppBar: true,
      isLoading: viewModel.isloading,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/auth/explore.png"),
                const Gap(50),
                Text(
                  "You are all set",
                  textAlign: TextAlign.center,
                  style: WayaTextStyles.titleLarge,
                ),
                const Gap(15),
                Text(
                  "Your referral code and virtual account are now active! You can easily access them anytime on your profile.",
                  textAlign: TextAlign.center,
                  style: WayaTextStyles.descriptionStyle,
                ),
              ],
            ),
          ),
          WayaButton(
            callback: () async {
              await ref.read(successfulSetupVmProvider.notifier).getUserData();
              WayaNav.toNamed('/explore');
            },
            text: "Explore Wayagram",
          ),
          const Gap(20)
        ],
      ),
    );
  }
}
