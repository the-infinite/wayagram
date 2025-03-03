
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/logs_and_audit/widget/activity_card_widget.dart';

class CmsClicks extends ConsumerStatefulWidget {
  static const route = '/cmsClicks';
  const CmsClicks({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CmsClicksState();
}

class _CmsClicksState extends ConsumerState<CmsClicks> {


  @override
  Widget build(BuildContext context) {

    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      backgroundColor: WayaColors.greyColor50,
      title: "CMS Clicks    ",
      isLoading: false,
      isScrollable: false,
      body: Column(
        spacing:10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: WayaColors.greyColor300),
              borderRadius: BorderRadius.circular(6),
            ),
            width: 102.w,
            height: 36.h ,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'All Time',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
                Gap(10),
                SvgPicture.asset('assets/icons/down_arrow.svg')
              ],
            ),
          ),
          Gap(10),
          Text(
              'Today',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              )),

          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(bottom: 0),
                itemCount: 3,
                itemBuilder: (_, index){
                  return ActivityCardWidget(title: "Clicked on 'Edit Product' button under CMS - Products.", subTitle: 'Nov 9, 2024, 9:00 AM ',);
                }),
          ),
          Gap(10),

          Text(
              'Yesterday',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              )),

          Expanded(
            flex: 2,
            child: ListView.builder(
                itemCount: 4,
                itemBuilder: (_, index){
                  return ActivityCardWidget(title: "Clicked on ‘ Vote Now’ button under - UGT", subTitle: 'Nov 9, 2024, 9:00 AM ',);
                }),
          )



        ],
      ),
    );
  }


}
