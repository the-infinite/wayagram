import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

class TeamPage extends ConsumerStatefulWidget {
  final String pageId;
  const TeamPage({
    super.key,
    required this.pageId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeamPageState();
}

class _TeamPageState extends ConsumerState<TeamPage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createPageProvider.notifier).getPageMember(widget.pageId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      color: wayaTheme.colorScheme.greyColor50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WayaButton(
            centerWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(8),
                Text(
                  "Add New Team Member",
                  style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16.sp),
                ),
              ],
            ),
            callback: () => WayaNav.toNamed(WayaAppRoutes.getAddPageTeamMemberPage(widget.pageId)),
            color: wayaTheme.colorScheme.primary50,
          ),
          const Gap(8),
          ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: viewModel.getPageMemberDocs?.length,
              itemBuilder: (_, index) {
                final page = viewModel.getPageMemberDocs?[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(10),
                      Container(
                        padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
                        width: 80.w,
                        decoration: BoxDecoration(
                          color: wayaTheme.colorScheme.success50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              page?.role == 'admin' || page?.role == 'owner'
                                  ? 'assets/images/pages/crown.png'
                                  : page?.role == 'editor'
                                      ? 'assets/images/pages/editor.png'
                                      : 'assets/images/pages/moderator.png',
                              height: 8.h,
                            ),
                            const Gap(5),
                            const Gap(5),
                            Text(
                              "${page?.role?.capitalizeFirst}",
                              style: TextStyle().wayaCopyWith(
                                color: page?.role == 'admin' || page?.role == 'owner'
                                    ? wayaTheme.colorScheme.success
                                    : WayaColors.primary700,
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Gap(10),
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 0, right: 0, top: 0),
                        leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: WayaColors.greyColor100,
                            backgroundImage: NetworkImage('${page?.user?.profilePicture}')),
                        title: Row(
                          children: [
                            Text(
                              '${page?.user?.firstName?.capitalizeFirst} ${page?.user?.lastName?.capitalizeFirst}',
                              style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.black),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '${page?.user?.email}',
                          style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.greyColor500),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
