import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

class PollsFeedWidget extends ConsumerStatefulWidget {
  const PollsFeedWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollsFeedWidget();
}

class _PollsFeedWidget extends ConsumerState<PollsFeedWidget> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createPollVotingProvider.notifier).getFeedPolls();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [],
    );
  }
}
