import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:wayagram/core/components/components.dart';

import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';
import 'package:wayagram/features/ugt/data/model/contest_vote_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/ugt_buttomsheet_modal/contest_vote_modal.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';

class UgtContestantCard extends ConsumerWidget {
  final Contest model;
  final MyContestContestantModel contestantData;
  final int position;
  const UgtContestantCard(this.model, this.contestantData, this.position,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
          leading: Text(
            "$position",
            overflow: TextOverflow.ellipsis,
            style: wayaTheme.textTheme.bodyMedium,
          ),
          title: GestureDetector(
            onTap: () {
              ref.read(selectedContestantProfile.notifier).state =
                  contestantData;
              ref.read(selectedContestProvider.notifier).state = model;
              WayaNav.toNamed(
                '/contest-profile-page',
              );
            },
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(
                        45), // Adjust the radius as needed
                    child: WayaImage(
                      imageUrl: contestantData.profilePhoto ?? "",
                      height: 45,
                      width: 45,
                      fit: BoxFit.cover,
                      radius: BorderRadius.circular(45),
                    )

                    /*   Image.network(
                    contestantData.profilePhoto ?? "",
                    height: 45,
                    width: 45,
                    fit: BoxFit
                        .cover, // Ensures the image covers the area properly
                  ), */
                    ),
                Gap(10),
                Text(
                  contestantData.contestApplicant?.fullName ?? "Name",
                  overflow: TextOverflow.ellipsis,
                  style: wayaTheme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          trailing: SizedBox(
            width: 100,
            child: WayaButton(
              fontSize: 14.sp,
              color: WayaColors.primary50,
              textColor: WayaColors.primary500,
              callback: () {
                if (isPresentIsPast(model.endDate ?? "")) {
                  WayaSnackBar.showToast("Contest has ended");
                  return;
                }

                if (model.amountPerVote == 0) {
                  WayaUtils.showModalSheet(
                    context,
                    child: ConfirmVoteOptionModal(
                      amount: "1",
                      voteFee: "0",
                      isFree: true,
                      model: ContestVoteModel(
                          contestId: contestantData.contestId ?? "",
                          contestantId: contestantData.id ?? "",
                          hostUserId: contestantData.profileId ?? "",
                          amount: "0",
                          numberOfVotes: "0",
                          profileId: "",
                          type: model.entryType?.toLowerCase()),
                      candidateName:
                          contestantData.contestApplicant?.fullName ?? "Name",
                      votingLink: "votingLink",
                    ),
                  );

                  return;
                }

               
                WayaUtils.showModalSheet(
                  context,
                  child: VoteOptionModal(
                    voteFee: model.amountPerVote?.toString() ?? "0",
                    isFree:
                        model.entryType?.toLowerCase() == "free" ? true : false,
                    //   amountPaid: "89",
                    model: ContestVoteModel(
                        contestId: contestantData.contestId ?? "",
                        contestantId: contestantData.id ?? "",
                        hostUserId: contestantData.profileId ?? "",
                        amount: "0",
                        numberOfVotes: "0",
                        profileId: "",
                        type: model.entryType?.toLowerCase()),

                    candidateName:
                        contestantData.contestApplicant?.fullName ?? "Name",
                    votingLink: "votingLink",
                  ),
                );
              },
              text: "Vote",
            ),
          ),
        ),
        // const Gap(10)
      ],
    );
  }
}

String formatDate(String isoDate) {
  DateTime date = DateTime.parse(isoDate);
  String day = DateFormat('d').format(date);
  String suffix = getDaySuffix(int.parse(day));
  String month = DateFormat('MMM').format(date);
  String year = DateFormat('y').format(date);
  return "$day$suffix $month $year";
}

String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return "th";
  }
  switch (day % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
}
