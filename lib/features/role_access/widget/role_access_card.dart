import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/role_access/data/model/role_member.dart';

class RoleAccessCard extends StatelessWidget {
  final ShopMember user;
  final bool showImage;

  const RoleAccessCard({super.key, required this.user, this.showImage = true});

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
            if (showImage)
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
                    getInitials(user.email ?? "none"),
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
                    user.email ?? "",
                    style: WayaTextStyles.bodyBold,
                  ),
                  if (user.email == "me")
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: user.isActive == true
                            ? Colors.green[100]
                            : Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          WayaAssets.icons.crown.svg(),
                          SizedBox(width: 4),
                          Text(
                            user.email ?? "",
                            style: WayaTextStyles.hintStyleBold.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  else
                    Text(
                      user.roles!.isEmpty
                          ? ""
                          : user.roles?.first.roleName ?? "",
                      style: WayaTextStyles.hintStyleBold.wayaCopyWith(
                          color: wayaTheme.colorScheme.greyColor700),
                    ),
                ],
              ),
            ),
            // Status Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: user.isActive == true
                    ? Colors.green[100]
                    : Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(user.isActive == true ? "Active" : "Deactivated",
                  style: WayaTextStyles.hintStyleSemiBold.copyWith(
                      color: user.isActive == true
                          ? Colors.green[700]
                          : Colors.orange[700],
                      fontWeight: FontWeight.bold)),
            ),
            Gap(4),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  String getInitials(String name) {
    // List<String> names = name.split(" ");

    return name.substring(0, 1).toUpperCase();
  }
}
