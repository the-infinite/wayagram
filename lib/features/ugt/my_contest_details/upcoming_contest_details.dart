import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import 'package:wayagram/features/ugt/widgets/contest_card.dart';
import 'package:wayagram/features/ugt/widgets/upcoming_widgets/upcoming_widget.dart';

import '../../../core/components/waya_scaffold.dart';
import '../widgets/about_ugt_widget.dart';
import '../widgets/status_ongoing.dart';

class UpcomingContestDetails extends StatefulHookConsumerWidget {
  static const route = '/upcoming-contest-details';
  const UpcomingContestDetails({super.key});

  @override
  ConsumerState<UpcomingContestDetails> createState() =>
      _UpcomingContestDetailsState();
}

class _UpcomingContestDetailsState
    extends ConsumerState<UpcomingContestDetails> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    var model = ref.watch(selectedContestProvider.notifier).state;
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Contest Details",
      appBarTrailing: Row(
        children: [
          Image.asset("assets/images/Icon-left.png"),
          const Gap(20),
          Image.asset("assets/images/vector.png"),
          const Gap(30),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(model.title ?? "Title",
                      style: wayaTheme.textTheme.titleLarge),
                  Container(
                    decoration: BoxDecoration(
                      color: getColor(
                          false,
                          model.status?.toLowerCase() ??
                              ""), // Background color
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: Text(
                          model.status ?? "",
                          style: TextStyle(
                              color: getColor(
                                  true, model.status?.toLowerCase() ?? ""),
                              fontSize: 10),
                          textAlign: TextAlign.center,
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
              Text("How it Works", style: wayaTheme.textTheme.bodyMedium),
              const Gap(15),
              Text(model.howItWorks ?? "",
                  style: wayaTheme.textTheme.hintStyle),
              const Gap(15),
              Text(
                "Stages",
                style: wayaTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 8),
              ...model.contestSettings!.stages!.map((e) => _buildStages(e)),
              /*   SizedBox(height: 8),
              _buildStagesContestLevel1(), */
              /*   SizedBox(height: 8),
              _buildStagesContestLevel2(),
              SizedBox(height: 8),
              _buildStagesContestLevel3(),
              SizedBox(height: 8),
              _buildStagesContestFinal(),
              SizedBox(height: 16), */
              Center(
                child: WayaButton(
                  callback: () {
                    ivalidateUGTVM(ref);
                    WayaNav.toNamed('/register-contest1');
                  },
                  text: "Register For Contest",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getColor(bool isText, String text) {
    if (text == "active") {
      return isText ? Color(0xff036B26) : Color(0xffE7F6EC);
    } else if (text == "rejected") {
      return isText ? Color(0xff9E0A05) : Color(0xffFBEAE9);
    } else {
      return isText ? Color(0xff865503) : Color(0xffFEF6E7);
    }
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
