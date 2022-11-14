import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wayagram/app/controllers/home_controller.dart';
import 'package:wayagram/app/global_widgets/app_button.dart';
import 'package:wayagram/app/modules/home/home.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../controllers/auth_controller.dart';
import '../../data/model/blocked_accounts_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/group_model_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/person_view.dart';
import '../home/widgets/group_view.dart';
import '../home/widgets/notification_view.dart';
import '../profile/profile.dart';
import '../profile/update_profile.dart';

class GroupsAndPages extends StatefulWidget{
  const GroupsAndPages({Key? key}) : super(key: key);

  static const route = '/groupsAndPages';

  @override
  State<GroupsAndPages> createState() => _GroupsAndPagesState();
}

class _GroupsAndPagesState extends State<GroupsAndPages> with TickerProviderStateMixin{
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var pageController = PageController();
    var page = 0;

    var groupsTextController = TextEditingController(text: "0");
    var pagesTextController = TextEditingController(text: "0");

    var personalGroupTextController = TextEditingController(text: "0");
    var personalPagesTextController = TextEditingController(text: "0");

    return  GetBuilder<HomeController>(
      builder: (controller){
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('Groups & Pages', style: AppTextStyle.subtitle1.copyWith(
              color: Colors.black,
            )),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Divider(
                color: Colors.grey,
                thickness: 0.3,
              ),
              TabBar(
                controller: tabController,
                padding: EdgeInsets.zero,
                labelColor: Colors.black,
                unselectedLabelColor: const Color(0xff9A9A9A),
                indicatorColor: AppColors.primary,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(
                  fontSize: Get.width*0.035,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: Get.width*0.035,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: 'Groups',iconMargin: EdgeInsets.zero,),
                  Tab(text: 'Pages',iconMargin: EdgeInsets.zero,),
                ],
                onTap: (index) {

                },
              ),
              const Divider(
                height: 0.5,
                thickness: 0.5,
                color: Colors.grey,
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FutureBuilder<ApiResponse>(
                              future: controller.getSuggestedGroups,
                              builder: (context, snapshot) {
                                var savedPosts = MyPref.suggestedGroups.val;
                                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                  final posts = snapshot.data!.suggestion as List<GroupModelEntity>;
                                  return GroupView(posts: posts,isJoined: true);
                                } else if(savedPosts.isNotEmpty){
                                  var posts = GroupModelEntity.getService(jsonDecode(savedPosts));
                                  return GroupView(posts: posts,isJoined: true);
                                }else{
                                  return const GroupView(isLoading: true,isJoined: true);
                                }
                              }),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FutureBuilder<ApiResponse>(
                              future: controller.getPagesFollowed,
                              builder: (context, snapshot) {
                                var savedPosts = MyPref.pagesFollowed.val;
                                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                  final posts = snapshot.data!.data as List<GroupModelEntity>;
                                  return GroupView(posts: posts,isGroup: false,isJoined: true);
                                } else if(savedPosts.isNotEmpty){
                                  var posts = GroupModelEntity.getService(jsonDecode(savedPosts));
                                  return GroupView(posts: posts,isGroup: false,isJoined: true);
                                }else{
                                  if(snapshot.connectionState == ConnectionState.done){
                                    return const SizedBox.shrink();
                                  }
                                  return const GroupView(isLoading: true);
                                }
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}

