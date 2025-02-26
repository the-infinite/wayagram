import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/ugt_details_contestants.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/ugt_details_gallery.dart.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/ugt_details_leaderboard.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/ugt_details_post.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/for_you_contest.dart';
import 'package:wayagram/features/ugt/my_contest_details/my_contest_details.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/features/ugt/widgets/admin_card.dart';
import 'package:wayagram/features/ugt/widgets/contest_card.dart';
import 'package:wayagram/features/ugt/widgets/upcoming_widgets/upcoming_widget.dart';

import '../../../core/components/waya_scaffold.dart';
import '../widgets/about_ugt_widget.dart';
import '../widgets/status_ongoing.dart';

class AdminContestDetails extends StatefulHookConsumerWidget {
  static const route = '/upcoming-manage-contest-details';
  const AdminContestDetails({super.key});

  @override
  ConsumerState<AdminContestDetails> createState() =>
      _ManageContestDetailsState();
}

class _ManageContestDetailsState extends ConsumerState<AdminContestDetails> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    useEffect(() {
      ref.read(votersContestNotifier.notifier).getContestantProfileVoteDetails(
          ref.read(selectedContestProvider.notifier).state.id ?? "");
      return null;
    }, []);
    var model = ref.watch(selectedContestProvider.notifier).state;
    final selectedViewIndex = useState(0);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Contest Details",
      appBarTrailing: Row(
        children: [
          Image.asset("assets/images/vector.png"),
          const Gap(20),
          ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Image.network(
              model.uploadCoverImages ?? "",
              height: 45,
              width: 45,
              fit: BoxFit.cover, // Ensures the image covers the area properly
            ),
          ),
          const Gap(30),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: getColor(false,
                      "You have 5 images and 1 video uploads left today"), // Background color
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Text(
                        "You have 5 images and 1 video uploads left today",
                        style: TextStyle(
                            color: getColor(
                                true, model.status?.toLowerCase() ?? ""),
                            fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(model.title ?? "Title",
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
                                color: Color(0xff036B26), fontSize: 12),
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
                child: model.uploadCoverImages == null
                    ? Image.asset(
                        'assets/images/frameuni.png',
                        height: 200,
                        fit: BoxFit
                            .cover, // Ensures the image covers the area properly
                      )
                    : Image.network(
                        model.uploadCoverImages ?? "",
                        height: 200,
                        fit: BoxFit
                            .cover, // Ensures the image covers the area properly
                      ),
              ),
              const Gap(15),
              Text("Contest Description",
                  style: wayaTheme.textTheme.bodyMedium),
              const Gap(5),
              Text(model.description ?? "Description",
                  style: wayaTheme.textTheme.hintStyle),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UpcomingWidget(
                      title: "Start Date",
                      content: formatDate(model.startDate ?? "")),
                  const Gap(20),
                  UpcomingWidget(
                      title: "End Date",
                      content: formatDate(model.endDate ?? "")),
                  const Gap(20),
                  UpcomingWidget(
                      title: "Entry Type", content: model.entryType ?? ""),
                  const Gap(20),
                  UpcomingWidget(
                      title: "Duration", content: model.durationType ?? ""),
                ],
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UpcomingWidget(
                      title: "Total Stages",
                      content: model.multipleStages ?? ""),
                  const Gap(20),
                  UpcomingWidget(
                      title: "Category", content: model.categoryName ?? ""),
                  const Gap(20),
                  UpcomingWidget(
                      title: "Prize", content: model.winnerPrize ?? ""),
                  const Gap(20),
                  UpcomingWidget(title: "Host", content: "Host"),
                ],
              ),
              const Gap(20),
              Text("View Full Details",
                  style: wayaTheme.textTheme.bodyMedium
                      ?.wayaCopyWith(color: wayaTheme.colorScheme.primary500)),
              const Gap(15),
              Text("Top Contestants", style: wayaTheme.textTheme.bodyMedium),
              const Gap(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: AdminCard(
                      imageUrl: WayaAssets
                          .images.avatars.path, // Change to your image path
                      rank: "2",
                      name: "Oludase Busola",
                      votes: "59,450 Votes",
                    ),
                  ),
                  Expanded(
                    child: AdminCard(
                      imageUrl: WayaAssets
                          .images.avatars.path, // Change to your image path
                      rank: "2",
                      isCenter: true,
                      radius: 40,
                      name: "Oludase Busola",
                      votes: "59,450 Votes",
                    ),
                  ),
                  Expanded(
                    child: AdminCard(
                      imageUrl: WayaAssets.images.avatars.path,
                      rank: "2",
                      name: "Oludase Busola",
                      votes: "59,450 Votes",
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
                  WayaTabButton(
                    isSelected: selectedViewIndex.value == 3,
                    isLongerTab: true,
                    text: 'Gallery',
                    onTap: () => selectedViewIndex.value = 3,
                  ),
                ],
              ),
              const Gap(10),
              if (selectedViewIndex.value == 0) UgtDetailsPost(model),
              if (selectedViewIndex.value == 1) UgtDetailsLeaderboard(model),
              if (selectedViewIndex.value == 2) UgtDetailsContestants(model),
              if (selectedViewIndex.value == 3) UgtDetailsGallery(model),
            ],
          ),
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

String formatMoney(String value) {
  final oCcy = NumberFormat("#,##0.00", "en_US");
  return oCcy.format(double.parse(value));
}
