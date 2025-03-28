import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/view/payment_activity.dart';
import 'package:wayagram/features/activity_logs/view/search_log.dart';
import 'package:wayagram/features/activity_logs/view/user_action.dart';
import 'package:wayagram/features/activity_logs/view/user_interaction.dart';
import 'package:wayagram/features/activity_logs/view/visited_page.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';

import 'cms_clicks.dart';
import 'login_activity.dart';
class LogsAndAuditTrials extends ConsumerStatefulWidget {
  static const route = '/logsAndAuditTrials';
  const LogsAndAuditTrials({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LogsAndAuditTrialsState();
}

class _LogsAndAuditTrialsState extends ConsumerState<LogsAndAuditTrials> {


  @override
  Widget build(BuildContext context) {

    return WayaScaffold(
      backgroundColor: WayaColors.greyColor50,
      title: "Logs & Audit Trails    ",
      isLoading: false,
      isScrollable: true,
      onTapBackButton: (){
        WayaNav.goBack();
        ref.watch(createGroupProvider.notifier).reset();
      },
      body: Column(
        spacing:1,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(10),
          logCard('Account', WayaAssets.icons.genSet.account.path, ()=> WayaNav.toNamed(AccountActivity.route)),
          logCard('Shop', WayaAssets.icons.genSet.shop.path,()=> WayaNav.toNamed(VisitedPage.route)),
          logCard('Wallet', WayaAssets.icons.genSet.wallet2.path,()=> WayaNav.toNamed(CmsClicks.route)),
          logCard('Events', WayaAssets.icons.genSet.event.path,()=> WayaNav.toNamed(UserAction.route)),
          logCard('Chat & Socials', WayaAssets.icons.genSet.chat3.path,()=>WayaNav.toNamed(PaymentActivity.route)),
          logCard('Polls & Voting', WayaAssets.icons.genSet.polls.path,()=>WayaNav.toNamed(UserInteraction.route)),
          logCard('Pages', WayaAssets.icons.genSet.pages.path,()=>WayaNav.toNamed(UserInteraction.route)),
          logCard('Groups', WayaAssets.icons.genSet.group.path,()=>WayaNav.toNamed(UserInteraction.route)),
          logCard('Donation', WayaAssets.icons.genSet.donation.path,()=>WayaNav.toNamed(UserInteraction.route)),
          logCard('UGT', WayaAssets.icons.genSet.ugt.path,()=>WayaNav.toNamed(SearchLog.route)),
          logCard('Get Quotation', WayaAssets.icons.genSet.account.path,()=>WayaNav.toNamed(SearchLog.route)),




        ],
      ),
    );
  }

  Widget logCard(title, img, onTap){
    return  Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading:SvgPicture.asset(img,),
        title:  Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFamily: WayaConstants.fontFamily,
              color: WayaColors.greyColor700,
            )),
       /* subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              fontFamily: WayaConstants.fontFamily,
              color: Color(0xff6B7280),
            )),*/
        trailing: SvgPicture.asset('assets/images/forward.svg'),
      ),
    );
  }

}
