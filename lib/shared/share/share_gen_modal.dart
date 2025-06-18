// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/shared/features/chat/widget/conversation.dart';

class ShareGenModal extends StatelessWidget {
  final String link;
  final PageVm pageNotifier;

  //? This is the post to share.
  const ShareGenModal({
    super.key,
    required this.link,
    required this.pageNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    //? This is fine.
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 16),
      child: SizedBox(
        width: size.width,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              //? First, the title of the popup.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Share Options",
                  style: theme.textTheme.titleLarge,
                ),
              ),

              // Some  space.
              const Gap(10),

              //? Then, the share options.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10.w,
                  children: [
                    //? The first option, is to repost.
                    /*   Expanded(
                      child: ShareRepostButton(post: post),
                    ), */

                    /* //? The second option, is to save.
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final result = await pageNotifier
                              .bookmarkPost(context, postId: post?.id ?? "");
                          WayaNav.goBack(
                            result: ShareResult(
                              "save",
                              result
                                  ? ShareResultStatus.success
                                  : ShareResultStatus.dismissed,
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5.w,
                          children: [
                            //? The first option icon.
                            WayaAssets.icons.sSave.svg(
                              width: 62.dg,
                              height: 62.dg,
                            ),

                            //? The first option.
                            Text(
                              "Save",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14.sp,
                                color: theme.colorScheme.greyColor600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //? The third option, is to add moment.
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await WayaNavigationHelper.showComingSoonModal(true);
                          WayaNav.goBack(
                            result: ShareResult(
                              "moment",
                              ShareResultStatus.unavailable,
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5.w,
                          children: [
                            //? The first option icon.
                            WayaAssets.icons.sMoment.svg(
                              width: 62.dg,
                              height: 62.dg,
                            ),

                            //? The first option.
                            Text(
                              "Add to Moment",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14.sp,
                                color: theme.colorScheme.greyColor600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
 */
                    //? The fourth option, is to copy link.
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await WayaUtils.copyText(link);
                          WayaNav.goBack(result: ShareResult("copy", ShareResultStatus.success));
                          return;

                          /*  WayaNav.goBack(
                              result: ShareResult(
                                  "copy", ShareResultStatus.dismissed)); */
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5.w,
                          children: [
                            //? The first option icon.
                            WayaAssets.icons.sLink.svg(
                              width: 62.dg,
                              height: 62.dg,
                            ),

                            //? The first option.
                            Text(
                              "Copy Link",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14.sp,
                                color: theme.colorScheme.greyColor600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //? The fifth option, is to share outward.
                    Expanded(
                      child: GestureDetector(
                        onTap: () async => Share.share(link, subject: 'Share Post URL').then(
                          (value) async {
                            if (value.status == ShareResultStatus.success) {
                              // Share the post.
                              await Share.share(
                                WayaValueHelper.getShareableUrl(link),
                                subject: "Share Contest",

                                // https://staging.wayagram.ng/contest-profile-page?id=acabf193-dd12-48c5-9030-157efa4c012a&contestId=10c8c1b5-f720-4633-a14e-646313230192
                              );

                              // Now stop.
                              return;
                            }

                            WayaNav.goBack(result: value);
                          },
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5.w,
                          children: [
                            //? The first option icon.
                            WayaAssets.icons.sShare.svg(
                              width: 62.dg,
                              height: 62.dg,
                            ),

                            //? The first option.
                            Text(
                              "Share Via",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14.sp,
                                color: theme.colorScheme.greyColor600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Some space.
              const Gap(20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Send as message",
                  style: theme.textTheme.titleMedium,
                ),
              ),

              //? Then, to share the post.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                child: ShareChatsWidget(
                  url: link,
                  notifier: pageNotifier,
                  entityId: link,
                ),
              ),

              //? One divider.
              Divider(color: theme.colorScheme.greyColor200, height: 1, thickness: 3),

              // Some space.
              const Gap(13),

              //? For the rest of the first row of social redirects...
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10.w,
                  children: [
                    //? First, the button to repost.
                    /*  Expanded(
                      child: ShareRepostButton(post: post),
                    ), */

                    //? Second, the button for instagram.
                    Expanded(
                      child: GestureDetector(
                        onTap: () async => await WayaNavigationHelper.showComingSoonModal(true),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5.w,
                          children: [
                            //? The first option icon.
                            WayaAssets.icons.sInsta.svg(
                              width: 62.dg,
                              height: 62.dg,
                            ),

                            //? The first option.
                            Text(
                              "Instagram",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14.sp,
                                color: theme.colorScheme.greyColor600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //? Third, the button for snapchat.
                    Expanded(
                      child: GestureDetector(
                        onTap: () async => await WayaNavigationHelper.showComingSoonModal(true),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5.w,
                          children: [
                            //? The first option icon.
                            WayaAssets.icons.sSnap.svg(
                              width: 62.dg,
                              height: 62.dg,
                            ),

                            //? The first option.
                            Text(
                              "Snapchat",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14.sp,
                                color: theme.colorScheme.greyColor600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //? Fourth, the button for telegram.
                    Expanded(
                      child: GestureDetector(
                        onTap: () async => await WayaNavigationHelper.showComingSoonModal(true),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5.w,
                          children: [
                            //? The first option icon.
                            WayaAssets.icons.sTelegram.svg(
                              width: 62.dg,
                              height: 62.dg,
                            ),

                            //? The first option.
                            Text(
                              "Telegram",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14.sp,
                                color: theme.colorScheme.greyColor600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //? Fifth, the button for whatsapp.
                    Expanded(
                      child: GestureDetector(
                        onTap: () async => await WayaNavigationHelper.showComingSoonModal(true),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5.w,
                          children: [
                            //? The first option icon.
                            WayaAssets.icons.sWhatsapp.svg(
                              width: 62.dg,
                              height: 62.dg,
                            ),

                            //? The first option.
                            Text(
                              "WhatsApp",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14.sp,
                                color: theme.colorScheme.greyColor600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Some space.
              const Gap(10),

              //? For the second row of social redirects...
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10.w,
                  children: [
                    //? Sixth, the button for facebook.
                    Expanded(
                      child: GestureDetector(
                        onTap: () async => await WayaNavigationHelper.showComingSoonModal(true),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5.w,
                          children: [
                            //? The first option icon.
                            WayaAssets.icons.sFb.svg(
                              width: 62.dg,
                              height: 62.dg,
                            ),

                            //? The first option.
                            Text(
                              "Facebook",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14.sp,
                                color: theme.colorScheme.greyColor600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //? Seventh, the button for LinkedIn.
                    Expanded(
                      child: GestureDetector(
                        onTap: () async => await WayaNavigationHelper.showComingSoonModal(true),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5.w,
                          children: [
                            //? The first option icon.
                            WayaAssets.icons.sLinkedin.svg(
                              width: 62.dg,
                              height: 62.dg,
                            ),

                            //? The first option.
                            Text(
                              "LinkedIn",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14.sp,
                                color: theme.colorScheme.greyColor600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //? Eighth, the button for snapchat story.
                    Expanded(
                      child: GestureDetector(
                        onTap: () async => await WayaNavigationHelper.showComingSoonModal(true),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5.w,
                          children: [
                            //? The first option icon.
                            WayaAssets.icons.sSnap.svg(
                              width: 62.dg,
                              height: 62.dg,
                            ),

                            //? The first option.
                            Text(
                              "Snapchat Story",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14.sp,
                                color: theme.colorScheme.greyColor600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //? Ninth, the button for WhatsApp status.
                    Expanded(
                      child: GestureDetector(
                        onTap: () async => await WayaNavigationHelper.showComingSoonModal(true),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5.w,
                          children: [
                            //? The first option icon.
                            WayaAssets.icons.sWhatsapp.svg(
                              width: 62.dg,
                              height: 62.dg,
                            ),

                            //? The first option.
                            Text(
                              "WhatsApp Status",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14.sp,
                                color: theme.colorScheme.greyColor600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //? Tenth, the button for Twitter.
                    Expanded(
                      child: GestureDetector(
                        onTap: () async => await WayaNavigationHelper.showComingSoonModal(true),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5.w,
                          children: [
                            //? The first option icon.
                            WayaAssets.icons.sX.svg(
                              width: 62.dg,
                              height: 62.dg,
                            ),

                            //? The first option.
                            Text(
                              "X",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14.sp,
                                color: theme.colorScheme.greyColor600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
