import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/donation/widget/donation_tab.dart';
import 'package:wayagram/features/polls_and_voting/views/active_polls.dart';
import 'package:wayagram/features/polls_and_voting/views/inactive_polls.dart';
import 'package:wayagram/features/polls_and_voting/views/pending_polls.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

class MyPollsTwo extends ConsumerStatefulWidget {
  const MyPollsTwo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyPollsTwoState();
}

class _MyPollsTwoState extends ConsumerState<MyPollsTwo> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createPollVotingProvider.notifier).getActivePolls(1);
      ref.read(createPollVotingProvider.notifier).getInActivePolls(1);
    });
  }


  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        Row(
          children: [
            DonationTabButton(
              isSelected: _selectedIndex == 0,
              text: 'Active Polls',
              onTap: () => setState(() => _selectedIndex = 0),
            ),
            const Gap(10),
            DonationTabButton(
              isSelected: _selectedIndex == 1,
              text: 'Completed Poll',
              onTap: () => setState(() => _selectedIndex = 1),
            ),
            const Gap(10),
            DonationTabButton(
              isSelected: _selectedIndex == 2,
              text: 'Pending Polls',
              onTap: () => setState(() => _selectedIndex = 2),
            ),
          ],
        ),

        const Gap(20),

        _selectedIndex == 0 ? ActivePolls() :_selectedIndex == 1 ? InActivePolls() : PendingPolls(),
      ],
    );
  }
}
