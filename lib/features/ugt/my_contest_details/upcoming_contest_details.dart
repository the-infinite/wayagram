import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
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
    var viewModel = ref.watch(votersContestNotifier.notifier);
    final hasProfile = useState(false);

    useEffect(() {
      ref
          .read(postProvider.notifier)
          .fetchSingleContestantDetails(
              model?.id ?? "", viewModel.getLoggedInUserId())
          .then((model) {
        if (model != null) {
          print("i am here");
          if (model.data?.totalDocs == 1) {
            print("i am here 2");
            if (model.data?.docs?.first.profilePhoto != null &&
                model.data?.docs?.first.bio != null) {
              print("i am here 3");
              hasProfile.value = true;
            }
          }
        }
      });
      return null;
    }, []);

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
                  Text(model?.title ?? "Title",
                      style: wayaTheme.textTheme.titleLarge),
                  Container(
                    decoration: BoxDecoration(
                      color: getColor(
                          false,
                          model?.status?.toLowerCase() ??
                              ""), // Background color
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: Text(
                          model?.status ?? "",
                          style: TextStyle(
                              color: getColor(
                                  true, model?.status?.toLowerCase() ?? ""),
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
                child: model?.uploadCoverImages == null
                    ? Image.asset(
                        'assets/images/frameuni.png',
                        width: context.width,
                        height: 200,
                        fit: BoxFit
                            .cover, // Ensures the image covers the area properly
                      )
                    : Image.network(
                        model?.uploadCoverImages ?? "",
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
                  AboutUgtWidget(
                      title: "Start Date",
                      content: formatDate(model?.startDate ?? "")),
                  const Gap(20),
                  AboutUgtWidget(
                      title: "End Date",
                      content: formatDate(model?.endDate ?? "")),
                  const Gap(20),
                  AboutUgtWidget(
                      title: "Entry Type", content: model?.entryType ?? ""),
                  /*  const Gap(20),
                  UpcomingWidget(
                      title: "Duration",
                      content: getRealDateDiffBtwDate(
                          model.startDate ?? "", model.endDate ?? "")), */
                ],
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AboutUgtWidget(
                      title: "Total Stages",
                      content: model?.multipleStages ?? ""),
                  const Gap(20),
                  AboutUgtWidget(
                      title: "Category", content: model?.categoryName ?? ""),
                  const Gap(20),
                  AboutUgtWidget(
                      title: "Prize",
                      content: "NGN${formatMoney(model?.winnerPrize ?? "")}"),
                  /*   const Gap(20),
                  UpcomingWidget(title: "Host", content: "Host"), */
                ],
              ),
              const Gap(20),
              Text("How it Works", style: wayaTheme.textTheme.bodyMedium),
              const Gap(15),
              Text(model?.howItWorks ?? "",
                  style: WayaTextStyles.hintStyleBold.wayaCopyWith(
                      color: WayaColors.greyColor500,
                      fontWeight: FontWeight.w400)),
              const Gap(15),
              Text(
                "Stages",
                style: wayaTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 8),
              ...model?.contestSettings!.stages!.map((e) => _buildStages(e)) ??
                  [],
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
                    //? if user has a profile
                    if (hasProfile.value) {
                      ref.read(selectedContestProvider.notifier).state = model;
                      WayaNav.toNamed('/upcoming-manage-contest-details');
                      return;
                    }
                    ivalidateUGTVM(ref);
                    WayaNav.toNamed('/register-contest1');
                  },
                  text: hasProfile.value
                      ? "View Contest Details"
                      : "Register For Contest",
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

  Widget _buildStages(Stage model) {
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
            AboutUgtWidget(
                title: "Start Date",
                //  isFromDetailsPage: true,
                content: formatDate(model.startDate ?? "")),
            const Gap(20),
            AboutUgtWidget(
                //isFromDetailsPage: true,
                title: "End Date",
                content: formatDate(model.endDate ?? "")),
            const Gap(20),
            AboutUgtWidget(
                // isFromDetailsPage: true,
                title: "Entry Type",
                content: model.entryType ?? ""),
          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AboutUgtWidget(
                // isFromDetailsPage: true,
                title: "No of Posts",
                content: "${model.numberOfPostPerWeek?.toString()}"),
            const Gap(20),
            AboutUgtWidget(
                // isFromDetailsPage: true,
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
  /*  final oCcy = NumberFormat("#,##0.00", "en_US");
  return oCcy.format(double.parse(value)); */
  final formatter =
      NumberFormat('#,##0.00'); // Formats with commas and decimals
  double amount = double.parse(value);
  if (amount >= 1e9) {
    return '${(amount / 1e9).toStringAsFixed(1)}B';
  } else if (amount >= 1e6) {
    return '${(amount / 1e6).toStringAsFixed(1)}M';
  } else {
    return formatter.format(amount); // Adds commas and two decimal places
  }
}
