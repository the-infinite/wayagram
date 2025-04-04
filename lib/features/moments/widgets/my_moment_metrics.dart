import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/moments/bottom_sheet/moment_viewers.dart';
import 'package:wayagram/features/moments/data/model/moment_response_model.dart';

class MyMomentMetrics extends ConsumerWidget {
  final MomentData moment;
  final Function() pause;
  final Function() continues;

  const MyMomentMetrics(
      {super.key,
      required this.moment,
      required this.continues,
      required this.pause});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            pause();
            await WayaUtils.showModalSheet(context,
                child: MomentViewers(momentId: moment.id));
     
              continues();
            
          },
          child: SvgPicture.asset(WayaAssets.icons.mChevronUp.path),
        ),
        SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            metricCard(
              color: moment.contentType == 'text'
                  ? wayaTheme.colorScheme.white.withOpacity(0.5)
                  : wayaTheme.colorScheme.black.withOpacity(0.5),
              context: context,
              metric: WayaHelpers.formatMetrics(moment.totalViews),
              icon: SvgPicture.asset(WayaAssets.icons.mEye.path),
            ),
            SizedBox(
              width: 4,
            ),
            metricCard(
              color: moment.contentType == 'text'
                  ? wayaTheme.colorScheme.white.withOpacity(0.5)
                  : wayaTheme.colorScheme.black.withOpacity(0.5),
              context: context,
              metric: WayaHelpers.formatMetrics(moment.totalLikes),
              icon: SvgPicture.asset(WayaAssets.icons.mNotliked.path),
            ),
            SizedBox(
              width: 4,
            ),
            metricCard(
              context: context,
              color: moment.contentType == 'text'
                  ? wayaTheme.colorScheme.white.withOpacity(0.5)
                  : wayaTheme.colorScheme.black.withOpacity(0.5),
              metric: WayaHelpers.formatMetrics(moment.totalComments),
              icon: SvgPicture.asset(WayaAssets.icons.mComments.path),
            ),
          ],
        )
      ],
    );
  }

  Widget metricCard(
      {required BuildContext context,
      required Color color,
      required String metric,
      required Widget icon}) {
    final wayaTheme = Theme.of(context);
    return Container(
      width: 75,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          SizedBox(
            width: 3,
          ),
          Text(
            metric,
            style: TextStyle(
                fontSize: 13.sp,
                color: wayaTheme.colorScheme.white,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
