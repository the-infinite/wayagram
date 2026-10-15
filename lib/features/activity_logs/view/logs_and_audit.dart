import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/view/activity_log.dart';

class LogsAndAuditTrials extends ConsumerStatefulWidget {
  static const route = '/logsAndAuditTrials';
  const LogsAndAuditTrials({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LogsAndAuditTrialsState();
}

class _LogsAndAuditTrialsState extends ConsumerState<LogsAndAuditTrials> {
  @override
  Widget build(BuildContext context) {
    return WayaScaffold(
      backgroundColor: WayaColors.greyColor50,
      title: "Logs & Audit Trails    ",
      isLoading: false,
      isScrollable: true,
      body: Column(
        spacing: 1,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          logCard(
              'Account',
              WayaAssets.icons.genSet.account.path,
              () => WayaNav.toNamed(ActivityLog.route,
                  arguments: {'name': 'account'})),
          logCard(
              'Shop',
              WayaAssets.icons.genSet.shop.path,
              () => WayaNav.toNamed(ActivityLog.route,
                  arguments: {'name': 'shop'})),
          logCard(
              'Wallet',
              WayaAssets.icons.genSet.wallet2.path,
              () => WayaNav.toNamed(ActivityLog.route,
                  arguments: {'name': 'wallet'})),
          logCard(
              'Events',
              WayaAssets.icons.genSet.event.path,
              () => WayaNav.toNamed(ActivityLog.route,
                  arguments: {'name': 'events'})),
          logCard(
              'Chat & Socials',
              WayaAssets.icons.genSet.chat3.path,
              () => WayaNav.toNamed(ActivityLog.route,
                  arguments: {'name': 'chat'})),
          logCard(
              'Polls & Voting',
              WayaAssets.icons.genSet.polls.path,
              () => WayaNav.toNamed(ActivityLog.route,
                  arguments: {'name': 'polls'})),
          logCard(
              'Pages',
              WayaAssets.icons.genSet.pages.path,
              () => WayaNav.toNamed(ActivityLog.route,
                  arguments: {'name': 'pages'})),
          logCard(
              'Groups',
              WayaAssets.icons.genSet.group.path,
              () => WayaNav.toNamed(ActivityLog.route,
                  arguments: {'name': 'groups'})),
          logCard(
              'Donation',
              WayaAssets.icons.genSet.donation.path,
              () => WayaNav.toNamed('/donationLogs'
                  //     ActivityLog.route,  arguments: {
                  //   'name': 'donation'
                  // }
                  )),
          logCard(
              'UGT',
              WayaAssets.icons.genSet.ugt.path,
              () => WayaNav.toNamed(ActivityLog.route,
                  arguments: {'name': 'ugt'})),
          logCard(
              'Get Quotation',
              WayaAssets.icons.genSet.account.path,
              () => WayaNav.toNamed(ActivityLog.route,
                  arguments: {'name': 'quotation'})),
        ],
      ),
    );
  }

  Widget logCard(String title, img, onTap) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: SvgPicture.asset(img),
        title: Text(title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFamily: WayaConstants.fontFamily,
              color: WayaColors.greyColor700,
            )),
        trailing: SvgPicture.asset('assets/images/forward.svg'),
      ),
    );
  }
}
