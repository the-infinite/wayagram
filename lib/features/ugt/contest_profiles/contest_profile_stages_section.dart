import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_leaderboard_card.dart';
import 'package:wayagram/features/ugt/contest_profiles/contest_profile_page.dart';
import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';

import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';
import 'package:wayagram/features/ugt/ugt_buttomsheet_modal/successful_modal.dart';
import 'package:wayagram/features/ugt/widgets/status_ongoing.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';
import 'package:wayagram/features/ugt/widgets/upcoming_widgets/upcoming_widget.dart';

class ContestProfileStagesSection extends StatefulHookConsumerWidget {
  final List<Stage>? stages;
  const ContestProfileStagesSection(this.stages, {super.key});

  @override
  _ContestProfileStagesSectionState createState() =>
      _ContestProfileStagesSectionState();
}

class _ContestProfileStagesSectionState
    extends ConsumerState<ContestProfileStagesSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    print("i am looping  wewe ${widget.stages?.length}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final posts = ref.watch(postProvider);

    final wayaTheme = Theme.of(context);

    // final postNotifier = ref.read(postProvider.notifier);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widget.stages!.map((e) => _buildStages(e)),
      ],
    );
  }

  Widget _buildStages(Stage model) {
    final wayaTheme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(model.stageName ?? "",
              style: TextStyle().wayaCopyWith(
                color: Colors.black,
                fontSize: 16,
              )),
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UpcomingWidget(
                    title: "Start Date",
                    isFromDetailsPage: true,
                    content: formatDate(model.startDate ?? "")),
                const Gap(20),
                UpcomingWidget(
                    isFromDetailsPage: true,
                    title: "Position",
                    content: model.position?.toString() == "0"
                        ? "No Position"
                        : model.position?.toString() ?? ""),
              ],
            ),
            //  const Gap(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UpcomingWidget(
                    isFromDetailsPage: true,
                    title: "End Date",
                    content: formatDate(model.endDate ?? "")),
                const Gap(20),
                UpcomingWidget(
                    isFromDetailsPage: true,
                    title: "Prize for Winner",
                    content:
                        "NGN${formatMoney(model.amountEarned.toString())}"),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UpcomingWidget(
                    isFromDetailsPage: true,
                    title: "Entry Type",
                    content: model.entryType ?? ""),
                const Gap(20),
                StatusOngoing(
                  title: "Qualification Status",
                  content: "Qualified",
                ),
              ],
            ),
          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
        const Gap(20),
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
