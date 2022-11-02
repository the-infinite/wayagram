import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import 'app_button.dart';

class AppOverlay {
  static Future<void> loadingOverlay({
    required Future<dynamic> Function() asyncFunction,
  }) async =>
      await Get.showOverlay(
        asyncFunction: asyncFunction,
        loadingWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 26, 26, 25),
                  borderRadius: BorderRadius.circular(10)),
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: AppColors.bostonUniRed,
                size: 35,
              ),
            ),
          ],
        ),
      );

  static void showInfoDialog(
      {required String title,
      String? content,
      Widget? contentReplacement,
      Function()? onPressed,
      String? buttonText}) {
    showDialog(
      context: Get.context!,
      builder: (context) => Material(
        elevation: 10,
        color: Colors.black.withOpacity(0.2),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.width * 0.8,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 17 * Get.textScaleFactor * 0.90,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 11),
                    Center(
                      child: contentReplacement ??
                          Text(
                            content ?? "",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.bodyText2.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                          title: buttonText ?? "Okay",
                          /*   padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25), */
                          borderRadius: 100,
                          onPressed: onPressed ?? Get.back),
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

  static Future<void> showActionDialog({
    required String title,
    String? content,
    Widget? contentReplacement,
    required Map<String, Function()> actions,
  }) async {
    assert(content != null || contentReplacement != null,
    "either content or contentReplacement must be provided");
    if (actions.length == 1) {
      showInfoDialog(
        title: title,
        content: content,
        buttonText: actions.keys.first,
        onPressed: actions.values.first,
      );
      return;
    }

    List<Widget> buttons = [];
    actions.forEach((text, onPressed) {
      buttons.add(Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.5),
          child: AppButton(
              borderRadius: 1000,
              bckgrndColor: AppColors.primary,
              title: text,
              onPressed: () async {
                await onPressed();
              }),
        ),
      ));
    });
    showDialog(
      builder: (context) => Material(
        color: Colors.black.withOpacity(0.2),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.width * 0.9,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 13.5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w600, fontSize: 17, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    if (content == null) contentReplacement ?? const SizedBox(),
                    if (content != null)
                      Center(
                        child: Text(
                          content,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.bodyText2
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: buttons,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      context: Get.context!,
    );
  }
}
