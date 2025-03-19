import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/shared/features/profile/widget/group.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';

import '../../../assetsgen/assets.gen.dart';
import '../../explore/widgets/grouped_widget_header.dart';
import '../../post/view/create_post.dart';
import '../../shop/widgets/empty_state.dart';

class GroupsForYou extends ConsumerStatefulWidget {
  const GroupsForYou({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupsForYouState();
}

class _GroupsForYouState extends ConsumerState<GroupsForYou> with SingleTickerProviderStateMixin {
  int like = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createGroupProvider.notifier).getRecommendedGroups();
      //ref.read(createGroupProvider.notifier).getGroupPosts();
      ref.read(createPageProvider.notifier).getAllPosts(ConversationState.self.id);
      ref.read(createGroupProvider.notifier).getPopularPosts();
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(createGroupProvider.notifier).getRecommendedGroups();
      //ref.read(createGroupProvider.notifier).getGroupPosts();
      ref.read(createPageProvider.notifier).getAllPosts(ConversationState.self.id);
      ref.read(createGroupProvider.notifier).getPopularPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    //final viewModel2 = ref.watch(createPageProvider);
    final recommended = ref.watch(createGroupProvider);
    final viewGroup = ref.watch(createGroupProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Based on Groups you joined',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: WayaColors.greyColor700,
            fontFamily: WayaConstants.fontFamily,
          ),
        ),

        // Some space.
        Gap(2.h),

        //? Popular group posts.
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: viewGroup.groupPopularPostdocs?.length ?? 0,
          itemBuilder: (_, index) => WayaPostWidget(
            data: viewGroup.groupPopularPostdocs![index],
            index: index,
          ),
        ),
        const Gap(25),
        GroupedWidgetHeader(
          onTap: () {
            WayaNav.toNamed('/groupSuggestion');
          },
          subTitle: 'Connect with friends and communities',
          title: 'Suggestions',
        ),
        const Gap(25),
        SizedBox(
          height: 190,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: recommended.recommendedGroupDocs?.length ?? 0,
            itemBuilder: (_, index) => SingleGroupWidget(
              group: recommended.recommendedGroupDocs![index],
              index: index,
              vertical: true,
            ),
          ),
        ),
        Gap(20),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text('Based on Groups you joined',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: WayaColors.greyColor700,
                  fontFamily: WayaConstants.fontFamily)),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: viewGroup.groupPopularPostdocs?.length,
          itemBuilder: (_, index) => WayaPostWidget(
            data: viewGroup.groupPopularPostdocs![index],
            index: index,
          ),
        ),
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
          message: "You haven't created any post yet",
        ),
      ),
    );
  }
}
