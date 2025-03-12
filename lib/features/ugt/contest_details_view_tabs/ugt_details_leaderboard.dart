import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_leaderboard_card.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/vm/ugt_contestant_profile_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

class UgtDetailsLeaderboard extends ConsumerStatefulWidget {
  final Contest model;
  const UgtDetailsLeaderboard(this.model, {super.key});

  @override
  _UgtDetailsLeaderboardState createState() => _UgtDetailsLeaderboardState();
}

class _UgtDetailsLeaderboardState extends ConsumerState<UgtDetailsLeaderboard> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final posts = ref.watch(postProvider);

    final wayaTheme = Theme.of(context);
    // final postNotifier = ref.read(postProvider.notifier);
    final viewModel = ref.read(votersContestNotifier);
    final notifier = ref.read(votersContestNotifier.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //  UgtLeaderboardCard(),

        if(viewModel.myContestList.isEmpty)emptyWidget(),
          if (viewModel.isLoading!) 
               Center(child: CircularProgressIndicator()),
            


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
                );
              },
              child: UgtLeaderboardCard(
                  model: widget.model,
                  position: index + 1,
                  contestantData: post),
            );
          },
        ),

        //  if (posts.isEmpty) emptyWidget(),
        /*   if (posts.isNotEmpty)
          ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              if (postNotifier.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              final post = posts[index];
              return GestureDetector(
                onTap: () {
                  ref.read(selectedContestProvider.notifier).state = post;
                  WayaNav.toNamed('/upcoming-manage-contest-details');
                },
                child: ContestCard(
                  post,
                  postNotifier.toggleLike,
                  postNotifier.toggleShare,
                  postNotifier.doFollow,
                ),
              );
            },
          ), */
      ],
    );
  }


  Widget emptyWidget() {
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc: "There is no Contestant for this contest yet",
        title: "No Post Created",
        buttonText: "",
        hideButton: false,
        onTap: () {
         
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
