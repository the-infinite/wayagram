import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/ugt_details_contestants.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/ugt_details_leaderboard.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/ugt_post_all.dart';
import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/features/ugt/widgets/admin_card.dart';
import 'package:wayagram/features/ugt/widgets/contest_card.dart';

import '../../../core/components/waya_scaffold.dart';

class AdminContestDetails extends StatefulHookConsumerWidget {
  static const route = '/upcoming-manage-contest-details';
  final String id;
  const AdminContestDetails({required this.id, super.key});

  @override
  ConsumerState<AdminContestDetails> createState() =>
      _ManageContestDetailsState();
}

class _ManageContestDetailsState extends ConsumerState<AdminContestDetails> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final String myPassedContestId = Get.parameters['id'] ?? 'Unknown';
    print("COntest DI $myPassedContestId");
    useEffect(() {
      String contestId = ref.read(selectedContestProvider.notifier).state?.id ??
          myPassedContestId;
      print("COntest DI  2 $contestId");
      ref.read(postProvider.notifier).fetchSingleContest(ref, contestId);
      ref
          .read(votersContestNotifier.notifier)
          .getContestantProfileVoteDetails(contestId);

      ref.read(votersContestNotifier.notifier).fetchAllContestPosts(contestId);
      ref
          .read(votersContestNotifier.notifier)
          .fetchAllContestApplicant(contestId);
      return null;
    }, []);
    var viewModel = ref.watch(votersContestNotifier);
    var viewModelNotifier = ref.watch(votersContestNotifier.notifier);
    var model = ref.watch(selectedContestProvider.notifier).state;
    final selectedViewIndex = useState(0);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Contest Details",
      appBarTrailing: Row(
        children: [
          const Gap(20),
          ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: WayaImage(
              imageUrl: model?.uploadCoverImages ?? "",
              height: 45,
              width: 45,

              fit: BoxFit.cover, // Ensures the image covers the area properly
            ),
          ),
          const Gap(30),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(model?.title ?? "Title",
                      style: wayaTheme.textTheme.titleLarge),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xffE7F6EC), // Background color
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 1),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: Text(
                            "Live",
                            style: TextStyle(
                                color: Color(0xff036B26), fontSize: 12.sp),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(15),
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(16), // Adjust the radius as needed
                child: model?.uploadCoverImages == null
                    ? Image.asset(
                        'assets/images/frameuni.png',
                        height: 200,
                        fit: BoxFit
                            .cover, // Ensures the image covers the area properly
                      )
                    : WayaImage(
                        imageUrl: model?.uploadCoverImages ?? "",
                        width: context.width,
                        height: 200,
                        fit: BoxFit
                            .cover, // Ensures the image covers the area properly
                      ),
              ),
              const Gap(15),
              Text("Contest Description",
                  style: wayaTheme.textTheme.bodyMedium),
              const Gap(5),
              Text(model?.description ?? "Description",
                  style: WayaTextStyles.hintStyleBold.wayaCopyWith(
                      color: WayaColors.greyColor500,
                      fontWeight: FontWeight.w400)),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UpcomingWidgetAdmin(
                      title: "Start Date",
                      content: formatDate(model?.startDate)),
                  const Gap(20),
                  UpcomingWidgetAdmin(
                      title: "End Date", content: formatDate(model?.endDate)),
                  const Gap(20),
                  UpcomingWidgetAdmin(
                      title: "Entry Type", content: model?.entryType ?? ""),
                  const Gap(20),
                  UpcomingWidgetAdmin(
                      title: "Duration",
                      content: getRealDateDiffBtwDate(
                          model?.startDate ?? "2025-03-03T07:21:39.036Z",
                          model?.endDate ?? "2025-03-03T07:21:39.036Z")),
                ],
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UpcomingWidgetAdmin(
                      title: "Multiple Stages",
                      content: model?.multipleStages ?? ""),
                  const Gap(20),
                  UpcomingWidgetAdmin(
                      title: "Category", content: model?.categoryName ?? ""),
                  const Gap(20),
                  UpcomingWidgetAdmin(
                      title: "Prize",
                      content:
                          "₦${formatMoney(model?.winnerPrize?.replaceAll("\$", "") ?? "0")}"),
                  const Gap(20),
                  UpcomingWidgetAdmin(title: "Host", content: "Host"),
                ],
              ),
              const Gap(20),
              if (viewModelNotifier.getLoggedInUserId() == model?.profileId)
                WayaButton(
                  callback: () {
                    WayaNav.toNamed('/contest-mydashboard-profile-page');
                  },
                  color: wayaTheme.colorScheme.primary50,
                  text: "View Contest Dashboard",
                  textColor: wayaTheme.colorScheme.customPrimary,
                ),
              /*  Text("View Full Details",
                  style: wayaTheme.textTheme.bodyMedium
                      ?.wayaCopyWith(color: wayaTheme.colorScheme.primary500)),
              const Gap(15), */
              const Gap(15),
              Text("Top Contestants",
                  style: wayaTheme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const Gap(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (viewModel.myContestList.length >= 2)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref.read(selectedContestantProfile.notifier).state =
                              viewModel.myContestList[1];
                          viewModelNotifier.updateContestId(model?.id);
                          ref.read(selectedContestProvider.notifier).state =
                              model;
                          WayaNav.toNamed(
                            '/contest-profile-page',
                          );
                        },
                        child: AdminCard(
                          imageUrl: viewModel.myContestList[1].profilePhoto ??
                              "", // Change to your image path
                          rank: "2",
                          name: viewModel.myContestList[1].contestApplicant
                                  ?.fullName ??
                              "",
                          votes: "${viewModel.myContestList[1].votes} Votes",
                        ),
                      ),
                    ),
                  if (viewModel.myContestList.isNotEmpty)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref.read(selectedContestantProfile.notifier).state =
                              viewModel.myContestList[0];
                          ref.read(selectedContestProvider.notifier).state =
                              model;
                          WayaNav.toNamed(
                            '/contest-profile-page',
                          );
                        },
                        child: AdminCard(
                          imageUrl: viewModel.myContestList[0].profilePhoto ??
                              "", // Change to your image path
                          rank: "1",
                          isCenter: true,
                          radius: 40,
                          name: viewModel.myContestList[0].contestApplicant
                                  ?.fullName ??
                              "",
                          votes: "${viewModel.myContestList[0].votes} Votes",
                        ),
                      ),
                    ),
                  if (viewModel.myContestList.length >= 3)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref.read(selectedContestantProfile.notifier).state =
                              viewModel.myContestList[2];
                          ref.read(selectedContestProvider.notifier).state =
                              model;
                          WayaNav.toNamed(
                            '/contest-profile-page',
                          );
                        },
                        child: AdminCard(
                          imageUrl:
                              viewModel.myContestList[2].profilePhoto ?? "",
                          rank: "3",
                          name: viewModel.myContestList[2].contestApplicant
                                  ?.fullName ??
                              "",
                          votes: "${viewModel.myContestList[2].votes} Votes",
                        ),
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  WayaTabButton(
                    isSelected: selectedViewIndex.value == 0,
                    isLongerTab: true,
                    text: 'Posts',
                    onTap: () => selectedViewIndex.value = 0,
                  ),
                  WayaTabButton(
                    isSelected: selectedViewIndex.value == 1,
                    isLongerTab: true,
                    text: 'Leaderboard',
                    onTap: () => selectedViewIndex.value = 1,
                  ),
                  WayaTabButton(
                    isSelected: selectedViewIndex.value == 2,
                    isLongerTab: true,
                    text: 'Contestants',
                    onTap: () => selectedViewIndex.value = 2,
                  ),
                  /*  WayaTabButton(
                    isSelected: selectedViewIndex.value == 3,
                    isLongerTab: true,
                    text: 'Gallery',
                    onTap: () => selectedViewIndex.value = 3,
                  ), */
                ],
              ),
              const Gap(10),
              if (selectedViewIndex.value == 0) UgtPostAllContestant(model),
              if (selectedViewIndex.value == 1) UgtDetailsLeaderboard(model),
              if (selectedViewIndex.value == 2) UgtDetailsContestants(model),
              //  if (selectedViewIndex.value == 3) UgtDetailsGallery(model),
            ],
          ),
        ),
      ),
      floatingActionButton: viewModel.createPostId.trim().isNotEmpty
          ? SizedBox(
              height: 50,
              width: 50,
              child: WayaButton(
                callback: () {
                  viewModelNotifier.updateContestId(model?.id);
                  WayaNav.toNamed('/create-contest-post');
                },
                height: 50,
                centerWidget: Center(
                  child: Icon(
                    Icons.add,
                    color: wayaTheme.colorScheme.white,
                    size: 40,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  InkWell _buildActionNav(
      {required BuildContext context,
      required VoidCallback onTap,
      required Widget asset,
      required String text,
      required Color color}) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          asset,
          const Gap(4),
          Text(
            text,
            style: TextStyle().wayaCopyWith(
                color: color, fontWeight: FontWeight.w500, fontSize: 12.sp),
          )
        ],
      ),
    );
  }

  Color getColor(bool isText, String text) {
    return isText ? Color(0xff9E0A05) : Color(0xffFEF6E7);
    /*  } else if (text == "rejected") {
      return isText ? Color(0xff9E0A05) : Color(0xffFBEAE9);
    } else {
      return isText ? Color(0xff865503) : Color(0xffFEF6E7);
    } */
  }
}

