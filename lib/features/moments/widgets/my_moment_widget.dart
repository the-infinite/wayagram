import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:gap/gap.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/moments/bottom_sheet/confirm_delete_widget.dart';
import 'package:wayagram/features/moments/data/model/moment_response_model.dart';
import 'package:wayagram/features/moments/views/moment.dart';
// import 'package:wayagram/features/moments/views/moment.dart';
import 'package:wayagram/features/moments/vm/moment_vm.dart';
import 'package:wayagram/features/moments/views/view_moment.dart';

class MyMomentWidget extends ConsumerWidget {
  final MomentData moment;
  final List<MomentData> allMoments;
  final int index;
  const MyMomentWidget({super.key, required this.moment, required this.allMoments, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return GestureDetector(
      onTap: () async {
        Navigator.pushReplacementNamed(context, ViewMoment.route, arguments: {
          "moments": allMoments,
          "isMine": true,
          'index': index
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [
                            Color(0xFFB43000),
                            Color(0x99FFEF8C),
                            Color(0xFFFF5D2E),
                          ],
                          stops: [
                            0.0,
                            0.5,
                            1.0
                          ]),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(3),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: wayaTheme.colorScheme.white,
                        ),
                        child: Center(
                          child: WayaDp(
                            image: moment.image,
                            radius: 20,
                          ),
                        ),
                      ),
                    ),
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
                          moment.contentType == 'text'
                              ? moment.content
                              : moment.caption!.isNotEmpty
                                  ? moment.caption!
                                  : 'No Caption',
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
                            timeago.format(moment.updatedAt),
                            style: TextStyle(
                                fontSize: 12,
                                color: wayaTheme.colorScheme.greyColor400,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            width: 4.h,
                          ),
                          //  SizedBox(
                          //     width: 75,
                          //     child: WayaButton(
                          //       callback: () {},
                          //       centerWidget: Row(
                          //         children: [
                          //           SvgPicture.asset(WayaAssets.icons.mPromo.path),
                          //           SizedBox(
                          //             width: 3.w,
                          //           ),
                          //           Text(
                          //             "Promoted",
                          //             style: TextStyle(
                          //                 color: wayaTheme.colorScheme.primary600,
                          //                 fontSize: 10,
                          //                 fontWeight: FontWeight.w500),
                          //           )
                          //         ],
                          //       ),
                          //       height: 28,
                          //       color: wayaTheme.colorScheme.primar50,
                          //       radius: 14,
                          //     ),
                          //   ),
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
                        "${moment.totalViews} VIEWS",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 1.w,
                  ),
                  MyMomentActions(moment: moment, ref: ref)
                ],
              )
            ],
          ),
          const Gap(20)
        ],
      ),
    );
  }
}

class MyMomentActions extends StatelessWidget {
  final MomentData moment;
  final WidgetRef ref;
  const MyMomentActions({super.key, required this.moment, required this.ref});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);

    Future<void> showDelete() async {
      await WayaUtils.showModalSheet(context,
          child: ConfirmDeleteWidget(
              delete: () =>
                  ref.read(momentVmProvider.notifier).deleteMoment(moment.id)));
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
                    WayaNav.toNamed(Moment.route, arguments: moment);
                  },
                  asset: Icon(
                    Icons.edit,
                    size: 20,
                    color: wayaTheme.colorScheme.greyColor500,
                  ),
                  text: "Edit"),
            ),
            // PopupMenuItem<int>(
            //   value: 0,
            //   child: _buildActionNav(
            //       context: context,
            //       onTap: () async {
            //         Navigator.pop(context);
            //       },
            //       asset: SvgPicture.asset(WayaAssets.icons.mFire.path),
            //       text: "Promote"),
            // ),
            PopupMenuItem<int>(
              value: 1,
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
