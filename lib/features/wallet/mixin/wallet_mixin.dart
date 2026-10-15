import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/core/components/components.dart';

mixin WalletMixin {
  Future<void> shareReceipt(ScreenshotController screenshotController,
      Widget buildReceiptContent) async {
    try {
      final Uint8List imageBytes = await screenshotController.captureFromWidget(
        buildReceiptContent,
        delay: const Duration(milliseconds: 10),
      );

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/transaction_receipt.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(imageBytes);

      await SharePlus.instance.share(ShareParams(
        files: [XFile(imagePath)],
        text: 'Transaction Receipt',
        subject: 'Transaction Receipt from Wayagram',
      ));
    } catch (e) {
      WayaSnackBar.showToast('Failed to share receipt');
    }
  }
}
