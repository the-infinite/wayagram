import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';

class SingleGroupWidget extends StatelessWidget {
  final GroupModel group;
  final int index;

  // Construct.
  const SingleGroupWidget({
    super.key,
    required this.group,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    // Build and return our component.
    return InkWell(
      splashColor: wayaTheme.colorScheme.primary.withAlpha(30),
      focusColor: const Color.fromARGB(255, 179, 173, 170).withAlpha(30),
      highlightColor: wayaTheme.colorScheme.primary.withAlpha(30),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: wayaTheme.colorScheme.greyColor200,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.only(left: 0, right: 0),
              leading: CircleAvatar(
                radius: 40,
                backgroundColor: wayaTheme.colorScheme.greyColor100,
                backgroundImage: NetworkImage(group.profileImage ?? ""),
              ),
              title: Row(
                children: [
                  Text(
                    group.name,
                    style: wayaTheme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: wayaTheme.colorScheme.black,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                "${WayaValueHelper.formatNumber(group.memberCount)} members",
                style: wayaTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: wayaTheme.colorScheme.greyColor500,
                ),
              ),
            ),

            // Space.
            const Gap(10),

            // Finally, the group's description.
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                group.description,
                style: wayaTheme.textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: wayaTheme.colorScheme.greyColor500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
