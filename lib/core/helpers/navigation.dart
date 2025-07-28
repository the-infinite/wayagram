import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/core/components/modals/coming_soon.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/post/modal/share.dart';
import 'package:wayagram/shared/features/media/image.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';

class WayaNavigationHelper {
  WayaNavigationHelper._();

  static Future<T?> toImageDetailsScreen<T>(
      List<File>? media, List<String>? urls) {
    return WayaNav.to(
      transition: WayaTransition.circularReveal,
      duration: const Duration(milliseconds: 500),
      WayaImageDetailScreen(
        file: media,
        imageUrl: urls,
      ),
    );
  }

  static Future<void> showComingSoonModal(bool variant) async {
    await WayaUtils.showModalSheet(
      WayaNav.context,
      child: WayaComingSoonDialog(
        variant: variant,
      ),
    );
  }

  static Future<ShareResult?> sharePost(PostModel post, WidgetRef ref) async {
    final result = await WayaUtils.showModalSheet<ShareResult>(
      WayaNav.context,
      child: SharePostModal(
        post: post,
        pageNotifier: ref.read(createPageProvider.notifier),
      ),
    );
    return result;
  }
}
