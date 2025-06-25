// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/moments/views/moment.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/post/modal/widget/share.dart';
import 'package:wayagram/shared/features/chat/widget/conversation.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';

class SharePostModal extends StatelessWidget {
  final PostModel post;
  final PageVm pageNotifier;

  //? This is the post to share.
  const SharePostModal({
    super.key,
    required this.post,
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
                    Expanded(
                      child: ShareRepostButton(post: post),
                    ),

                    //? The second option, is to save.
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final result = await pageNotifier
                              .bookmarkPost(context, postId: post.id);
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
                          WayaNav.toNamed(Moment.route, arguments: {
                            "content": WayaValueHelper.getShareableUrl(
                                WayaAppRoutes.getSinglePostScreen(post.id))
                          });
                          // WayaNav.goBack(
                          //   result: ShareResult(
                          //     "moment",
                          //     ShareResultStatus.unavailable,
                          //   ),
                          // );
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

                    //? The fourth option, is to copy link.
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (post.url != null) {
                            await WayaUtils.copyText(post.url!);
                            WayaSnackBar.showToast("Copied ${post.url}");
                            WayaNav.goBack(
                                result: ShareResult(
                                    "copy", ShareResultStatus.success));

                            return;
                          }
                          WayaNav.goBack(
                              result: ShareResult(
                                  "copy", ShareResultStatus.dismissed));
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
                        onTap: () async => Share.share('${post.url}',
                                subject: 'Share Post URL')
                            .then(
                          (value) {
                            if (value.status == ShareResultStatus.success) {
                              // Share the post.
                              pageNotifier.sharePost(context,
                                  postId: post.originalPostId ?? post.id);

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                child: ShareChatsWidget(
                  url: post.url,
                  notifier: pageNotifier,
                  entityId: post.originalPostId ?? post.id,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
