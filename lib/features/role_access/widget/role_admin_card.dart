import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/theme.dart';

class RoleAdminCard extends StatelessWidget {
  const RoleAdminCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // bool isCurrentUser = user["isCurrentUser"] ?? false;
    // final wayaTheme = Theme.of(context);
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
            if (true)
              CircleAvatar(
                backgroundColor: Colors.pink[100],
                radius: 20,
                child: Text(
                  getInitials("You"),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            SizedBox(width: 12),
            // Name and Role
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You",
                    style: WayaTextStyles.bodyBold,
                  ),
                  //  if (tru)
                  Gap(5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        WayaAssets.icons.crown.svg(),
                        SizedBox(width: 4),
                        Text(
                          "Super Admin",
                          style: WayaTextStyles.hintStyleBold.copyWith(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                  /*   else
                    Text(
                      "",
                      style: WayaTextStyles.hintStyleBold.wayaCopyWith(
                          color: wayaTheme.colorScheme.greyColor700),
                    ), */
                ],
              ),
            ),
            // Status Badge
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
