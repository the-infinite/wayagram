
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/group/widget/group_widget.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';


class ManageGroups extends ConsumerStatefulWidget {
  const ManageGroups({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManageGroupsState();
}

class _ManageGroupsState extends ConsumerState<ManageGroups> with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      //ref.read(createGroupProvider.notifier).getAllGroups();
      ref.read(createGroupProvider.notifier).getMyGroups();
      // ref.read(createGroupProvider.notifier).setGroup(fetchGroup);
      // print('THE PUBLIC GROUP ID is $id');
    });
  }



  @override
  Widget build(BuildContext context) {

    final viewModel = ref.watch(createGroupProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        viewModel.myGroups!.isEmpty ? GroupEmptyState():
        ListView.builder(
            padding: EdgeInsets.only(bottom: 40),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewModel.myGroups?.length,
            itemBuilder: (_, index){
             final group = viewModel.myGroups?[index];
              return GroupWidget(
                  name: '${group?.name?.capitalizeFirst}',
                  desc: '${group?.description?.capitalizeFirst}',
                  image:'${group?.coverImage}', count: '${group?.memberCount} Members',
                  buttonText: '',
                  chk: false,
                  onTap: (){
                    print('DARLINGTON===>> ${group?.isPrivate}');
                    group?.isPrivate == true?
                    WayaNav.toNamed('/privateGroup',
                        arguments: {
                          'memberCount':'${group?.memberCount}',
                          'name': '${group?.name}',
                          'url': '${group?.url}',
                          'desc': '${group?.description}',
                          'coverImage': '${group?.coverImage}',
                          'profileImage': '${group?.profileImage}',
                          'groupId': '${group?.id}',
                        }): WayaNav.toNamed('/publicGroup',
                        arguments: {
                          'memberCount':'${group?.memberCount}',
                          'name': '${group?.name}',
                          'url': '${group?.url}',
                          'desc': '${group?.description}',
                          'coverImage': '${group?.coverImage}',
                          'profileImage': '${group?.profileImage}',
                          'groupId': '${group?.id}'
                        });
                  });

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
            hasButton: true,
            onTap: () {
              WayaNav.toNamed('/createGroup');
            },
            buttontext: 'Create Group',
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter:
              ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You have not created any group yet"),
      ),
    );
  }
}