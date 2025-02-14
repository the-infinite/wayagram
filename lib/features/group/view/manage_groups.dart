
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/group/widget/group_widget.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';


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
      ref.read(createGroupProvider.notifier).getAllGroups();
      // ref.read(createGroupProvider.notifier).setGroup(fetchGroup);
      // print('THE PUBLIC GROUP ID is $id');
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

        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewModel.getAllGroups?.length,
            itemBuilder: (_, index){
             final group = viewModel.getAllGroups?[index];
              return GroupWidget(
                  name: '${group?.name?.capitalizeFirst}',
                  desc: '${group?.description?.capitalizeFirst}',
                  image:'${group?.coverImage}', count: '${group?.memberCount} Members',
                  buttonText: '',
                  chk: false,
                  onTap: (){
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