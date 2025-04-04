import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/referral/model/referral_model.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_contestant_card.dart';

class ReferralCard extends StatelessWidget {
  final ReferralModel model;
  const ReferralCard({
    required this.model,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // bool isCurrentUser = user["isCurrentUser"] ?? false;
    final wayaTheme = Theme.of(context);
    return Card(
      elevation: 0.2,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        //  padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Profile Avatar or Initials
            //  if (showImage)
            Container(
              child: model.referredUser?.avatar != null
                  ? CircleAvatar(
                      backgroundImage:
                          NetworkImage(model.referredUser?.avatar ?? ""),
                      radius: 20,
                    )
                  : CircleAvatar(
                      backgroundColor: wayaTheme.colorScheme.pending50,
                      radius: 20,
                      child: Text(
                        getInitials(model.referredUser?.displayName ?? ""),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
            ),
            SizedBox(width: 12),
            // Name and Role
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.referredUser?.displayName ?? "",
                    style: WayaTextStyles.bodyBold,
                  ),
                  Text(
                    "Date Signed In: ${convertToUsableDateNew(model.createdAt ?? "")}",
                    style: WayaTextStyles.hintStyleBold,
                  ),
                ],
              ),
            ),
            // Status Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: true ? Colors.green[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(true ? "Active" : "Deactivated",
                  style: WayaTextStyles.hintStyleSemiBold.copyWith(
                      color: true ? Colors.green[700] : Colors.orange[700],
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  String getInitials(String name) {
    return name[0].toUpperCase();
  }

  String convertToUsableDateNew(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);

    // Convert to the desired format
    String formattedDate = DateFormat("d MMM y").format(dateTime);

    // Add the ordinal suffix
    String day = DateFormat("d").format(dateTime);
    String suffix = getDaySuffix(int.parse(day));

    return "$day$suffix ${DateFormat("MMM y").format(dateTime)}";
  }
}
