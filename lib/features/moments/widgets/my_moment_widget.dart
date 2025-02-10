import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/moments/bottom_sheet/confirm_delete_widget.dart';

class MyMomentWidget extends ConsumerWidget {
  const MyMomentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                WayaImage(
                  imageUrl: "",
                  height: 50,
                  width: 50,
                  radius: BorderRadius.circular(50),
                ),
                SizedBox(
                  width: 6.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 160.w,
                      child: Text(
                        "No Caption",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      children: [
                        Text(
                          "20 mins ago",
                          style: TextStyle(
                              fontSize: 12,
                              color: wayaTheme.colorScheme.greyColor400,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: 4.h,
                        ),
                        SizedBox(
                          width: 75,
                          child: WayaButton(
                            callback: () {},
                            centerWidget: Row(
                              children: [
                                SvgPicture.asset(WayaAssets.icons.mPromo.path),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Text(
                                  "Promoted",
                                  style: TextStyle(
                                      color: wayaTheme.colorScheme.primary600,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            height: 28,
                            color: wayaTheme.colorScheme.primar50,
                            radius: 14,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(WayaAssets.icons.mViews.path),
                    SizedBox(
                      width: 3.w,
                    ),
                    Text(
                      "20 VIEWS",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                SizedBox(
                  width: 1.w,
                ),
                MyMomentActions(
                  momentId: '',
                )
              ],
            )
          ],
        ),
        const Gap(20)
      ],
    );
  }
}

class MyMomentActions extends StatelessWidget {
  final String momentId;
  const MyMomentActions({super.key, required this.momentId});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);

    Future<void> showDelete() async {
      await WayaUtils.showModalSheet(context, child: ConfirmDeleteWidget());
    }

    return PopupMenuButton(
        onSelected: (value) {},
        icon: SvgPicture.asset(WayaAssets.icons.mThreeDots.path),
        iconColor: wayaTheme.colorScheme.greyColor400,
        position: PopupMenuPosition.under,
        itemBuilder: (context) {
          return [
            PopupMenuItem<int>(
              value: 0,
              child: _buildActionNav(
                  context: context,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  asset: Icon(
                    Icons.edit,
                    size: 20,
                    color: wayaTheme.colorScheme.greyColor500,
                  ),
                  text: "Edit"),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: _buildActionNav(
                  context: context,
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  asset: SvgPicture.asset(WayaAssets.icons.mFire.path),
                  text: "Promote"),
            ),
            PopupMenuItem<int>(
              value: 2,
              child: _buildActionNav(
                  context: context,
                  onTap: () async {
                     Navigator.pop(context);
                    showDelete();
                   
                  },
                  asset: Icon(
                    Icons.delete_outline_sharp,
                    size: 22,
                    color: wayaTheme.colorScheme.error,
                  ),
                  textColor: wayaTheme.colorScheme.error,
                  text: "Delete"),
            ),
          ];
        });
  }

  InkWell _buildActionNav(
      {required BuildContext context,
      required VoidCallback onTap,
      required Widget asset,
      Color? textColor,
      required String text}) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          asset,
          const Gap(4),
          Text(text,
              style: TextStyle(
                  color: textColor ?? wayaTheme.colorScheme.customBlack,
                  fontWeight: FontWeight.w500,
                  fontSize: 12))
        ],
      ),
    );
  }
}
