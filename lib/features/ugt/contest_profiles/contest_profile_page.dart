import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
// import 'package:get_thumbnail_video/index.dart';
// import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/ugt_details_contestants.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/ugt_details_gallery.dart.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/ugt_details_leaderboard.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/ugt_details_post.dart';
import 'package:wayagram/features/ugt/contest_profiles/contest_profile_stages_section.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';
import 'package:wayagram/features/ugt/video_player.dart';
import 'package:wayagram/features/ugt/vm/ugt_contestant_profile_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/features/ugt/widgets/admin_card.dart';
import 'package:wayagram/features/ugt/widgets/contest_card.dart';
import 'package:wayagram/features/ugt/widgets/upcoming_widgets/upcoming_widget.dart';

import '../../../core/components/waya_scaffold.dart';

class ContestProfilePage extends StatefulHookConsumerWidget {
  static const route = '/contest-profile-page';
  const ContestProfilePage({super.key});

  @override
  ConsumerState<ContestProfilePage> createState() => _ContestProfilePageState();
}

class _ContestProfilePageState extends ConsumerState<ContestProfilePage> {
  @override
  void initState() {
    // getImageUrl();
    super.initState();
  }

  Future<String> getImageUrl(String videoLink) async {
    return '';
    // XFile thumbnailFile = await VideoThumbnail.thumbnailFile(
    //   video: videoLink,
    //   thumbnailPath: (await getTemporaryDirectory()).path,
    //   imageFormat: ImageFormat.WEBP,
    //   maxHeight:
    //       200, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    //   quality: 70,
    // );
    //
    // return thumbnailFile.path;
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    //var model = ref.watch(selectedContestProvider.notifier).state;
    var model = ref.watch(selectedContestantProfile.notifier).state;
    print("profile id ${model?.id}");
    final imageUrl = useState(model!.profilePhoto ?? "");
    useEffect(() {
      ref
          .watch(ugtContestantProfileVm.notifier)
          .fetchSingleContestantPosts(model.id ?? "");

      getImageUrl(model.introVideo ?? "").then((value) {
        imageUrl.value = value;
      });
      return null;
    }, []);
    final selectedViewIndex = useState(0);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "My Profile",
      appBarTrailing: Row(
        children: [
          GestureDetector(
              onTap: () {
                WayaNav.toNamed('/contest-mydashboard-profile-page');
              },
              child: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none)),
          const Gap(20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Stack(
              clipBehavior: Clip.none,
              children: [
                VideoThumbnailPlayer(
                  imageUrl: imageUrl.value,
                  videoUrl: model.introVideo ?? "",
                ),
                Positioned(
                  bottom: -45,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor:
                          Colors.pink[100], // Background color behind image
                      backgroundImage: NetworkImage(model.profilePhoto ?? ""),
                    ),
                  ),
                ),
                Positioned(
                    bottom: -50,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(right: 20.w),
                        padding: REdgeInsets.symmetric(
                            vertical: 8.dg, horizontal: 12.dg),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: wayaTheme.colorScheme.primary600,
                            width: 1.5,
                          ),
                          color: wayaTheme.colorScheme.white,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Text(
                          'Edit Profile',
                          style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                            color: wayaTheme.colorScheme.primary600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ))
              ],
            ),
            const Gap(50),
            Text(model.contestApplicant?.fullName ?? "",
                style: wayaTheme.textTheme.bodyMedium),
            const Gap(5),
            Row(
              children: [
                Text("Total Votes:",
                    style: wayaTheme.textTheme.hintStyle
                        .wayaCopyWith(fontSize: 14)),
                const Gap(2),
                Text("${model.votes}",
                    style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                      color: WayaColors.primary,
                    )),
              ],
            ),
            Text("Your Bio", style: wayaTheme.textTheme.bodyMedium),
            Text(model.bio ?? "", style: wayaTheme.textTheme.hintStyle),
            const Gap(20),
            Text("what you expect from the voters",
                style: wayaTheme.textTheme.bodyMedium),
            Text(model.expectationFromVoters ?? "",
                style: wayaTheme.textTheme.hintStyle),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WayaTabButton(
                  isSelected: selectedViewIndex.value == 0,
                  text: 'Posts',
                  onTap: () => selectedViewIndex.value = 0,
                ),
                WayaTabButton(
                  isSelected: selectedViewIndex.value == 1,
                  text: 'Stages',
                  onTap: () => selectedViewIndex.value = 1,
                ),
              ],
            ),
            const Gap(10),
            if (selectedViewIndex.value == 0) UgtDetailsPost(model),
            if (selectedViewIndex.value == 1) ContestProfileStagesSection([]),
          ],
        ),
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

  Widget _buildStages(Stages model) {
    final wayaTheme = Theme.of(context);
    return ExpansionTile(
      shape: Border.all(color: Colors.transparent), // Removes default border
      collapsedShape: Border.all(color: Colors.transparent),
      title: Text(
        model.stageName ?? "name",
        style: wayaTheme.textTheme.bodyMedium,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(
                title: "Start Date",
                isFromDetailsPage: true,
                content: formatDate(model.startDate ?? "")),
            const Gap(20),
            UpcomingWidget(
                isFromDetailsPage: true,
                title: "End Date",
                content: formatDate(model.endDate ?? "")),
            const Gap(20),
            UpcomingWidget(
                isFromDetailsPage: true,
                title: "Entry Type",
                content: model.entryType ?? ""),
          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(
                isFromDetailsPage: true,
                title: "No of Posts",
                content:
                    "${model.numberOfPostPerWeek?.toString()} of Duration"),
            const Gap(20),
            UpcomingWidget(
                isFromDetailsPage: true,
                title: "Prize for Winner",
                content:
                    "NGN${formatMoney(model.priceOfTheWinner.toString())}"),
            const Gap(20),
          ],
        ),
        const Gap(20),
      ],
    );
  }

  Widget _buildStagesContestLevel1() {
    final wayaTheme = Theme.of(context);
    return ExpansionTile(
      title: Text(
        "Contest Level 1",
        style: wayaTheme.textTheme.bodyMedium,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "Start Date", content: "21st of July\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "End Date", content: "21st of Jul\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "Entry Type", content: "Free"),
          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "No of Posts", content: "6 Posts Per Week"),
            const Gap(20),
            UpcomingWidget(title: "Prize for Winner", content: "0 NGN"),
            const Gap(20),
            UpcomingWidget(title: "Entry Type", content: "Free"),
          ],
        ),
        const Gap(20),
      ],
    );
  }

  Widget _buildStagesContestLevel2() {
    final wayaTheme = Theme.of(context);
    return ExpansionTile(
      title: Text(
        "Contest Level 2",
        style: wayaTheme.textTheme.bodyMedium,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "Start Date", content: "21st of July\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "End Date", content: "21st of Jul\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "Entry Type", content: "Free"),
          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "No of Posts", content: "6 Posts Per Week"),
            const Gap(20),
            UpcomingWidget(title: "Prize for Winner", content: "0 NGN"),
            const Gap(20),
            UpcomingWidget(title: "Entry Type", content: "Free"),
          ],
        ),
        const Gap(20),
      ],
    );
  }

  Widget _buildStagesContestLevel3() {
    final wayaTheme = Theme.of(context);
    return ExpansionTile(
      title: Text(
        "Contest Level 3",
        style: wayaTheme.textTheme.bodyMedium,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "Start Date", content: "21st of July\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "End Date", content: "21st of Jul\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "Entry Type", content: "Free"),
          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "No of Posts", content: "6 Posts Per Week"),
            const Gap(20),
            UpcomingWidget(title: "Prize for Winner", content: "0 NGN"),
            const Gap(20),
            UpcomingWidget(title: "Entry Type", content: "Free"),
          ],
        ),
        const Gap(20),
      ],
    );
  }

  Widget _buildStagesContestFinal() {
    final wayaTheme = Theme.of(context);
    return ExpansionTile(
      title: Text(
        "Final Stage",
        style: wayaTheme.textTheme.bodyMedium,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "Start Date", content: "21st of July\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "End Date", content: "21st of Jul\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "Entry Type", content: "Free"),
          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "No of Posts", content: "6 Posts Per Week"),
            const Gap(20),
            UpcomingWidget(title: "Prize for Winner", content: "0 NGN"),
            const Gap(20),
            UpcomingWidget(title: "Entry Type", content: "Free"),
          ],
        ),
        const Gap(20),
      ],
    );
  }
}
