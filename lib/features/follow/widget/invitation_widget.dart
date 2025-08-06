import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/follow/model/default.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class InvitationWidget extends StatelessWidget {
  final FollowModel data;
  final int index;

  // This is fine.
  const InvitationWidget({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    //? Our theme.
    final theme = Theme.of(context);
    final notifier = myFollowProvider;

    //? The actual component.
    return WayaFutureSubscriber(
      future: data.getOtherUser(),
      suspense: (context) => const SizedBox(),
      builder: (context, data) => data == null
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => WayaNav.toNamed(WayaAppRoutes.getProfileRoute(data.$1.id, 'profile')),
                borderRadius: BorderRadius.circular(12.r),
                splashColor: theme.colorScheme.primary.withAlpha(30),
                focusColor: const Color.fromARGB(255, 179, 173, 170).withAlpha(30),
                highlightColor: theme.colorScheme.primary.withAlpha(30),
                child: Card(
                  elevation: 0,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 0, right: 0),
                          leading: ChatProfilePicture(
                            user: data.$1,
                            radius: 20.h,
                            showActive: false,
                          ),
                          horizontalTitleGap: 5.w,
                          title: Text(
                            data.$1.fullname,
                            style: theme.textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            data.$2.username != null ? '@${data.$2.username}' : 'ID: ${data.$1.id}',
                            style: theme.textTheme.bodySmall!.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: theme.colorScheme.greyColor500,
                            ),
                          ),
                        ),

                        //? This is the user's bio.
                        Text(
                          data.$2.bio ?? '',
                          style: theme.textTheme.displaySmall!.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.greyColor500,
                          ),
                        ),

                        //? The current state of affairs.
                        Row(
                          spacing: 10.w,
                          children: [
                            //? First button.
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  //? accept invitation.
                                  await notifier.handleFollowRequest(
                                      ConversationState.self.id, data.$1.id, FollowAction.accept,
                                      isInvitation: true);
                                },
                                child: Container(
                                  padding: REdgeInsets.symmetric(vertical: 8.dg, horizontal: 10.dg),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: theme.colorScheme.primary,
                                      width: 1.5,
                                    ),
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(7.r),
                                  ),
                                  child: Text(
                                    "Accept",
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            //? Second button.
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  //? decline invitation.
                                  await notifier.handleFollowRequest(
                                      ConversationState.self.id, data.$1.id, FollowAction.reject,
                                      isInvitation: true);
                                },
                                child: Container(
                                  padding: REdgeInsets.symmetric(vertical: 8.dg, horizontal: 10.dg),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: theme.colorScheme.primary,
                                      width: 1.5,
                                    ),
                                    color: theme.colorScheme.white,
                                    borderRadius: BorderRadius.circular(7.r),
                                  ),
                                  child: Text(
                                    "Decline",
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
