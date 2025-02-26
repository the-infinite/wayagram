import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/ugt_details_leaderboard.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/ugt_details_post.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/widgets/contest_card.dart';
import 'package:wayagram/features/ugt/widgets/upcoming_widgets/upcoming_widget.dart';

import '../../../core/components/waya_scaffold.dart';

class DashboardContestProfilePage extends StatefulHookConsumerWidget {
  static const route = '/contest-mydashboard-profile-page';
  const DashboardContestProfilePage({super.key});

  @override
  ConsumerState<DashboardContestProfilePage> createState() =>
      _DashboardContestProfilePageState();
}

class _DashboardContestProfilePageState
    extends ConsumerState<DashboardContestProfilePage> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    var model = ref.watch(selectedContestProvider.notifier).state;
    final selectedViewIndex = useState(0);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "",
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  const Gap(10),

              Text("Dashboard",
                  style: wayaTheme.textTheme.displaySmall!
                      .wayaCopyWith(fontWeight: FontWeight.w700)),
              const Gap(5),
              Text("Manage your contest activity",
                  style: wayaTheme.textTheme.hintStyle
                      .wayaCopyWith(fontSize: 16, fontWeight: FontWeight.w400)),
              //  Text("Your Bio", style: wayaTheme.textTheme.bodyMedium),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: context.width / 2.5,
                    child: WayaButton(
                        horizontalPadding: 10,
                        fontSize: 14.sp,
                        height: 42,
                        text: "Edit contest details",
                        callback: () async {}),
                  ),
                  Gap(10),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      //  margin: EdgeInsets.only(right: 20.w),
                      padding: REdgeInsets.symmetric(
                          vertical: 8.dg, horizontal: 12.dg),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: wayaTheme.colorScheme.primary600,
                          width: 1.5,
                        ),
                        color: wayaTheme.colorScheme.white,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Filter',
                            style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                              color: wayaTheme.colorScheme.primary600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Gap(5),
                          WayaAssets.icons.actionFilter.svg(
                            color: wayaTheme.colorScheme.primary600,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
            ],
          ),
        ),
      ),
    );
  }

  Color getColor(bool isText, String text) {
    return isText ? Color(0xff9E0A05) : Color(0xffFEF6E7);
    /*  } else if (text == "rejected") {
      return isText ? Color(0xff9E0A05) : Color(0xffFBEAE9);
    } else {
      return isText ? Color(0xff865503) : Color(0xffFEF6E7);
    } */
  }
}

String formatMoney(String value) {
  final oCcy = NumberFormat("#,##0.00", "en_US");
  return oCcy.format(double.parse(value));
}
