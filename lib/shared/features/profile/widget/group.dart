import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';

class SingleGroupWidget extends StatefulWidget {
  final GroupModel group;
  final int index;

  // Construct.
  const SingleGroupWidget({
    super.key,
    required this.group,
    required this.index,
  });

  @override
  State<SingleGroupWidget> createState() => _SingleGroupWidgetState();
}

class _SingleGroupWidgetState extends State<SingleGroupWidget> {
  final loadingController = ValueNotifier(false);

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  Future<void> _joinGroup() async {}

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    // Build and return our component.
    return InkWell(
      splashColor: wayaTheme.colorScheme.primary.withAlpha(30),
      focusColor: const Color.fromARGB(255, 179, 173, 170).withAlpha(30),
      highlightColor: wayaTheme.colorScheme.primary.withAlpha(30),
      borderRadius: BorderRadius.circular(12.r),
      onTap: () {
        widget.group.isPrivate == true
            ? WayaNav.toNamed('/privateGroup', arguments: {
                'memberCount': '${widget.group.memberCount}',
                'name': widget.group.name,
                'url': '${widget.group.url}',
                'desc': widget.group.description,
                'coverImage': '${widget.group.coverImage}',
                'profileImage': '${widget.group.profileImage}',
                'groupId': widget.group.id,
              })
            : WayaNav.toNamed(
                '/publicGroup',
                arguments: {
                  'memberCount': '${widget.group.memberCount}',
                  'name': widget.group.name,
                  'url': '${widget.group.url}',
                  'desc': widget.group.description,
                  'coverImage': '${widget.group.coverImage}',
                  'profileImage': '${widget.group.profileImage}',
                  'groupId': widget.group.id
                },
              );
      },
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
          spacing: 5.h,
          children: [
            ListTile(
              contentPadding: EdgeInsets.only(left: 0, right: 0),
              leading: CircleAvatar(
                radius: 40,
                backgroundColor: wayaTheme.colorScheme.greyColor100,
                backgroundImage: NetworkImage(widget.group.profileImage ?? ""),
              ),
              trailing: widget.group.ownerId == ConversationState.self.id
                  ? null
                  : SizedBox(
                      width: 70.w,
                      child: IntrinsicHeight(
                        child: WayaProgressiveButton(
                          notifier: loadingController,
                          callback: _joinGroup,
                          text: "Join",
                          height: 30.h,
                          textStyle: wayaTheme.textTheme.titleMedium?.copyWith(
                            color: wayaTheme.colorScheme.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
              title: Text(
                widget.group.name,
                style: wayaTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: wayaTheme.colorScheme.black,
                ),
              ),
              subtitle: Text(
                "${WayaValueHelper.formatNumber(widget.group.memberCount)} members",
                style: wayaTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: wayaTheme.colorScheme.greyColor500,
                ),
              ),
            ),

            // Finally, the group's description.
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                widget.group.description,
                style: wayaTheme.textTheme.bodyMedium!.copyWith(
                  fontSize: 14.sp,
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
