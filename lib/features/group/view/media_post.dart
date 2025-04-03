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
import '../../shop/widgets/empty_state.dart';

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

class _MediaPostState extends ConsumerState<MediaPost> with SingleTickerProviderStateMixin {
  int like = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(widget.provider.notifier).getGroupPosts(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel2 = ref.watch(widget.provider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest post',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: WayaColors.greyColor700,
            fontFamily: WayaConstants.fontFamily,
          ),
        ),

        // Some space.
        Gap(10.h),

        //? This is fine.
        if (viewModel2.groupPostdocs?.isEmpty ?? true)
          PostEmptyState()
        else
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewModel2.groupPostdocs?.length ?? 0,
            itemBuilder: (_, index) => WayaPostWidget(
              data: viewModel2.groupPostdocs![index],
              index: index,
            ),
          ),
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
            onTap: () {},
            //buttontext: 'Create a Post',
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter: ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "No media yet"),
      ),
    );
  }
}
