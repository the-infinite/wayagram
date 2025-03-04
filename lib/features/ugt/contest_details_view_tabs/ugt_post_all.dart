import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_post_all_card.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

class UgtPostAllContestant extends ConsumerStatefulWidget {
  //final  MyContestContestantModel? contestApplicant;
  const UgtPostAllContestant({super.key});

  @override
  _UgtDetailsPostState createState() => _UgtDetailsPostState();
}

class _UgtDetailsPostState extends ConsumerState<UgtPostAllContestant> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final posts = ref.watch(postProvider);

    final wayaTheme = Theme.of(context);
    final viewModel = ref.read(votersContestNotifier);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // UgtPostCard(),
        //  UgtPostCard(),
        //  if (posts.isEmpty) emptyWidget(),
        //  if (posts.isNotEmpty)
        ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: viewModel.myPostList.length,
          itemBuilder: (context, index) {
            /*  if (postNotifier.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
 */
            final post = viewModel.myPostList[index];
            return GestureDetector(onTap: () {}, child: UgtPostAllCard(post));
          },
        ),
      ],
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc:
            "You don’t have any active contest here. Create a \n contest and have different participant",
        title: "No Contest Created",
        buttonText: "Host a Contest",
        onTap: () {
          //  ivalidateUGTVM(ref);
          //  WayaNav.toNamed("/create-contest");
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
