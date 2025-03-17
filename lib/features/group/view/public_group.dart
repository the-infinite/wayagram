
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/state/group_state.dart';
import 'package:wayagram/features/group/view/events.dart';
import 'package:wayagram/features/group/view/group_post.dart';
import 'package:wayagram/features/group/view/mediaPost.dart';
import 'package:wayagram/features/group/view/report_group.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

class PublicGroup extends ConsumerStatefulWidget {
  static const route = '/publicGroup';
  const PublicGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PublicGroupState();
}

class _PublicGroupState extends ConsumerState<PublicGroup>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      final id  = ModalRoute.of(context)?.settings.arguments as String;
      ref.read(createPageProvider.notifier).getAllPosts(id);
  // final fetchGroup =  await ref.read(createGroupProvider.notifier).getSingleGroup(id);
   //ref.read(createGroupProvider.notifier).setGroup(fetchGroup);
   print('THE PUBLIC GROUP DarLIINGTON ==>> ID is $id');
    });
  }


  @override
  void reassemble() {
    super.reassemble();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      // final id  = ModalRoute.of(context)?.settings.arguments as String;
      // final fetchGroup =  await ref.read(createGroupProvider.notifier).getSingleGroup(id);
      // ref.read(createGroupProvider.notifier).setGroup(fetchGroup);
      //print('THE PUBLIC GROUP ID is $id');
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createGroupProvider);
    final viewModel2 = ref.watch(createGroupProvider.notifier);
    //final id  = ModalRoute.of(context)?.settings.arguments as String;
    //final group = ref.watch(groupResponseProvider);

    /// new implementation
    final dynamic args  = ModalRoute.of(context)?.settings.arguments;

    print('Group ID CHECK ${'${args['groupId']}'}');

    return WayaScaffold(
      padding: EdgeInsets.zero,
      onTapBackButton: (){
        WayaNav.toNamed('/groups');
       // WayaNav.toNamed( BottomView.route, arguments: 5);
      },
      isLoading: viewModel.isLoading,
      isScrollable: true,
      appBarTrailing: Row(
        spacing: 12,
        children: [
          WayaAssets.icons.genSet.search.svg(fit: BoxFit.none),
          InkWell(
            onTap: ()=> Share.share('${args['url']}', subject: 'Share Options'),
            child: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
          ),

          PopupMenuButton(
              onSelected: (value) {},
              iconColor: wayaTheme.colorScheme.greyColor400,
              position: PopupMenuPosition.under,
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: _buildActionNav(
                        context: context,
                        onTap: () {
                          WayaNav.goBack();
                          //WayaNav.toNamed('/groupSetting');

                        },
                        asset:
                        SvgPicture.asset('assets/images/pages/mute.svg', height: 20,),
                        text: "  Mute Group",
                        color: wayaTheme.colorScheme.customBlack),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: _buildActionNav(
                        context: context,
                        onTap: () {
                          Share.share('${args['url']}', subject: 'Share Options');
                        },
                        asset:WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
                        text: "  Share Group link",
                        color:wayaTheme.colorScheme.customBlack),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: _buildActionNav(
                        context: context,
                        onTap: () async{
                          WayaNav.goBack();
                          await WayaUtils.showModalSheet(context,
                              child: ReportGroup(
                                  statuses: groupReport,
                                  currentStatus: "",
                                  groupId: '${args['groupId']}'));

                        },
                        asset: SvgPicture.asset('assets/images/pages/flag.svg'),
                        text: "  Report Group",
                        color: wayaTheme.colorScheme.customBlack),
                  ),
                  PopupMenuItem<int>(
                    value: 3,
                    child: _buildActionNav(
                        context: context,
                        onTap: () {
                          //viewModel2.leaveGroup(context, groupId: '${args['groupId']}',);
                          viewModel2.deleteGroup(context, '${args['groupId']}',);
                          WayaNav.goBack();

                        },
                        asset: SvgPicture.asset(
                          'assets/images/pages/delete.svg',
                          //'assets/images/pages/door_open.svg',
                          color: wayaTheme.colorScheme.error500, height: 20,),
                        text: "  Delete Group",
                        color: wayaTheme.colorScheme.error500),
                  )
                ];
              },
              child: WayaAssets.icons.genSet.moreHorz.svg(fit: BoxFit.none)),
          Gap(8)
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200, // Banner height
                    decoration: BoxDecoration(
                      color: WayaColors.primaryBrown50,
                      borderRadius: BorderRadius.circular(0),
                      image:
                      //viewModel.profileImage!=null
                        args['profileImage'] !=null? DecorationImage(
                        image: NetworkImage('${args['profileImage']}'),
                        //image: NetworkImage('${viewModel.profileImage}'),
                        fit: BoxFit.cover,
                      ):
                      DecorationImage(
                        image: AssetImage('assets/images/pages/image_placeholder.png'),
                        fit: BoxFit.cover,
                      )
                      //     : const DecorationImage(
                      //   image: AssetImage("assets/placeholder.jpg"),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                  Gap(15),
                  GestureDetector(
                    onTap: () {
                       WayaNav.toNamed('/membersScreen',
                       arguments: '${args['groupId']}');
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20.w),
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: wayaTheme.colorScheme.primary600,
                            width: 1.5),
                        color: wayaTheme.colorScheme.white,
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: Text(
                        'Member',
                        style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                            color: wayaTheme.colorScheme.primary600,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                  left: 16.w,
                  top: 190,
                  child:  CircleAvatar(
                      radius: 30,
                      backgroundColor: WayaColors.greyColor100,
                      backgroundImage:NetworkImage('${args['coverImage']}')
                      //NetworkImage('${viewModel.coverImage}'),
                  )
              ),
            ],
          ),
          const Gap(10),

          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              Text(
                //'${viewModel.name?.capitalizeFirst}',
                  '${args['name']}',
                  style: wayaTheme.textTheme.bodyMedium),
              Text(
                '${args['desc']}',
                //'${viewModel.desc?.capitalizeFirst}',
                style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.greyColor500 ),
              ),
              const Gap(10),
              Row(
                children: [
                  actionType('${args['memberCount']}', 'Members',
                      onPressed: ()=> WayaNav.toNamed('/membersScreen',
                      arguments: '${args['groupId']}')),
                  const Gap(10),
                  actionType('${ ref.read(createPageProvider).postCount}', 'Posts'),
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  WayaTabButton(
                    isSelected: _selectedIndex == 0,
                    text: 'Posts',
                    onTap: () => setState(() => _selectedIndex = 0),
                  ),
                  WayaTabButton(
                    isSelected: _selectedIndex == 1,
                    text: 'Events',
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                  WayaTabButton(
                    isSelected: _selectedIndex == 2,
                    text: 'Media',
                    onTap: () => setState(() => _selectedIndex = 2),
                  ),
                ],
              ),

              //const Gap(20),
            ],),
          ),

          _selectedIndex == 0 ? GroupPost(groupId: '${args['groupId']}',) : _selectedIndex == 1 ? Events(): MediaPost(groupId: '${args['groupId']}')
          //AllOrders()
        ],
      ),
        floatingActionButton: SizedBox(
          height: 50,
          width: 50,
          child: WayaButton(
            callback: () {
              WayaNav.toNamed('/createGroupPost', arguments:'${args['groupId']}');
            },
            height: 50,
            centerWidget: Center(
              child: Icon(
                Icons.add,
                color: wayaTheme.colorScheme.white,
                size: 40,
              ),
            ),
          ),
        )
    );
  }
  actionType(txt, txt2, {onPressed}){
    final wayaTheme = Theme.of(context);
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      onTap: onPressed,
      child: Row(
        children: [
          Text(
              txt,
              style: wayaTheme.textTheme.bodySmall),
          const Gap(3),
          Text(
            txt2,
            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.greyColor500 ),
          ),
        ],
      ),
    );
  }

  InkWell _buildActionNav(
      {required BuildContext context,
        required VoidCallback onTap,
        required Widget asset,
        required String text,
        required Color color}) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          asset,
          const Gap(4),
          Text(
            text,
            style: TextStyle().wayaCopyWith(
                color: color, fontWeight: FontWeight.w500, fontSize: 12),
          )
        ],
      ),
    );
  }
}