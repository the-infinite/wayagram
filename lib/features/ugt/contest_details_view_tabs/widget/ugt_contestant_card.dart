import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:wayagram/core/components/components.dart';

import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/waya_utils.dart';

import '../../vote/contest_vote_modal.dart';

class UgtContestantCard extends ConsumerWidget {
  const UgtContestantCard({super.key});

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
            "4",
            overflow: TextOverflow.ellipsis,
            style: wayaTheme.textTheme.bodyMedium,
          ),
          title: Row(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(45), // Adjust the radius as needed
                child: Image.asset(
                  'assets/images/frameuni.png',
                  height: 45,
                  width: 45,
                  fit: BoxFit
                      .cover, // Ensures the image covers the area properly
                ),
              ),
              Gap(10),
              Text(
                "Rufai Maleek",
                overflow: TextOverflow.ellipsis,
                style: wayaTheme.textTheme.bodyMedium,
              ),
            ],
          ),
          trailing: SizedBox(
            width: 100,
            child: WayaButton(
              fontSize: 14,
              color: WayaColors.primary50,
              textColor: WayaColors.primary500,
              callback: () {
                //VoteSuccessModal
                //ConfirmVoteOptionModal
                //VoteOptionModal
                //PollsModal
                WayaUtils.showModalSheet(
                  context,
                  child: VoteOptionModal(
                    voteFee: "89",
                    //   amountPaid: "89",
                    choiceId: "6",
                    pollId: "6",
                    candidateName: "candidateName",
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
