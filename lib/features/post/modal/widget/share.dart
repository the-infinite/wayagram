// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/service/notification_service.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';

class ShareRepostButton extends ConsumerStatefulWidget {
  final PostModel post;

  // Construct.
  const ShareRepostButton({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<ShareRepostButton> createState() => _ShareReportButtonState();
}

class _ShareReportButtonState extends ConsumerState<ShareRepostButton> {
  late final notifier = ref.read(createPageProvider.notifier);
  final loadingController = ValueNotifier(false);

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? Things to build the widget.
    final theme = Theme.of(context);

    //? The widget itself.
    return ValueListenableBuilder(
      valueListenable: loadingController,
      builder: (context, isActive, _) => AnimatedCrossFade(
        firstChild: GestureDetector(
          onTap: () async {
            final result = await notifier.repostPost(context, widget.post);

            //? If the result is not null, then we are loading.
            PushNotifications.showSimpleNotification(
              title: "Repost",
              body: "Post has been reposted successfully.",
              payload: "{}",
            );

            //? This is fine.
            if (result != null) {
              loadingController.value = true;
              await notifier.sharePost(context, postId: widget.post.id);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 5.w,
            children: [
              //? The first option icon.
              WayaAssets.icons.sRepost.svg(
                width: 62.dg,
                height: 62.dg,
              ),

              //? The first option.
              Text(
                "Repost",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  color: theme.colorScheme.greyColor600,
                ),
              ),
            ],
          ),
        ),
        secondChild: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5.w,
          children: [
            //? The first option icon.
            WayaAssets.icons.sRepostDone.svg(
              width: 62.dg,
              height: 62.dg,
            ),

            //? The first option.
            Text(
              "Reposted",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: theme.colorScheme.greyColor600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        crossFadeState: isActive ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}
