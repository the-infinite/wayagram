import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';

class UgtLeaderboardCard extends ConsumerWidget {
  final Contest model;
  final MyContestContestantModel contestantData;
  final int position;
  const UgtLeaderboardCard(
      {required this.model,
      required this.contestantData,
      required this.position,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () {},
          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
          leading: Text(
            "$position",
            overflow: TextOverflow.ellipsis,
            style: wayaTheme.textTheme.bodyMedium,
          ),
          title: Row(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(45), // Adjust the radius as needed
                child: Image.network(
                  contestantData.profilePhoto ?? "",
                  height: 45,
                  width: 45,
                  fit: BoxFit
                      .cover, // Ensures the image covers the area properly
                ),
              ),
              Gap(10),
              Text(
                contestantData.contestApplicant?.fullName ?? "",
                overflow: TextOverflow.ellipsis,
                style: wayaTheme.textTheme.bodyMedium,
              ),
            ],
          ),
          trailing: Text(
            '${contestantData.votes} Votes',
            style: wayaTheme.textTheme.hintStyle,
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
