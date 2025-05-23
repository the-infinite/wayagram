import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_post_card.dart';
import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';
import 'package:wayagram/features/ugt/vm/ugt_contestant_profile_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

class UgtDetailsPost extends ConsumerStatefulWidget {
  final MyContestContestantModel? contestApplicant;
  const UgtDetailsPost(this.contestApplicant, {super.key});

  @override
  ConsumerState<UgtDetailsPost> createState() => _UgtDetailsPostState();
}

class _UgtDetailsPostState extends ConsumerState<UgtDetailsPost> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final posts = ref.watch(postProvider);
    //final wayaTheme = Theme.of(context);
    final posts = ref.watch(ugtContestantProfileVm);
    var contestModel = ref.watch(selectedContestProvider.notifier).state;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // UgtPostCard(),
        //  UgtPostCard(),
        if (posts.isEmpty) emptyWidget(),
        if (posts.isNotEmpty)
          ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              /*  if (postNotifier.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
 */
              final post = posts[index];
              return GestureDetector(
                  onTap: () {},
                  child: UgtPostCard(
                      post, widget.contestApplicant, contestModel!));
            },
          ),
      ],
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc: "",
        title: "No Contest Post Created",
        showButtonBusiness: false,
        buttonText: "Contest",
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
