
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/donation/view/all_donations.dart';
import 'package:wayagram/features/donation/view/my_donations.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';

class Donations extends ConsumerStatefulWidget {
  static const route = '/donations';
  const Donations({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DonationsState();
}

class _DonationsState extends ConsumerState<Donations> with SingleTickerProviderStateMixin {

  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(donationVmProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
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
        ) );
  }
}
