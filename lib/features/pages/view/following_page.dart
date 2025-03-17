
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/group/widget/group_widget.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';


class FollowingPage extends ConsumerStatefulWidget {
  const FollowingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FollowingPageState();
}

class _FollowingPageState extends ConsumerState<FollowingPage> with SingleTickerProviderStateMixin {

  PageController pageController = PageController(initialPage: 0,);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createPageProvider.notifier).getPagesUserFollows();
    });
  }


  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPageProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        viewModel.pagesUsersFollow!.isEmpty ? PageEmptyState():
        ListView.builder(
          padding: EdgeInsets.only(bottom: 40),
            shrinkWrap: true,
            itemCount: viewModel.pagesUsersFollow?.length,
            itemBuilder: (_, index){
             final page = viewModel.pagesUsersFollow?[index];
              return GroupWidget(
                  name: '${page?.name?.capitalizeFirst}',
                  desc: '${page?.description?.capitalizeFirst}',
                  image:'${page?.coverImage}',
                  count:'${page?.followerCount} ${page?.followerCount==0 || page?.followerCount == 1?'Follower':'Followers'}',
                  buttonText: 'Following',
                  chk: true,
                  onTap: (){});
            }),

      ],
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
        padding: EdgeInsets.all(30),
        child: EmptyState(
            hasButton: false,
            onTap: () {
            },
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter:
              ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You haven't followed any page yet"),
      ),
    );
  }
}