import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/cache/page.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';
import 'package:wayagram/shared/features/profile/model/pages.dart';

class SinglePageWidget extends StatefulWidget {
  final PageModel page;
  final int index;
  final bool vertical;

  // Construct.
  const SinglePageWidget({
    super.key,
    required this.page,
    required this.index,
    this.vertical = false,
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

  void _toPage() {
    WayaNav.toNamed(WayaAppRoutes.getPageDetailsPage(widget.page.id));
  }

  Future<void> _followPage() async {
    //? Then leave the page.
    if (myPageNotifier.isMemberOf(widget.page.id)) {
      await myPageNotifier.unfollowPage(widget.page.id);
    }

    //? Then, join the page.
    else {
      await myPageNotifier.followPage(widget.page.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? If this is in vertical orientation.
    if (widget.vertical) {
      return InkWell(
        splashColor: wayaTheme.colorScheme.primary.withAlpha(30),
        focusColor: const Color.fromARGB(255, 179, 173, 170).withAlpha(30),
        highlightColor: wayaTheme.colorScheme.primary.withAlpha(30),
        borderRadius: BorderRadius.circular(12.r),
        onTap: _toPage,
        child: Container(
          margin: widget.index == 0 ? EdgeInsets.zero : EdgeInsets.only(left: 10),
          width: 150.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: wayaTheme.colorScheme.greyColor200),
          ),
          child: ValueListenableBuilder(
            valueListenable: wayaPageCache,
            builder: (context, redraws, _) {
              //? The page we shall be using.
              final page = wayaPageCache.getCachedData(widget.page.id) ?? widget.page;

              //? Return the widget.
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //? First, the image
                  WayaImage(
                    imageUrl: page.profileImage ?? page.coverImage ?? '',
                    height: 70.dg,
                    width: 70.dg,
                    radius: BorderRadius.circular(12),
                  ),

                  // Space.
                  Gap(10.h),

                  //? Second, the name of the group.
                  Text(
                    page.name,
                    style: wayaTheme.textTheme.bodyMedium!.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: wayaTheme.colorScheme.black,
                    ),
                  ),

                  // Space.
                  Gap(3.h),

                  //? Third, member count.
                  Text(
                    "${WayaValueHelper.formatNumber(page.followerCount)} followers",
                    style: wayaTheme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: wayaTheme.colorScheme.greyColor500,
                    ),
                  ),

                  // Space.
                  Gap(15.h),

                  //? Finally, a join button.
                  if (page.ownerId != ConversationState.self.id)
                    SizedBox(
                      width: 70.w,
                      child: IntrinsicHeight(
                        child: WayaProgressiveButton(
                          notifier: loadingController,
                          callback: _followPage,
                          text: myPageNotifier.isMemberOf(page.id) ? "Unfollow" : "Follow",
                          height: 30.h,
                          textStyle: wayaTheme.textTheme.titleMedium?.copyWith(
                            color: wayaTheme.colorScheme.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      );
    }

    // Build and return our component.
    return InkWell(
      splashColor: wayaTheme.colorScheme.primary.withAlpha(30),
      focusColor: const Color.fromARGB(255, 179, 173, 170).withAlpha(30),
      highlightColor: wayaTheme.colorScheme.primary.withAlpha(30),
      borderRadius: BorderRadius.circular(12.r),
      onTap: _toPage,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: wayaTheme.colorScheme.greyColor200,
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable: wayaPageCache,
          builder: (context, redraws, _) {
            //? The page we shall be using.
            final page = wayaPageCache.getCachedData(widget.page.id) ?? widget.page;

            //? Return the component.
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5.h,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.only(left: 0, right: 0),
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundColor: wayaTheme.colorScheme.greyColor100,
                    backgroundImage: NetworkImage(page.profileImage ?? ""),
                  ),
                  title: Row(
                    children: [
                      Text(
                        page.name,
                        style: wayaTheme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: wayaTheme.colorScheme.black,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    "${WayaValueHelper.formatNumber(page.followerCount)} followers",
                    style: wayaTheme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: wayaTheme.colorScheme.greyColor500,
                    ),
                  ),
                  trailing: page.ownerId == ConversationState.self.id
                      ? null
                      : SizedBox(
                          width: 70.w,
                          child: IntrinsicHeight(
                            child: WayaProgressiveButton(
                              notifier: loadingController,
                              callback: _followPage,
                              text: myPageNotifier.isMemberOf(page.id) ? "Unfollow" : "Follow",
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

                // Finally, the page's description.
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    page.description,
                    maxLines: 2,
                    style: wayaTheme.textTheme.bodyMedium!.copyWith(
                      fontSize: 14.sp,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w400,
                      color: wayaTheme.colorScheme.greyColor500,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
