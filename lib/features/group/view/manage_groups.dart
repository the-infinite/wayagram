
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
                      },
                      leading: CircleAvatar(
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
                        //'Be the first to know about upcoming marvel movies and get the latest news before anyone',
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