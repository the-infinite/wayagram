import 'package:flutter/material.dart';
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
import 'package:wayagram/features/moments/vm/moment_vm.dart';
import 'package:wayagram/features/moments/views/view_moment.dart';
import 'package:wayagram/features/promotion/data/models/promotion_service_type.dart';
import 'package:wayagram/features/promotion/views/promote.dart';

class MyMomentWidget extends ConsumerWidget {
  final MomentData moment;
  final List<MomentData> allMoments;
  final int index;
  final bool isMine;
  const MyMomentWidget({
    super.key,
    required this.moment,
    required this.allMoments,
    this.isMine = true,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        WayaNav.goBack();
        await WayaNav.to(
          transition: WayaTransition.downToUp,
          duration: const Duration(milliseconds: 600),
          ViewMoment(moments: allMoments, isMine: isMine, index: index),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //? Our moment configuration.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
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
                              image: moment.thumbnail ?? '',
                              radius: 20,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Some space.
                    SizedBox(
                      width: 6.w,
                    ),

                    //? This is fine too.
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //? For the text.
                          Text(
                            moment.contentType == 'text'
                                ? moment.content
                                : moment.caption!.isNotEmpty
                                    ? moment.caption!
                                    : 'No Caption',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Some space.
                          SizedBox(
                            height: 5.h,
                          ),

                          //? For the time this was sent.
                          Row(
                            children: [
                              Text(
                                timeago.format(moment.updatedAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: wayaTheme.colorScheme.greyColor400,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),

                              // Fair enough.
                              SizedBox(
                                width: 4.h,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              //? This is fine.
              Row(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(WayaAssets.icons.mViews.path),
                      SizedBox(
                        width: 3.w,
                      ),
                      Text(
                        "${moment.totalViews} ${moment.totalViews > 1 ? 'VIEWS' : 'VIEW'} ",
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

          // Some space.
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
                    WayaNav.goBack();
                    WayaNav.toNamed(Moment.route, arguments: moment);
                  },
                  asset: Icon(
                    Icons.edit,
                    size: 20,
                    color: wayaTheme.colorScheme.greyColor500,
                  ),
                  text: "Edit"),
            ),
            PopupMenuItem<int>(
              value: 0,
              child: _buildActionNav(
                  context: context,
                  onTap: () async {
                    WayaNav.goBack();
                    WayaNav.toNamed(Promote.route, arguments: {
                      "contentId": moment.id,
                      "contentType": PromotionServiceType.moment.name,
                      "data": moment
                    });
                  },
                  asset: SvgPicture.asset(WayaAssets.icons.mFire.path),
                  text: "Promote"),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: _buildActionNav(
                  context: context,
                  onTap: () async {
                    WayaNav.goBack();
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
