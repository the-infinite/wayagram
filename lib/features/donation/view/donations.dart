import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/auth/upgrade_to_business/views/upgrade_to_business.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/donation/view/all_donations.dart';
import 'package:wayagram/features/donation/view/my_donations.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class Donations extends ConsumerStatefulWidget {
  static const route = '/donations';
  const Donations({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DonationsState();
}

class _DonationsState extends ConsumerState<Donations>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(donationVmProvider.notifier).getAllDonation(page: 1);
      ref.read(donationVmProvider.notifier).getMyKYC();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(donationVmProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      resizeToAvoidBottomInset: false,
      title: "Donations",
      isLoading: viewModel.isLoading,
      isScrollable: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          Row(
            children: [
              WayaTabButton(
                isSelected: _selectedIndex == 0,
                text: 'All Donations',
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              WayaTabButton(
                isSelected: _selectedIndex == 1,
                text: 'My Donations',
                onTap: () => setState(() => _selectedIndex = 1),
              ),
            ],
          ),
          const Gap(20),
          _selectedIndex == 0 ? AllDonations() : MyDonations(),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: WayaButton(
          callback: () async {
            await ref.read(donationVmProvider.notifier).getMyKYC();
            if (ConversationState.self.accountType ==
                UserAccountType.personal) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                WayaUtils.showNotice(
                    context: context,
                    title: "You don't have a Business Account",
                    message:
                        'Please upgrade to a business account to create a donation post',
                    onPress: () {
                      WayaNav.goBack();
                      WayaNav.toNamed(UpgradeToBusiness.route);
                    },
                    buttonText: 'Upgrade to Business',
                    secondButtonText: 'Cancel',
                    icon: Image.asset('assets/images/cp-shop.png'));
              });
              return;
            }
            if (viewModel.kycStatus != 'APPROVED' && context.mounted) {
              WayaUtils.showNotice(
                  context: context,
                  title: "Update KYC Information ",
                  message:
                      'You must complete KYC verification before creating a donation post',
                  onPress: () {
                    WayaNav.goBack();
                    WayaNav.toNamed('/kycUpdate',
                        arguments: {'kyc': '${viewModel.kycStatus}'});
                  },
                  buttonText: 'Update KYC',
                  secondButtonText: 'Cancel',
                  icon: Image.asset('assets/images/cp-shop.png'));
            } else {
              WayaNav.toNamed('/createDonation');
            }
          },
          height: 50,
          centerWidget: Center(
            child: Icon(
              Icons.add,
              color: wayaTheme.colorScheme.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}


/**

 */