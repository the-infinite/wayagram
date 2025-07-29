import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';
import 'package:wayagram/features/wallet/data/model/payout_history_model.dart';

class UgtPayoutHistoryCard extends ConsumerWidget {
  final PayoutHistoryModel model;
  final int position;
  final bool isPayout;

  // Construct.
  const UgtPayoutHistoryCard({
    required this.model,
    required this.position,
    required this.isPayout,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    //final notifier = ref.read(votersContestNotifier.notifier);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () {},
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            leading: CircleAvatar(
              radius: 20, // You can adjust the size
              backgroundColor:
                  wayaTheme.colorScheme.primary500, // Circle background color
              child: Center(
                child: Text(
                  model.accountName?.toUpperCase().substring(0, 1) ??
                      "PA", // Initial
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                const Gap(10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      model.accountName ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: wayaTheme.textTheme.bodyMedium!
                          .copyWith(color: wayaTheme.colorScheme.black),
                    ),
                    Text(
                      model.accountNumber ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: wayaTheme.textTheme.bodyMedium!
                          .copyWith(color: wayaTheme.colorScheme.black),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Amount       :₦${formatMoney(model.totalAmount?.toString() ?? '0')}",
                  style: wayaTheme.textTheme.hintStyle
                      .copyWith(color: wayaTheme.colorScheme.greyColor400),
                ),
                if (!isPayout)
                  Text(
                    "Commission :₦${formatMoney(model.commission?.toString() ?? '0')}",
                    style: wayaTheme.textTheme.hintStyle
                        .copyWith(color: wayaTheme.colorScheme.greyColor400),
                  ),
                if (isPayout)
                  Text(
                    "Status  : ${model.status?.toUpperCase() ?? 'N/A'}",
                    style: wayaTheme.textTheme.hintStyle
                        .copyWith(color: wayaTheme.colorScheme.greyColor400),
                  ),
              ],
            ),
          ),
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
