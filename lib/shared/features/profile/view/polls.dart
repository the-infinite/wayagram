import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/explore/widgets/polls_card.dart';
import 'package:wayagram/features/polls_and_voting/data/model/fetch_all_polls.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/polls_and_voting/widgets/poll_widget.dart';
import 'package:wayagram/shared/engagement/provider/services_provider.dart';
import 'package:wayagram/shared/features/profile/model/poll.dart';
import 'package:wayagram/shared/features/profile/widget/poll.dart';
import 'package:wayagram/shared/features/user/resource/user_resource.dart';

class PollsFeedWidget extends ConsumerStatefulWidget {
  final bool isExpanded;
  final bool isExplore;
  const PollsFeedWidget({super.key, this.isExpanded = false, this.isExplore = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollsFeedWidget();
}

class _PollsFeedWidget extends ConsumerState<PollsFeedWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(servicesProvider.notifier).getFeedPolls();
      ref.read(createPollVotingProvider.notifier).getAllPolls(page: 1);
      ref.read(createPollVotingProvider.notifier).getActivePolls(1);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pollState = ref.watch(createPollVotingProvider);
    final service = ref.watch(servicesProvider);
    final wayaTheme = Theme.of(context);
    // followed pages
    List<Docs>? polls =
        widget.isExpanded ? service.feedPolls : service.feedPolls.sublist(0, min(service.feedPolls.length, 2));

    List<Docs>? myPolls = pollState.fetchAllPols.sublist(0, min(pollState.fetchAllPols.length, 3));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //> recommened polls
        if (service.feedPolls.isNotEmpty && !widget.isExplore) ...[
          //> Looks Good
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: polls.length,
            itemBuilder: (context, index) {
              final poll = polls[index];
              return PollWidget(poll: poll);
            },
          ),
        ],

        if (pollState.activePolls.isNotEmpty && widget.isExplore) ...[
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
                  : WayaFutureSubscriber(
                      future: UserResource.getUserDetails(poll.userData!.id!),
                      builder: (context, data) {
                        if (data == null) {
                          return const SizedBox();
                        }

                        return SinglePollWidget(
                          poll: PollModel.fromJson(poll.toJson()),
                          user: data.$1,
                        );
                      },
                    );
            },
          ),
        ],
      ],
    );
  }
}
