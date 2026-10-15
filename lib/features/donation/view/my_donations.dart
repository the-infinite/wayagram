import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/donation/view/applied_donations.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/donation/widget/donation_tab.dart';

import 'hosted_donations.dart';

class MyDonations extends ConsumerStatefulWidget {
  const MyDonations({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyDonationsState();
}

class _MyDonationsState extends ConsumerState<MyDonations> {
  late TextEditingController searchController;

  void _onSearchChanged() {
    setState(() {}); // Rebuild when search text changes
  }

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
    searchController.addListener(_onSearchChanged);
  }

  int _selectedIndex = 0;

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
