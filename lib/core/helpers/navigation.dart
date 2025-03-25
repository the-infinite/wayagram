import 'dart:io';

import 'package:get/get.dart';
import 'package:wayagram/core/components/modals/coming_soon.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/shared/features/media/image.dart';

class WayaNavigationHelper {
  WayaNavigationHelper._();

  static Future<T> toImageDetailsScreen<T>(List<File>? media, List<String>? urls) {
    return WayaNav.to(
      transition: Transition.circularReveal,
      duration: const Duration(milliseconds: 500),
      WayaImageDetailScreen(
        file: media?[0],
        imageUrl: urls?[0],
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
}
