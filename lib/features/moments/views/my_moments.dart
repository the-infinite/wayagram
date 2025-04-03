import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/moments/views/moment.dart';
import 'package:wayagram/features/moments/vm/moment_vm.dart';
import 'package:wayagram/features/moments/widgets/my_moment_widget.dart';
import 'package:gap/gap.dart';

class MyMoments extends ConsumerStatefulWidget {
  static const route = "/my-moments";
  const MyMoments({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyMomentState();
}

class _MyMomentState extends ConsumerState<MyMoments> {
  late final notifier = ref.read(momentVmProvider.notifier);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.getUserMoments(1);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(momentVmProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isLoading: state.isLoadingUserMoments,
      title: "My Moments",
      isScrollable: false,
      backgroundColor: wayaTheme.colorScheme.scaffoldColor,
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(color: wayaTheme.colorScheme.white, borderRadius: BorderRadius.circular(12)),
        child: RefreshIndicator(
          child: ListView(
            children: [
              addMoment(context: context, ref: ref),
              const Gap(10),
              ListView.builder(
                itemCount: state.myMoments.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => MyMomentWidget(
                  moment: state.myMoments[index],
                  allMoments: state.myMoments,
                  index: index,
                ),
              )
            ],
          ),
          onRefresh: () => notifier.getUserMoments(1),
        ),
      ),
    );
  }

  InkWell addMoment({required BuildContext context, required WidgetRef ref}) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      onTap: () {
        WayaNav.toNamed(Moment.route);
      },
      child: Row(
        children: [
          SvgPicture.asset(WayaAssets.icons.mAddMoment.path),
          SizedBox(
            width: 10.w,
          ),
          Text(
            "Add New Moment",
            style: TextStyle(color: wayaTheme.colorScheme.customPrimary, fontSize: 14.sp, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
