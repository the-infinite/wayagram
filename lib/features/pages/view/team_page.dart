import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/string_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/widget/group_empty_state.dart';
import 'package:wayagram/features/pages/data/model/get_page_member_model.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/pages/widget/page_member_card.dart';
import 'package:wayagram/shared/cache/page.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';

class TeamPage extends ConsumerStatefulWidget {
  final String pageId;
  final PageProviderFamily provider;
  const TeamPage({super.key, required this.pageId, required this.provider});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeamPageState();
}

class _TeamPageState extends ConsumerState<TeamPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createPageProvider.notifier).getPageMember(widget.pageId);
    });
  }

  final bool vertical = false;

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
                      color: wayaTheme.colorScheme.customPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp),
                ),
              ],
            ),
            callback: () => WayaNav.toNamed(
                WayaAppRoutes.getAddPageTeamMemberPage(widget.pageId)),
            color: wayaTheme.colorScheme.primary50,
          ),
          const Gap(8),
          if (viewModel.getPageMemberDocs!.isEmpty)
            GroupPageEmptyState(text: 'No members yet')
          else
            ListView.builder(
                padding: EdgeInsets.only(bottom: 50.h),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.getPageMemberDocs?.length,
                itemBuilder: (_, index) {
                  return ValueListenableBuilder(
                      valueListenable: wayaPageCache,
                      builder: (context, redraws, _) {
                        final pageMember = viewModel.getPageMemberDocs?[index];
                        final page = wayaPageCache.getCachedData(widget.pageId);
                        if (page == null) {
                          return SizedBox();
                        }
                        //? If this is in vertical orientation.
                        if (vertical) {
                          return PageMemberCardWidget(
                              pageMember: pageMember,
                              widget: widget,
                              wayaTheme: wayaTheme,
                              ref: ref);
                        }

                        // Build and return our component.
                        return PageMemberCardWidget(
                            pageMember: pageMember,
                            widget: widget,
                            wayaTheme: wayaTheme,
                            ref: ref);
                      });
                })
        ],
      ),
    );
  }
}
