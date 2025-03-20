import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';

import '../../../assetsgen/assets.gen.dart';
import '../../explore/widgets/grouped_widget_header.dart';
import '../../post/view/create_post.dart';
import '../../shop/widgets/empty_state.dart';

class PagesForYou extends ConsumerStatefulWidget {
  const PagesForYou({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PagesForYouState();
}

class _PagesForYouState extends ConsumerState<PagesForYou> with SingleTickerProviderStateMixin {
  final _wayaLocalDataSource = WayaLocalDataSource();

  int like = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createPageProvider.notifier).getAllPages(ConversationState.self.id);
      ref.read(createPageProvider.notifier).getAllPosts(_wayaLocalDataSource.getUserId());
      ref.read(createPageProvider.notifier).getPopularPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider.notifier);
    final viewModel2 = ref.watch(createPageProvider);
    final viewPage = ref.watch(createPageProvider);
    /*   if (viewModel2.isLoading) {
      return Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ));
    }

    if (viewModel2.getAllPost!.isEmpty ) {
      return PostEmptyState();
    }*/
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text('Based on pages you follow',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: WayaColors.greyColor700,
                  fontFamily: WayaConstants.fontFamily)),
        ),
        if (viewModel2.getAllPost?.isEmpty ?? true)
          PostEmptyState()
        else
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewPage.getAllPost?.length ?? 0,
            itemBuilder: (_, index) => WayaPostWidget(
              data: viewPage.getAllPost![index],
              index: index,
            ),
          ),
        const Gap(25),
        GroupedWidgetHeader(
          onTap: () {
            WayaNav.toNamed('/suggestion');
          },
          subTitle: 'Connect with friends and communities',
          title: 'Suggestions',
        ),
        const Gap(25),
        viewModel2.allPageModelDocs!.isEmpty
            ? PageEmptyState()
            : SizedBox(
                height: 190,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: viewModel2.allPageModelDocs?.length,
                    itemBuilder: (_, index) {
                      final recommendedPage = viewModel2.allPageModelDocs?[index];
                      return Container(
                        margin: EdgeInsets.only(right: 10),
                        width: 147.w,
                        height: 159.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Theme.of(context).colorScheme.greyColor200),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            WayaImage(
                              imageUrl: '${recommendedPage?.coverImage}',
                              height: 70,
                              width: 70,
                              radius: BorderRadius.circular(12),
                            ),
                            const Gap(10),
                            Text('${recommendedPage?.name?.capitalizeFirst}',
                                style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.black)),
                            const Gap(3),
                            Text(
                              '${recommendedPage?.followerCount} Followers',
                              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.greyColor500),
                            ),
                            const Gap(3),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: WayaButton(
                                callback: () async {
                                  await viewModel.followPage(context, '${recommendedPage?.id}');
                                },
                                text: 'Follow',
                                height: 30,
                                textStyle: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.white),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
        Gap(20),
        if (viewPage.pagePopularPostDocs?.isEmpty ?? true)
          PostEmptyState()
        else
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewPage.pagePopularPostDocs?.length ?? 0,
            itemBuilder: (_, index) => WayaPostWidget(
              data: viewPage.pagePopularPostDocs![index],
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
            message: "You haven't created any post yet"),
      ),
    );
  }
}

class PageEmptyState extends StatelessWidget {
  const PageEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        child: EmptyState(
            hasButton: false,
            onTap: () {
              // WayaNav.toNamed('/createGroup');
            },
            //buttontext: 'Create a Post',
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter: ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You don't have suggestions yet"),
      ),
    );
  }
}
