import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/upt_post_approve_card.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_post_all_card.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

class UgtPostAllContestant extends ConsumerStatefulWidget {
  //final  MyContestContestantModel? contestApplicant;
  final Contest? model;
  const UgtPostAllContestant(this.model, {super.key});

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
    var viewModelNotifier = ref.watch(votersContestNotifier.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // UgtPostCard(),
        //  UgtPostCard(),
        if (viewModelNotifier.getLoggedInUserId() == widget.model?.profileId)
          //? button to switch between approved contest
          Column(
            children: [
              Gap(10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: WayaButton(
                      callback: () {
                        //?switch to active posts
                        viewModelNotifier.changeActive(true);
                        viewModelNotifier
                            .fetchAllContestPosts(widget.model?.id ?? "");
                      },
                      color: Colors.white,
                      text: "Active Posts",

                      border:
                          Border.all(color: wayaTheme.colorScheme.greyColor400),
                      //   leadingIcon: WayaAssets.icons.caution.svg(),
                      textColor: wayaTheme.colorScheme.greyColor700,
                    ),
                  ),
                  Gap(10),
                  Expanded(
                    child: WayaButton(
                      callback: () {
                        //?switch to pending posts
                        viewModelNotifier.changeActive(false);
                        viewModelNotifier.fetchAllContestPosts(
                            widget.model?.id ?? "",
                            hostApproved: false);
                      },
                      color: wayaTheme.colorScheme.primary50,
                      text: "Pending Posts",
                      leadingIcon: Container(),
                      // border: Border.all(),
                      // trailingIcon: WayaAssets.icons.caution.svg(),
                      textColor: wayaTheme.colorScheme.customPrimary,
                      trailingIcon:
                          _counter(context, viewModel.pendingPostCount ?? 0),
                    ),
                  ),
                ],
              ),
              Gap(15),
            ],
          ),
        if (viewModel.myPostList.isEmpty) emptyWidget(),
        //? List of the post for a contest

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
            return viewModelNotifier.getActive()
                ? GestureDetector(
                    onTap: () {}, child: UgtPostAllCard(post, widget.model!))
                : GestureDetector(
                    onTap: () {},
                    child: UptPostApproveCard(post, widget.model!));
          },
        )
      ],
    );
  }

  Widget _ourButtons(
    BuildContext context,
  ) {
    final wayaTheme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: WayaButton(
            callback: () {},
            color: Colors.white,
            text: "Active Posts",

            border: Border.all(color: wayaTheme.colorScheme.greyColor400),
            //   leadingIcon: WayaAssets.icons.caution.svg(),
            textColor: wayaTheme.colorScheme.greyColor700,
          ),
        ),
        Gap(10),
        Expanded(
          child: WayaButton(
            callback: () {},
            color: wayaTheme.colorScheme.primary50,
            text: "Pending Posts",
            leadingIcon: Container(),
            // border: Border.all(),
            // trailingIcon: WayaAssets.icons.caution.svg(),
            textColor: wayaTheme.colorScheme.customPrimary,
            trailingIcon: _counter(context, 0),
          ),
        ),
      ],
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc: "There is no Post for this contest yet",
        title: "No Post Created",
        buttonText: "",
        hideButton: false,
        onTap: () {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _counter(BuildContext context, int count) {
    final wayaTheme = Theme.of(context);
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.customPrimary,
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      child: Center(
        child: Text(
          "$count",
          style: WayaTextStyles.bodyBold.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
