import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
import 'package:wayagram/app/modules/home/widgets/bottom_sheet.dart';
import 'package:wayagram/app/modules/profile/inner_pages/blocked.dart';
import 'package:wayagram/app/modules/profile/inner_pages/muted.dart';
import 'package:wayagram/app/modules/profile/update_profile.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../../core/utils/validator.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/followers_model_entity.dart';
import '../../data/model/following_model_entity.dart';
import '../../data/model/friends_model_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/group_model_entity.dart';
import '../../data/model/log_in_model_entity.dart';
import '../../data/model/products_model_entity.dart';
import '../../data/model/profile_model_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_drawer.dart';
import '../../global_widgets/page_input.dart';
import '../home/widgets/posts_view.dart';
import '../home/widgets/product_view.dart';
import '../profile/inner_pages/followers.dart';
import '../profile/inner_pages/following.dart';
import '../setup/interests.dart';
import '../sign_up/sign_up.dart';

class PageScreen extends StatefulWidget {
  const PageScreen({Key? key, required this.page}) : super(key: key);

  final GroupModelEntity page;

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> with TickerProviderStateMixin{
  late TabController tabController;
  PageController pageController = PageController(initialPage: 0, keepPage: true);

  late Animation<Color?> animation;
  late AnimationController controller;

  late Animation<Color?> animation2;
  late AnimationController controller2;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    animation = ColorTween(begin: AppColors.background, end: AppColors.primary).animate(controller)
      ..addListener(() {
        setState(() {

        });
      });

    controller2 = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    animation2= ColorTween(begin: Colors.black, end: Colors.white).animate(controller2)
      ..addListener(() {
        setState(() {

        });
      });

    tabController = TabController(length: 4, vsync: this);
  }

  void animateColorForward() {
    controller.forward();
    controller2.forward();
  }

  void animateColorBackward() {
    controller.animateBack(0);
    controller2.animateBack(0);
  }

  @override
  Widget build(BuildContext context) {
    var top = 0.0;
    var page = widget.page;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeController>(
          id: 'page_screen',
          builder: (controller) {
            var memberCount = 0;
            if(page.numberOfMembers != null) {
              memberCount = page.numberOfMembers!.toInt();
            }

            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    //wrap content height
                    SliverAppBar(
                      expandedHeight: Get.height * 0.43,
                      floating: true,
                      pinned: true,
                      flexibleSpace: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            top = constraints.biggest.height;
                            top == MediaQuery.of(context).padding.top + kToolbarHeight ? animateColorForward() : animateColorBackward();
                            return FlexibleSpaceBar(
                              centerTitle: false,
                              background: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: Get.height * 0.25,
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          height: Get.height * 0.2,
                                          width: Get.width,
                                          child: Image.network(
                                            page.headerImageUrl.toString(),
                                            fit: BoxFit.cover,
                                            loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent? loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Container(
                                                color: Colors.grey[300],
                                              );
                                            },
                                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                              return Container(
                                                color: Colors.grey[300],
                                              );
                                            },
                                          ),
                                        ),
                                        //Profile Image
                                        Positioned(
                                          bottom: 0,
                                          left: 20,
                                          child: Container(
                                            width: Get.width*0.2,
                                            height: Get.width*0.2,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white, width: 2),
                                            ),
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: AppAvatar(
                                                imgUrl: page.imageUrl.toString(),
                                              ),
                                              onPressed: () {
                                                //Get.toNamed(Profile.route);
                                              },
                                            ),
                                          ),
                                        ),
                                        //Edit Profile
                                        Positioned(
                                          bottom: 0,
                                          right: 20,
                                          child: SizedBox(
                                            child: AppButton(
                                              title: 'Edit',
                                              onPressed: () {
                                                controller.imagePaths.clear();
                                              },
                                              borderRadius: 10,
                                              fontColor: AppColors.primary,
                                              bckgrndColor: AppColors.background,
                                              border: Border.all(color: AppColors.primary, width: 1),
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                              fontSize: Get.width * 0.04,
                                              width: Get.width * 0.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: Get.height * 0.01),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${page.name}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: Get.width*0.04,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: Get.height*0.002),
                                        if(page.description.toString() != "null")
                                          Text(
                                            page.description.toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: Get.width*0.04,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: Get.height * 0.01),
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
                                    tabs: [
                                      const Tab(text: 'Posts',iconMargin: EdgeInsets.zero,),
                                      const Tab(text: 'Media',iconMargin: EdgeInsets.zero,),
                                      Tab(text: "Members ($memberCount)",iconMargin: EdgeInsets.zero,),
                                    ],
                                    onTap: (index) {
                                      //pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                                      //controller.update(['profile_page']);
                                    },
                                  ),
                                  const Divider(
                                    height: 0.5,
                                    thickness: 0.5,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              title: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: top == MediaQuery.of(context).padding.top + kToolbarHeight ? 1.0 : 0.0,
                                child: Text(
                                  '${page.name}',
                                  style: AppTextStyle.subtitle1.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: animation2.value,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      actions: [
                        PopupMenuButton(
                            color: Colors.white,
                            icon: Icon(
                              Icons.more_vert,
                              color: animation2.value,
                            ),
                            onSelected: (value) {
                              if (value == 0) {
                                //Get.to(() => const Muted());
                              } else if (value == 1) {
                                //Get.to(() => const Blocked());
                              } else if (value == 2) {
                                //Get.to(() => const Followers());
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 0,
                                child: Text(
                                  "Invite",
                                  style: AppTextStyle.bodyText1.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 1,
                                child: Text(
                                  "Search",
                                  style: AppTextStyle.bodyText1.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text(
                                  "Mute",
                                  style: AppTextStyle.bodyText1.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text(
                                  "Exit",
                                  style: AppTextStyle.bodyText1.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text(
                                  "Report",
                                  style: AppTextStyle.bodyText1.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ])
                      ],
                      backgroundColor: animation.value,
                      systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor: animation.value,
                          statusBarIconBrightness: Brightness.dark,
                          statusBarBrightness: Brightness.dark,
                          systemNavigationBarColor: AppColors.background,
                          systemNavigationBarIconBrightness: Brightness.dark
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: tabController,
                  children: [
                    Column(),
                    Column(),
                    Column(),
                    Column(),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Get.bottomSheet(const WayaBottomSheet(),isScrollControlled: true);
                },
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.add,color: Colors.white),
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    pageController.dispose();
  }
}
