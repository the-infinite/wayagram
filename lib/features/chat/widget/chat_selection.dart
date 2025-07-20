import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/member.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class SelectConversationWidget extends StatelessWidget {
  final ChatModel chat;
  final int index;
  final bool isSelected;
  final FutureOr<void> Function(ChatModel) onSelect;

  // Construct.
  const SelectConversationWidget({
    super.key,
    required this.chat,
    required this.index,
    required this.isSelected,
    required this.onSelect,
  });

  // This is fine too.
  @override
  Widget build(BuildContext context) {
    final unread = chat.unreadCount;

    // The thing that you are sending.
    return Padding(
      padding: index == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () => onSelect(chat),
        splashColor: WayaColors.primary.withAlpha(30),
        focusColor: WayaColors.primary.withAlpha(30),
        highlightColor: WayaColors.primary.withAlpha(30),
        borderRadius: BorderRadius.circular(10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected
                ? WayaColors.primary.withAlpha(30)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // The user's chat profile picture.
              ChatProfilePicture(
                user: chat.other.userData ?? ConversationState.self,
                lastSeen: chat.other.chatUser?.lastSeen,
                showActive: chat.other.chatUser?.onlineStatus ==
                    ChatUserActivity.online,
                radius: 27,
              ),

              // Some space.
              const Gap(10),

              //* For the messages part.
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* For the other person's name.
                    Text(
                      chat.name ??
                          chat.other.userData?.fullname ??
                          chat.other.chatUser?.displayName ??
                          "WayaGram User",
                      maxLines: 1,
                      style: WayaTextStyles.titleMedium.copyWith(
                        fontWeight:
                            unread < 1 ? FontWeight.normal : FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    //? For the message content...
                    if (chat.other.profileData != null)
                      Text(
                        "@${chat.other.profileData!.username!}",
                        maxLines: 1,
                        style: WayaTextStyles.titleMedium.copyWith(
                          fontWeight:
                              unread < 1 ? FontWeight.normal : FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                          color: unread < 1
                              ? WayaColors.greyColor400
                              : WayaColors.greyColor500,
                          fontSize: 14.sp,
                        ),
                      ),
                  ],
                ),
              ),

              // Some space
              const Gap(10),

              //* Selection icon
              Checkbox(
                value: isSelected,
                tristate: false,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                splashRadius: 12,
                fillColor: WidgetStateColor.resolveWith(
                  (states) {
                    //? If this is selected...
                    if (states.contains(WidgetState.selected)) {
                      return WayaColors.primary;
                    }

                    // Since it is not.
                    return Colors.transparent;
                  },
                ),
                side: BorderSide(
                  color:
                      isSelected ? WayaColors.greyColor300 : WayaColors.primary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100000),
                ),
                onChanged: (value) {
                  onSelect(chat);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectUserWidget extends StatelessWidget {
  final String id;
  final int index;
  final int? max;
  final ValueNotifier<List<UserDetailsModel>> controller;
  final FutureOr<void> Function(UserDetailsModel, bool) onSelect;

  const SelectUserWidget({
    super.key,
    required this.id,
    required this.index,
    required this.controller,
    required this.onSelect,
    this.max,
  });

  @override
  Widget build(BuildContext context) {
    return WayaFutureSubscriber(
      future: UserResource.getUserDetails(id),
      suspense: (context) => const SizedBox(),
      builder: (context, data) => ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, choices, _) {
          final isSelected = choices.any((person) => person.id == id);

          //? This is fine.
          return Padding(
            padding: index == 0 ? EdgeInsets.zero : EdgeInsets.only(top: 10.h),
            child: InkWell(
              onTap: () {
                final value = [...controller.value];

                //? Fair enough.
                if (isSelected) {
                  value.removeWhere((user) => user.id == data.$1.id);
                }

                //? Do it like this.
                else {
                  value.add(data.$1);
                }

                //? This is fine.
                final size = value.length;
                controller.value = max != null
                    ? value.sublist((size - max!).abs(), size)
                    : value;
                onSelect(data.$1, isSelected);
              },
              splashColor: WayaColors.primary.withAlpha(30),
              focusColor: WayaColors.primary.withAlpha(30),
              highlightColor: WayaColors.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isSelected
                      ? WayaColors.primary.withAlpha(30)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // The user's chat profile picture.
                    ChatProfilePicture(
                      user: data!.$1,
                      radius: 27.r,
                      showActive: false,
                    ),

                    // Some space.
                    const Gap(10),

                    //* For the messages part.
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //* For the other person's name.
                          Text(
                            data.$1.fullname,
                            maxLines: 1,
                            style: WayaTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          //? For the message content...
                          if (data.$2.username != null)
                            Text(
                              "@${data.$2.username!}",
                              maxLines: 1,
                              style: WayaTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                                color: WayaColors.greyColor500,
                                fontSize: 14.sp,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Some space
                    const Gap(10),

                    //* Selection icon
                    Checkbox(
                      value: isSelected,
                      tristate: false,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      splashRadius: 12,
                      fillColor: WidgetStateColor.resolveWith(
                        (states) {
                          //? If this is selected...
                          if (states.contains(WidgetState.selected)) {
                            return WayaColors.primary;
                          }

                          // Since it is not.
                          return Colors.transparent;
                        },
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? WayaColors.greyColor300
                            : WayaColors.primary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100000),
                      ),
                      onChanged: (value) {
                        onSelect(data.$1, isSelected);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class UserActionWidget extends StatelessWidget {
  final String id;
  final int index;
  final bool actionAvailable;
  final bool useYou;
  final bool hideAction;
  final String actionText;
  final VoidCallback onTap;
  final Widget? child;

  // Construct.
  const UserActionWidget({
    super.key,
    required this.id,
    required this.index,
    required this.actionText,
    required this.onTap,
    this.useYou = true,
    this.hideAction = false,
    this.actionAvailable = true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ChatAndSocialUserWidget(
      id: id,
      index: index,
      useYou: useYou,
      child: child ??
          Visibility(
            visible: !hideAction,
            child: InkWell(
              onTap: actionAvailable ? onTap : null,
              splashColor: WayaColors.primary.withAlpha(30),
              focusColor: WayaColors.primary.withAlpha(30),
              highlightColor: WayaColors.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                child: Text(
                  actionText,
                  style: WayaTextStyles.bodyBold.copyWith(
                    color: actionAvailable
                        ? WayaColors.primary
                        : WayaColors.greyColor500,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
    );
  }
}

class ChatAndSocialUserWidget extends StatelessWidget {
  final String id;
  final int index;
  final Widget? child;
  final bool useYou;

  // Construct.
  const ChatAndSocialUserWidget({
    super.key,
    required this.id,
    required this.index,
    this.useYou = true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return WayaFutureSubscriber(
      future: UserResource.getUserDetails(id),
      suspense: (context) => const SizedBox(),
      builder: (context, data) => Padding(
        padding: index == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 10),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10.w,
            children: [
              // The user's chat profile picture.
              ChatProfilePicture(
                user: data!.$1,
                radius: 27.r,
                showActive: false,
                canMove: true,
              ),

              //* For the messages part.
              Expanded(
                child: InkWell(
                  onTap: () =>
                      WayaNav.toNamed(WayaAppRoutes.getProfileRoute(id)),
                  splashColor: WayaColors.primary.withAlpha(30),
                  focusColor: WayaColors.primary.withAlpha(30),
                  highlightColor: WayaColors.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //* For the other person's name.
                      Text(
                        useYou && id == ConversationState.self.id
                            ? "You "
                            : data.$1.fullname,
                        maxLines: 1,
                        style: WayaTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      //? For the message content...
                      if (data.$2.username != null)
                        Text(
                          "@${data.$2.username!}",
                          maxLines: 1,
                          style: WayaTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                            color: WayaColors.greyColor500,
                            fontSize: 14.sp,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              //* Selection icon
              if (child != null) child!,
            ],
          ),
        ),
      ),
    );
  }
}
