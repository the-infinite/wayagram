import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';

import '../../../assetsgen/assets.gen.dart';
import '../../post/view/create_post.dart';
import '../../shop/widgets/empty_state.dart';

class GroupPost extends ConsumerStatefulWidget {
  final GroupProviderFamily provider;
  final String id;

  //? This is fine.
  const GroupPost({
    super.key,
    required this.provider,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupPostState();
}

class _GroupPostState extends ConsumerState<GroupPost> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(widget.provider.notifier).getGroupSinglePosts(widget.id);
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

        //? Return this is fine.
        if (viewModel.getAllPost?.isEmpty ?? true)
          PostEmptyState()
        else
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewModel.getAllPost?.length ?? 0,
            itemBuilder: (_, index) => WayaPostWidget(
              data: viewModel.getAllPost![index],
              index: index,
            ),
          ),

        // Some space.
        const Gap(25),
      ],
    );
  }
}

class PostEmptyState extends StatelessWidget {
  const PostEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: EmptyState(
            hasButton: false,
            onTap: () {
              WayaNav.toNamed(CreatePost.route);
            },
            buttontext: 'Create a Post',
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter: ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You haven't created any post yet"),
      ),
    );
  }
}
