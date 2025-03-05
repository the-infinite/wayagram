
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/logs_and_audit/view/cms_clicks.dart';
import 'package:wayagram/features/logs_and_audit/view/login_activity.dart';
import 'package:wayagram/features/logs_and_audit/view/payment_activity.dart';
import 'package:wayagram/features/logs_and_audit/view/search_log.dart';
import 'package:wayagram/features/logs_and_audit/view/user_action.dart';
import 'package:wayagram/features/logs_and_audit/view/user_interaction.dart';
import 'package:wayagram/features/logs_and_audit/view/visited_page.dart';

class LogsAndAuditTrials extends ConsumerStatefulWidget {
  static const route = '/logsAndAuditTrials';
  const LogsAndAuditTrials({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LogsAndAuditTrialsState();
}

class _LogsAndAuditTrialsState extends ConsumerState<LogsAndAuditTrials> {


  @override
  Widget build(BuildContext context) {

    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      backgroundColor: WayaColors.greyColor50,
      title: "Logs & Audit Trails    ",
      isLoading: false,
      isScrollable: true,
      onTapBackButton: (){
        Navigator.pop(context);
        ref.watch(createGroupProvider.notifier).reset();
      },
      body: Column(
        spacing:10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(10),
         logCard('Login Activity',
             'Review all login attempts to keep your account secure',()=> WayaNav.toNamed(LoginActivity.route)),
          logCard('Visited Pages',
              'Discover which pages you’ve accessed recently.',()=> WayaNav.toNamed(VisitedPage.route)),

          logCard('CMS Clicks',
              'Track your interactions with CMS elements across the platform',()=> WayaNav.toNamed(CmsClicks.route)),

          logCard('User Actions',
              'View all actions you’ve performed, including edits and updates.',()=> WayaNav.toNamed(UserAction.route)),

          logCard('Payment Activity',
              'Monitor all payments made through your account',()=>WayaNav.toNamed(PaymentActivity.route)),

          logCard('User Interactions',
              'Review your engagement, from messages sent to likes and shares',()=>WayaNav.toNamed(UserInteraction.route)),
          logCard('Search Logs',
              'Review your engagement, from messages sent to likes and shares',()=>WayaNav.toNamed(SearchLog.route)),




        ],
      ),
    );
  }

  Widget logCard(title, subtitle, onTap){
    return  Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        title:  Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontFamily: WayaConstants.fontFamily,
              color: Colors.black,
            )),
        subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              fontFamily: WayaConstants.fontFamily,
              color: Color(0xff6B7280),
            )),
        trailing: SvgPicture.asset('assets/images/forward.svg'),
      ),
    );
  }

}
