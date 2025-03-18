import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';

import '../../../assetsgen/assets.gen.dart';
import '../../post/view/create_post.dart';
import '../../shop/widgets/empty_state.dart';

class PagePost extends ConsumerStatefulWidget {
  final String pageId;
  const PagePost({super.key, required this.pageId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PagePostState();
}

class _PagePostState extends ConsumerState<PagePost> with SingleTickerProviderStateMixin {
  int like = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel2 = ref.watch(createPageProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: viewModel2.getAllPost!.isEmpty
          ? PostEmptyState()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Latest post',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: WayaColors.greyColor700,
                        fontFamily: WayaConstants.fontFamily)),
                if (viewModel2.getAllPost?.isEmpty ?? true)
                  PostEmptyState()
                else
                  ListView.builder(
                    //padding: EdgeInsets.only(left: 15, right: 15,),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: viewModel2.getAllPost?.length ?? 0,
                    itemBuilder: (_, index) => WayaPostWidget(
                      data: viewModel2.getAllPost![index],
                      index: index,
                    ),
                  ),
                const Gap(25),
              ],
            ),
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
