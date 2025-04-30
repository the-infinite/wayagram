import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/donation/widget/donation_tab.dart';
import 'package:wayagram/features/polls_and_voting/views/active_polls.dart';
import 'package:wayagram/features/polls_and_voting/views/inactive_polls.dart';
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
    //final dynamic args = ModalRoute.of(context)?.settings.arguments;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //const Gap(10),
        Row(
          children: [
            DonationTabButton(
              isSelected: _selectedIndex == 0,
              text: 'Active Polls',
              onTap: () => setState(() => _selectedIndex = 0),
            ),
            const Gap(20),
            DonationTabButton(
              isSelected: _selectedIndex == 1,
              text: 'Completed Polls',
              onTap: () => setState(() => _selectedIndex = 1),
            ),
          ],
        ),
        const Gap(20),

        _selectedIndex == 0 ? ActivePolls() : InActivePolls(),
      ],
    );
  }
}
