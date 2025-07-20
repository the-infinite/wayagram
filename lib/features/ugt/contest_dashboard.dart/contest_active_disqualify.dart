import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';

import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

import '../../../core/components/waya_scaffold.dart';

class ContestActiveDisqualify extends StatefulHookConsumerWidget {
  static const route = '/contest-active-disqualify';
  const ContestActiveDisqualify({super.key});

  @override
  ConsumerState<ContestActiveDisqualify> createState() =>
      _ManageStateContestState();
}

class _ManageStateContestState extends ConsumerState<ContestActiveDisqualify> {
  final List<Map<String, String>> data = [
    {
      "name": "Ademola Lookman",
      "state": "Ogun",
      "votes": "25",
      "status": "Inactive"
    },
    {
      "name": "Ademola Lookman",
      "state": "Osun",
      "votes": "25",
      "status": "Active"
    },
    {
      "name": "Ademola Lookman",
      "state": "Oyo",
      "votes": "25",
      "status": "Active"
    },
    {
      "name": "Ademola Lookman",
      "state": "Ondo",
      "votes": "25",
      "status": "Inactive"
    },
    {
      "name": "Ademola Lookman",
      "state": "Lagos",
      "votes": "25",
      "status": "Active"
    },
    {
      "name": "Ademola Lookman",
      "state": "Lagos",
      "votes": "25",
      "status": "Active"
    },
    {
      "name": "Ademola Lookman",
      "state": "Lagos",
      "votes": "25",
      "status": "Active"
    },
    {
      "name": "Ademola Lookman",
      "state": "Lagos",
      "votes": "25",
      "status": "Active"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    final viewModel = ref.watch(votersContestNotifier);
    final notifier = ref.watch(votersContestNotifier.notifier);
    var model = ref.watch(selectedContestProvider);

    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Manage Contestant",
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: viewModel.myFullContestantList.isEmpty
            ? emptyWidget()
            : DataTable(
                columnSpacing: 20.0,
                dividerThickness: 0.2,
                headingRowColor:
                    WidgetStateColor.resolveWith((states) => Colors.white),
                columns: [
                  DataColumn(
                      label: Text("Name",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("No.",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("No of Votes",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Status",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Current Stage",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Action",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: viewModel.myFullContestantList.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(item.contestApplicant?.fullName ?? "")),
                    DataCell(Text(item.contestApplicant?.phoneNumber ?? "")),
                    DataCell(Text(item.votes.toString())),
                    DataCell(
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: item.status?.toLowerCase() == "active"
                              ? Colors.green[100]
                              : Colors.red[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.status ?? "",
                          style: TextStyle(
                            color: item.status?.toLowerCase() == "active"
                                ? Colors.green
                                : Theme.of(context).colorScheme.error700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(getUserCurrentStage(item))),
                    DataCell(
                      PopupMenuButton(
                        onSelected: (value) {},
                        position: PopupMenuPosition.under,
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem<int>(
                              value: 0,
                              child: _buildActionNav(
                                  context: context,
                                  onTap: () {
                                    WayaNav.goBack();
                                    WayaNav.toNamed(
                                        '/contest-mydashboard-profile-page');
                                  },
                                  asset: WayaAssets.icons.cProfileUser.svg(
                                    colorFilter: ColorFilter.mode(
                                      wayaTheme.colorScheme.customBlack,
                                      BlendMode.srcIn,
                                    ),
                                    height: 20,
                                  ),
                                  text: "View Profile",
                                  color: wayaTheme.colorScheme.customBlack),
                            ),
                            PopupMenuItem<int>(
                              value: 1,
                              child: _buildActionNav(
                                  context: context,
                                  onTap: () {
                                    WayaNav.goBack();
                                    ref
                                        .read(
                                            selectedContestantProfile.notifier)
                                        .state = item;
                                    ref
                                        .read(selectedContestProvider.notifier)
                                        .state = model;
                                    WayaNav.toNamed(
                                      '/contest-profile-page',
                                      arguments: {
                                        "id": item.profileId ?? "",
                                        "contest": model?.id ?? "",
                                      },
                                    );
                                  },
                                  asset: WayaAssets.icons.mComments.svg(
                                    colorFilter: ColorFilter.mode(
                                      wayaTheme.colorScheme.customBlack,
                                      BlendMode.srcIn,
                                    ),
                                    height: 20,
                                  ),
                                  text: "Send Message",
                                  color: wayaTheme.colorScheme.customBlack),
                            ),
                            PopupMenuItem<int>(
                              value: 1,
                              child: _buildActionNav(
                                  context: context,
                                  onTap: () {
                                    WayaNav.goBack();
                                    // WayaNav.toNamed('/pages');
                                    notifier
                                        .qualifyDisqualify(model?.id ?? "", {
                                      "contestId": model?.id ?? "",
                                      "profileId": item.profileId ?? "",
                                      "status":
                                          item.status?.toLowerCase() == "active"
                                              ? "DISQUALIFIED"
                                              : "ACTIVE",
                                    });
                                  },
                                  asset: WayaAssets.images.pages.flag.svg(
                                    colorFilter: ColorFilter.mode(
                                      item.status?.toLowerCase() == "active"
                                          ? wayaTheme.colorScheme.primary
                                          : wayaTheme.colorScheme.error500,
                                      BlendMode.srcIn,
                                    ),
                                    height: 20,
                                  ),
                                  text: item.status?.toLowerCase() == "active"
                                      ? "Disqualify"
                                      : "Activate",
                                  color: item.status?.toLowerCase() == "active"
                                      ? wayaTheme.colorScheme.primary
                                      : wayaTheme.colorScheme.error500),
                            )
                          ];
                        },
                        child: Icon(Icons.more_vert),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
      ),
    );
  }

  String getUserCurrentStage(MyContestContestantModel myFullContestantList) {
    String currentUserStage = "None";
    for (var model in myFullContestantList.stages!) {
      if (model.hasAccepted == true) {
        currentUserStage = model.stageName ?? "";
        break;
      }
    }

    return currentUserStage;
  }
}

Widget emptyWidget() {
  return UgtEmptyState(
      icon: WayaAssets.images.uEmptystate.image(),
      desc: "There are not contestant yet",
      title: "No Contestant",
      buttonText: "Host a Contest",
      hideButton: true,
      onTap: () {});
}

InkWell _buildActionNav({
  required BuildContext context,
  required VoidCallback onTap,
  required Widget asset,
  required String text,
  required Color color,
}) {
  //final wayaTheme = Theme.of(context);
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
