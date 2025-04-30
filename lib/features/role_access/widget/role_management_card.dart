import 'package:flutter/material.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/role_access/data/model/role_management_model.dart';

class RoleManagementCard extends StatelessWidget {
  final RoleManagementModel user;
  final bool showImage;

  // Construct.
  const RoleManagementCard({
    super.key,
    required this.user,
    this.showImage = true,
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

            // Name and Role
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.roleName ?? "",
                    style: WayaTextStyles.bodyBold,
                  ),
                  if (user.roleName == "me")
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: user.roleName != null ? Colors.green[100] : Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          WayaAssets.icons.crown.svg(),
                          SizedBox(width: 4),
                          Text(
                            user.roleName ?? "",
                            style:
                                WayaTextStyles.hintStyleBold.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  else
                    Text(
                      "Total Members: ${user.userCount}",
                      style: WayaTextStyles.hintStyleBold.wayaCopyWith(color: wayaTheme.colorScheme.greyColor700),
                    ),
                ],
              ),
            ),
            // Status Badge

            /*  Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 30,
            ), */
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
