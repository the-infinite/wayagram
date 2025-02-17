
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/polls_and_voting/views/my_polls.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';



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
    final viewModel = ref.watch(createPollVotingProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        title: "Donations",
        isLoading: viewModel.isLoading,
        isScrollable: true,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaButton(
                  centerWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Text(
                        "Create a Donation Post",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const Gap(8),
                      Icon(
                        Icons.add,
                        size: 28,
                        color: wayaTheme.colorScheme.customPrimary,
                      ),

                    ],
                  ),
                  callback: () {
                    //WayaNav.toNamed('/create-poll');
                  },
                  color: wayaTheme.colorScheme.primar50,
                ),
              ],
            ),

            const Gap(25),
            _selectedIndex == 0 ? MyPolls() : MyPolls(),

          ],
        ) );
  }
}
