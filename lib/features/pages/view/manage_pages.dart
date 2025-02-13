
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/group/view/approval_screen.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';


class ManagePages extends ConsumerStatefulWidget {
  const ManagePages({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManagePagesState();
}

class _ManagePagesState extends ConsumerState<ManagePages> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createPageProvider.notifier).getAllPages('${ConversationState.self.id}');
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        viewModel.pagesUsersFollow!.isEmpty ? PostEmptyState():
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewModel.pagesUsersFollow?.length,
            itemBuilder: (_, index){
              final page = viewModel.pagesUsersFollow?[index];
              return Container(
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).colorScheme.greyColor200),

                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 0, right: 0),
                      onTap: (){
                        WayaNav.toNamed('/privatePage',
                            arguments: {
                              'pageId': '${page?.id}',
                              'followerCount':'${page?.followerCount}',
                              'name': '${page?.name}',
                              'desc': '${page?.description}',
                              'coverImage': '${page?.coverImage}',
                              'profileImage': '${page?.profileImage}',
                            });
                       /* page?.isPublic == false?
                        WayaNav.toNamed('/privatePage',
                            arguments: {
                              'name': '${page?.name}',
                              'desc': '${page?.description}',
                              'coverImage': '${page?.coverImage}',
                              'profileImage': '${page?.profileImage}',
                            }): WayaNav.toNamed('/publicPage',
                            arguments: {
                              'name': '${page?.name}',
                              'desc': '${page?.description}',
                              'coverImage': '${page?.coverImage}',
                              'profileImage': '${page?.profileImage}',
                              'groupId': '${page?.id}'
                            });*/
                      },
                          //WayaNav.toNamed('/privatePage'),
                      leading: CircleAvatar(
                        backgroundColor: WayaColors.greyColor100,
                        backgroundImage: NetworkImage('${page?.coverImage}'),
                      ),
                      title:Row(children: [
                        Text(
                          '${page?.name?.capitalizeFirst}',
                            style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.black )),


                      ],),
                      subtitle:  Text(
                        '${page?.followerCount} ${page?.followerCount==0 || page?.followerCount == 1?'Follower':'Followers'}',
                        style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.greyColor500 ),
                      ),),
                    Gap(10),
                    Text(
                      '${page?.description?.capitalizeFirst}',
                      style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.greyColor500 ),
                    ),

                  ],
                ),
              );
            }),

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
            hasButton: true,
            onTap: () {
              WayaNav.toNamed('/createPage');
            },
            //buttontext: 'Create a Post',
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter:
              ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You haven't created pages yet"),
      ),
    );
  }
}