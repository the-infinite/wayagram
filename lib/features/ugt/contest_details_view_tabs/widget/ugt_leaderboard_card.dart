import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/my_contest_details/voters_list_page.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';

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
    final notifier = ref.read(votersContestNotifier.notifier);

    bool isUserLoggedIn =
        contestantData.profileId == notifier.getLoggedInUserId();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isUserLoggedIn
            ? wayaTheme.primaryColor
            : Colors.transparent, // Background color
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () {},
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            leading: Text(
              "$position",
              overflow: TextOverflow.ellipsis,
              style: wayaTheme.textTheme.bodyMedium!.copyWith(
                  color: isUserLoggedIn
                      ? Colors.white
                      : wayaTheme.colorScheme.black),
            ),
            title: Row(
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

                    /*    Image.network(
                    contestantData.profilePhoto ?? "",
                    height: 45,
                    width: 45,
                    fit: BoxFit
                        .cover, // Ensures the image covers the area properly
                  ), */
                    ),
                Gap(10),
                SizedBox(
                  width: context.width * 0.40,
                  child: Text(
                    contestantData.contestApplicant?.fullName ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: wayaTheme.textTheme.bodyMedium!.copyWith(
                        color: isUserLoggedIn
                            ? Colors.white
                            : wayaTheme.colorScheme.black),
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${contestantData.votes} Votes',
                  style: wayaTheme.textTheme.hintStyle.copyWith(
                      color: isUserLoggedIn
                          ? Colors.white
                          : wayaTheme.colorScheme.greyColor400),
                ),
                Gap(10),
                WayaButton(
                  callback: () {
                    ref.read(selectedContestantProfile.notifier).state =
                        contestantData;
                    WayaNav.toNamed(VotersListPage.route);
                  },
                  height: 30,
                  text: 'View',
                  textStyle: WayaTextStyles.bodySmall.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.white),
                )
              ],
            ),
          ),
          // const Gap(10)
        ],
      ),
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
