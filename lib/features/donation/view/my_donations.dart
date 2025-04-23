import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/donation/model/my_donation_model.dart';
import 'package:wayagram/features/donation/view/applied_donations.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/donation/widget/donation_tab.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

import 'hosted_donations.dart';

class MyDonations extends ConsumerStatefulWidget {
  const MyDonations({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyDonationsState();
}

class _MyDonationsState extends ConsumerState<MyDonations> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(donationVmProvider.notifier).getDonatedDonation;
      ref.read(donationVmProvider.notifier).getMyKYC();
      ref.read(donationVmProvider.notifier).getApprovedDonation();
      ref.read(donationVmProvider.notifier).getAppliedDonation();
    });
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {});
    });
  }

  int _selectedIndex = 0;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(donationVmProvider);
    final wayaTheme = Theme.of(context);
    final dynamic args = ModalRoute.of(context)?.settings.arguments;

    // Filter the myDonations
    final filteredMyDonations = WayaUtils.search<MyDonationDocs>(
      viewModel.myDonationDocs!,
      [
        'title',
      ],
      searchController.text,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(10),
        Row(
          children: [
            DonationTabButton(
              isSelected: _selectedIndex == 0,
              text: 'Hosted Donations',
              onTap: () => setState(() => _selectedIndex = 0),
            ),
            const Gap(20),
            DonationTabButton(
              isSelected: _selectedIndex == 1,
              text: 'Applied Donations',
              onTap: () => setState(() => _selectedIndex = 1),
            ),

          ],
        ),
        const Gap(20),

        _selectedIndex == 0 ? HostedDonations() : AppliedDonations(),


      ],
    );

  }
}


