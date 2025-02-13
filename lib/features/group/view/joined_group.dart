
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';


class JoinedGroup extends ConsumerStatefulWidget {
  const JoinedGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JoinedGroupState();
}

class _JoinedGroupState extends ConsumerState<JoinedGroup> with SingleTickerProviderStateMixin {

  PageController pageController = PageController(initialPage: 0,);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createGroupProvider.notifier).getJoinedGroups();
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createGroupProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        viewModel.joinedGroup!.isEmpty ? GroupEmptyState():
        ListView.builder(
            shrinkWrap: true,
            itemCount: viewModel.joinedGroup?.length,
            itemBuilder: (_, index){
            final group = viewModel.joinedGroup?[index];
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
                      leading:CircleAvatar(
                          radius: 40,
                          backgroundColor: WayaColors.greyColor100,
                          backgroundImage: NetworkImage('${group?.coverImage}')
                      ),
                      title:Row(children: [
                        Text('${group?.name?.capitalizeFirst}',
                            style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.black )),

                        Spacer(),
                        SizedBox(
                          width: context.width * 0.20,
                          height: 30,
                          child: WayaButton(
                            callback: (){},
                            text: 'Member',
                            height: 38,
                            color: Colors.white,
                            textColor: Theme.of(context).colorScheme.primary600,
                            border: Border.all(color:Theme.of(context).colorScheme.primary600),
                            textStyle: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.black ),

                          ),
                        )

                      ],),
                      subtitle:  Text(
                        '${group?.memberCount} Members',
                        style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.greyColor500 ),
                      ),),
                    Gap(10),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text('${group?.description?.capitalizeFirst}',
                        style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.greyColor500 ),
                      ),
                    ),

                  ],
                ),
              );
            }),

      ],
    );

  }

}

class GroupEmptyState extends StatelessWidget {
  const GroupEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        child: EmptyState(
            hasButton: false,
            onTap: () {
              //WayaNav.toNamed(reatePost.route);
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
            message: "You have not joined any group yet"),
      ),
    );
  }
}