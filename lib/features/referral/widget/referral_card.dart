import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';

class ReferralCard extends StatelessWidget {
  const ReferralCard({
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
              child: /* user != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(user["image"]),
                        radius: 20,
                      )
                    : */
                  CircleAvatar(
                backgroundColor: wayaTheme.colorScheme.pending50,
                radius: 20,
                child: Text(
                  getInitials("Mango Man"),
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
                    "Mango Man",
                    style: WayaTextStyles.bodyBold,
                  ),
                  Text(
                    "Date Signed In: 12th Jul 2024",
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
    List<String> names = name.split(" ");
    String initials = names.length > 1
        ? names[0][0] + names[1][0] // First letter of first & last name
        : names[0][0]; // Only first letter if single name
    return initials.toUpperCase();
  }
}