class UpcomingWidgetAdmin extends StatelessWidget {
  final String title;
  final String content;
  final bool status;
  final bool isFromDetailsPage;
  const UpcomingWidgetAdmin({
    super.key,
    required this.title,
    required this.content,
    this.status = false,
    this.isFromDetailsPage = false,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: context.width * 0.18,
          child: Text(title,
              style: WayaTextStyles.hintStyleBold.wayaCopyWith(
                  color: WayaColors.greyColor500, fontWeight: FontWeight.w400)),
        ),
        const Gap(5),
        if (!status)
          SizedBox(
            width: context.width * 0.18,
            child: Text(content,
                // overflow: TextOverflow.ellipsis,
                style: WayaTextStyles.bodySmall),
          ),
        if (status)
          Container(
            decoration: BoxDecoration(
              color: getColor(false, content.toLowerCase()), // Background color
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  content,
                  style: WayaTextStyles.bodySmall.copyWith(
                    color: getColor(true, content.toLowerCase()),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Color getColor(bool isText, String text) {
    if (text == "pending") {
      return isText ? Color(0xff865503) : Color(0xffFEF6E7);
    } else if (text == "rejected") {
      return isText ? Color(0xff9E0A05) : Color(0xffFBEAE9);
    } else {
      return isText ? Color(0xff036B26) : Color(0xffE7F6EC);
    }
  }
}
