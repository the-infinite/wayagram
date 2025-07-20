import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/group/widget/group_empty_state.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

class SinglePageInvitation extends ConsumerStatefulWidget {
  final String id;
  static const route = '/userPageInvitation/single';
  const SinglePageInvitation({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SinglePageInvitationState();
}

class _SinglePageInvitationState extends ConsumerState<SinglePageInvitation>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createPageProvider.notifier).getPageInvitation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);
    return WayaScaffold(
      backgroundColor: Theme.of(context).colorScheme.greyColor50,
      isLoading: viewModel.isLoading,
      isScrollable: false,
      title: 'Page Invitation',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          viewModel.pageInvitationModelDocs!.isEmpty
              ? GroupPageEmptyState(text: "You don't have any invitation yet")
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: viewModel.pageInvitationModelDocs?.length,
                  itemBuilder: (_, index) {
                    final page = viewModel.pageInvitationModelDocs![index];
                    return Container(
                      height: 60.h,
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(10),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: WayaColors.greyColor100,
                                backgroundImage: page.page?.profileImage == null
                                    ? AssetImage("assets/placeholder.jpg")
                                    : NetworkImage(
                                        '${page.page?.profileImage}',
                                      ),
                              ),
                              Gap(10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${page.page?.name?.capitalizeFirst}',
                                    style: wayaTheme.textTheme.bodyMedium!
                                        .wayaCopyWith(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .black),
                                  ),
                                  Gap(5),
                                  Text(
                                    '${page.page?.description?.capitalizeFirst}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .wayaCopyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .greyColor500),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () => ref
                                          .read(createPageProvider.notifier)
                                          .rejectPageInvitation(
                                              context, '${page.pageId}'),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: wayaTheme
                                                    .colorScheme.error)),
                                        child: Icon(
                                          Icons.close,
                                          color: wayaTheme.colorScheme.error,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () => ref
                                          .read(createPageProvider.notifier)
                                          .acceptPageInvitation(
                                              context, '${page.pageId}'),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: wayaTheme
                                                    .colorScheme.success)),
                                        child: Icon(
                                          Icons.check,
                                          color: wayaTheme.colorScheme.success,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Gap(6),
                        ],
                      ),
                    );
                  }),
        ],
      ),
    );
  }
}
