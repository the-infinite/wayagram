import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/profile/model/pages.dart';

class SinglePageWidget extends StatefulWidget {
  final PageModel page;
  final int index;

  // Construct.
  const SinglePageWidget({
    super.key,
    required this.page,
    required this.index,
  });

  @override
  State<SinglePageWidget> createState() => _SinglePageWidgetState();
}

class _SinglePageWidgetState extends State<SinglePageWidget> {
  final loadingController = ValueNotifier(false);

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  Future<void> _followPage() async {}

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
        widget.page.isPublic == true
            ? WayaNav.toNamed('/publicPage', arguments: {
                'pageId': widget.page.id,
                'followerCount': '${widget.page.followerCount}',
                'name': widget.page.name,
                'desc': widget.page.description,
                'coverImage': '${widget.page.coverImage}',
                'profileImage': '${widget.page.profileImage}',
              })
            : WayaNav.toNamed(
                '/privatePage',
                arguments: {
                  'pageId': widget.page.id,
                  'followerCount': '${widget.page.followerCount}',
                  'name': widget.page.name,
                  'desc': widget.page.description,
                  'coverImage': '${widget.page.coverImage}',
                  'profileImage': '${widget.page.profileImage}',
                },
              );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
                backgroundImage: NetworkImage(widget.page.profileImage ?? ""),
              ),
              title: Row(
                children: [
                  Text(
                    widget.page.name,
                    style: wayaTheme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: wayaTheme.colorScheme.black,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                "${WayaValueHelper.formatNumber(widget.page.followerCount)} followers",
                style: wayaTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: wayaTheme.colorScheme.greyColor500,
                ),
              ),
              trailing: widget.page.ownerId == ConversationState.self.id
                  ? null
                  : SizedBox(
                      width: 70.w,
                      child: IntrinsicHeight(
                        child: WayaProgressiveButton(
                          notifier: loadingController,
                          callback: _followPage,
                          text: "Follow",
                          height: 30.h,
                          textStyle: wayaTheme.textTheme.titleMedium?.copyWith(
                            color: wayaTheme.colorScheme.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
            ),

            // Space.
            const Gap(10),

            // Finally, the group's description.
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                widget.page.description,
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
