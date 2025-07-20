import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_leaderboard_card.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

class UgtDetailsLeaderboard extends ConsumerStatefulWidget {
  final Contest? model;
  const UgtDetailsLeaderboard(this.model, {super.key});

  @override
  ConsumerState<UgtDetailsLeaderboard> createState() =>
      _UgtDetailsLeaderboardState();
}

class _UgtDetailsLeaderboardState extends ConsumerState<UgtDetailsLeaderboard> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // final posts = ref.watch(postProvider);
    //final wayaTheme = Theme.of(context);
    // final postNotifier = ref.read(postProvider.notifier);
    final viewModel = ref.read(votersContestNotifier);
    //final notifier = ref.read(votersContestNotifier.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //  UgtLeaderboardCard(),

        if (viewModel.myContestList.isEmpty) emptyWidget(),
        if (viewModel.isLoading!) Center(child: CircularProgressIndicator()),

        ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: viewModel.myContestList.length,
          itemBuilder: (context, index) {
            final post = viewModel.myContestList[index];
            return GestureDetector(
              onTap: () {
                ref.read(selectedContestantProfile.notifier).state = post;
                ref.read(selectedContestProvider.notifier).state = widget.model;
                WayaNav.toNamed(
                  '/contest-profile-page',
                  arguments: {
                    "id": post.profileId ?? "",
                    "contest": widget.model?.id ?? "",
                  },
                );
              },
              child: UgtLeaderboardCard(
                  model: widget.model!,
                  position: index + 1,
                  contestantData: post),
            );
          },
        ),
        Gap(50)
      ],
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
      icon: Image.asset("assets/images/u-emptystate.png"),
      desc: "There is no Contestant for this contest yet",
      title: "No Contestant",
      buttonText: "",
      showButtonBusiness: false,
      hideButton: false,
      onTap: () {},
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
