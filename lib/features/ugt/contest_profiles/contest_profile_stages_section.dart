import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_leaderboard_card.dart';
import 'package:wayagram/features/ugt/contest_profiles/contest_profile_page.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';
import 'package:wayagram/features/ugt/widgets/upcoming_widgets/upcoming_widget.dart';

class ContestProfileStagesSection extends ConsumerStatefulWidget {
  final List<Stages>? stages;
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

  Widget _buildStages(Stages model) {
    final wayaTheme = Theme.of(context);
    return Column(
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
