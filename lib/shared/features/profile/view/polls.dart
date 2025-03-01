import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/explore/widgets/polls_card.dart';
import 'package:wayagram/features/polls_and_voting/data/model/fetch_all_polls.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/polls_and_voting/widgets/poll_widget.dart';

class PollsFeedWidget extends ConsumerStatefulWidget {
  final bool isExpanded;
  final bool isExplore;
  const PollsFeedWidget(
      {super.key, this.isExpanded = false, this.isExplore = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollsFeedWidget();
}

class _PollsFeedWidget extends ConsumerState<PollsFeedWidget> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createPollVotingProvider.notifier).getFeedPolls();
      ref.read(createPollVotingProvider.notifier).getAllPolls(page: 1);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pollState = ref.watch(createPollVotingProvider);
     final wayaTheme = Theme.of(context);
    // TODO: implement build
    // followed pages
    List<Docs>? polls = widget.isExpanded
        ? pollState.feedPolls
        : pollState.feedPolls.sublist(0, min(pollState.feedPolls.length, 2));

    List<Docs>? myPolls =
        pollState.fetchAllPols.sublist(0, min(pollState.feedPolls.length, 3));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //> recommened polls
        if (pollState.feedPolls.isNotEmpty && !widget.isExplore) ...[
          //> Looks Good
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: polls.length,
              itemBuilder: (context, index) {
                final poll = polls[index];
                return PollWidget(poll: poll);
              }),
        ],

        if (pollState.fetchAllPols.isNotEmpty && widget.isExplore) ...[
           Text(
              "My Polls",
              style: wayaTheme.textTheme.bodyMedium,
            ),
            const Gap(10),
          //> Looks Good
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: myPolls.length,
              itemBuilder: (context, index) {
                final poll = myPolls[index];
                return poll.voteCount != null && poll.voteCount! > 0
                    ? PollsCard(poll: poll)
                    : PollWidget(poll: poll);
              }),
        ]
      ],
    );
  }
}
