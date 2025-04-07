import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/widgets/contest_card.dart';

class UgtContestWidget extends StatefulHookConsumerWidget {
  //? Is this expanded?
  final bool isExpanded;

  //? constructor for is expanded
  const UgtContestWidget({super.key, required this.isExpanded});

  @override
  ConsumerState<UgtContestWidget> createState() => _UgtContestWidgetState();
}

class _UgtContestWidgetState extends ConsumerState<UgtContestWidget> {
  late final contestNotifier = ref.read(postProvider.notifier);
  @override
  Widget build(BuildContext context) {
    //?Listening to the view models
    final viewModel = ref.watch(postProvider);

//? fetch the contest for you once
    useEffect(() {
      contestNotifier.fetchContestForYou(true);
      return null;
    }, []);

    //? This is fine.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.isExpanded
            ? viewModel.listContestForYou.length
            : min(viewModel.listContestForYou.length, 3),
        (index) => ContestCard(
          viewModel.listContestForYou[index],
          contestNotifier.toggleLike,
          contestNotifier.toggleShare,
          contestNotifier.doFollow,
        ),
      ),
    );
  }
}
