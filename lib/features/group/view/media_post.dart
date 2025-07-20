import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/group/widget/group_empty_state.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';
import 'package:wayagram/shared/features/profile/widget/muted_post.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';

class MediaPost extends ConsumerStatefulWidget {
  final GroupProviderFamily provider;
  final String id;
  const MediaPost({
    super.key,
    required this.id,
    required this.provider,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MediaPostState();
}

class _MediaPostState extends ConsumerState<MediaPost>
    with SingleTickerProviderStateMixin {
  int like = 0;

  GroupModel? group;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(widget.provider.notifier).getGroupMedia(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(widget.provider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(20.h),
        Text(
          'Latest post',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: WayaColors.greyColor600,
            fontFamily: WayaConstants.fontFamily,
          ),
        ),
        // Some space.
        Gap(10.h),

        //? This is fine.
        if (viewModel.getAllPost?.isEmpty ?? true)
          GroupPageEmptyState(text: 'No media yet')
        else
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewModel.getAllPost?.length ?? 0,
            itemBuilder: (_, index) => group?.mutedAt == null ? WayaPostWidget(
              data: viewModel.getAllPost![index],
              index: index,
            ): WayaMutedPostWidget(
              data: viewModel.getAllPost![index],
              index: index,
            )
          ),
        const Gap(25),
      ],
    );
  }
}
