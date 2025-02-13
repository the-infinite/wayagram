
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/view/events.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/pages/view/pages_for_you.dart';
import 'package:wayagram/features/pages/view/team_page.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

class MembersScreen extends ConsumerStatefulWidget {
  static const route = '/membersScreen';
  const MembersScreen ({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen >
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final groupId  = ModalRoute.of(context)?.settings.arguments as String;
      ref.read(createGroupProvider.notifier).getGroupMembers(groupId);
    });
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createGroupProvider);
    final member = ref.watch(createGroupProvider.notifier);


    final dynamic args  = ModalRoute.of(context)?.settings.arguments;

    return WayaScaffold(
      backgroundColor: Theme.of(context).colorScheme.greyColor50,
        isLoading: viewModel.isLoading,
        isScrollable: true,
        title: 'Members',
        appBarTrailing: Row(
          spacing: 12,
          children: [
            WayaAssets.icons.genSet.search.svg(fit: BoxFit.none),
            Gap(8)
          ],
        ),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            viewModel.allGroupMemberDocs!.isEmpty ? MemberEmptyState():
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 15),
                itemCount: viewModel.allGroupMemberDocs?.length,
                itemBuilder: (_, index){
                final member = viewModel.allGroupMemberDocs?[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).colorScheme.greyColor200),

                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 0, right: 0),
                          leading: Image.network('${member?.user?.profilePicture}',height: 40.h,),
                          title:Row(children: [
                            Text('${member?.user?.firstName?.capitalizeFirst} ${member?.user?.lastName?.capitalizeFirst}',
                                //index==0?'Chijioke Nwankwo':index==1?'Temitope Adebayo':index==2?'Oluwaseun Adeyemi': 'Ifeoma Okeke',
                                style: wayaTheme.textTheme.bodyMedium),

                            Spacer(),
                            SizedBox(
                              width: context.width * 0.20,
                              child:WayaButton(
                                callback: (){},
                                text: 'Follow',
                                textStyle: Theme.of(context).textTheme.bodySmall!.wayaCopyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).colorScheme.white ),
                                height: 32.h,
                              ),
                            ),

                          ],),
                          subtitle:  Text(
                           '${member?.user?.email}',
                            style: Theme.of(context).textTheme.bodySmall!.wayaCopyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.greyColor500 ),
                          ),),
                        //Gap(10),

                        Text('',
                          //'${member?.user.}',
                          //index.isEven?'🌍 Adventurous soul | Espresso lover ☕ | Gadget aficionado 💻 | Documenting my journeys and life lessons! ✨':'✈️ Wanderlust-driven | Tea connoisseur 🍵 | Tech enthusiast 💻 | Exploring the world and sharing my stories! 🌟',
                          style: Theme.of(context).textTheme.displaySmall!.wayaCopyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.greyColor500 ),
                        ),

                      ],
                    ),
                  );
                }),

          ],
        ),
    );
  }

}

class MemberEmptyState extends StatelessWidget {
  const MemberEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: EmptyState(
            hasButton: false,
            onTap: () {
              //WayaNav.toNamed(CreatePost.route);
            },
            buttontext: '',
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter:
              ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "No members yet"),
      ),
    );
  }
}