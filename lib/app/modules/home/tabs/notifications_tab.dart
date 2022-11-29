import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/notification_model_entity.dart';
import '../../../data/model/products_model_entity.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../widgets/notification_view.dart';
import '../widgets/product_view.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({Key? key}) : super(key: key);

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> with TickerProviderStateMixin{
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<HomeController>(builder: (controller) {
      return SizedBox(
        width: Get.width,
        height: Get.height*0.78,
        child: TabBarView(
          controller: controller.notificationController,
          //physics: const NeverScrollableScrollPhysics(),
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<ApiResponse>(
                      future: controller.getNotification,
                      builder: (context, snapshot) {
                        var savedPosts = MyPref.notifications.val;
                        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                          final posts = snapshot.data!.data as NotificationModelEntity;
                          return NotificationView(moments: posts.data!);
                        } else if(savedPosts.isNotEmpty){
                          var posts = NotificationModelEntity.fromJson(jsonDecode(savedPosts));
                          return NotificationView(moments: posts.data!);
                        }else{
                          return const NotificationView(isLoading: true);
                        }
                      }),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  controller: tabController,
                  padding: EdgeInsets.zero,
                  labelColor: Colors.black,
                  unselectedLabelColor: const Color(0xff9A9A9A),
                  indicatorColor: AppColors.primary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: EdgeInsets.only(left: Get.width * 0.02),
                  indicatorPadding: EdgeInsets.zero,
                  tabs: const [
                    Tab(text: 'Friend',iconMargin: EdgeInsets.zero,),
                    Tab(text: 'Events',iconMargin: EdgeInsets.zero,),
                    Tab(text: 'Groups',iconMargin: EdgeInsets.zero,),
                    Tab(text: 'Pages',iconMargin: EdgeInsets.zero,),
                  ],
                ),
                const Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: Get.height*0.71,
                  child: TabBarView(
                      controller: tabController,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<ApiResponse>(
                                  future: controller.getNotification,
                                  builder: (context, snapshot) {
                                    var savedPosts = MyPref.notifications.val;
                                    if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                      final posts = snapshot.data!.data as NotificationModelEntity;
                                      return NotificationView(moments: posts.data!);
                                    } else if(savedPosts.isNotEmpty){
                                      var posts = NotificationModelEntity.fromJson(jsonDecode(savedPosts));
                                      return NotificationView(moments: posts.data!);
                                    }else{
                                      return const NotificationView(isLoading: true);
                                    }
                                  }),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<ApiResponse>(
                                  future: controller.getNotification,
                                  builder: (context, snapshot) {
                                    var savedPosts = MyPref.notifications.val;
                                    if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                      final posts = snapshot.data!.data as NotificationModelEntity;
                                      return NotificationView(moments: posts.data!);
                                    } else if(savedPosts.isNotEmpty){
                                      var posts = NotificationModelEntity.fromJson(jsonDecode(savedPosts));
                                      return NotificationView(moments: posts.data!);
                                    }else{
                                      return const NotificationView(isLoading: true);
                                    }
                                  }),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<ApiResponse>(
                                  future: controller.getNotification,
                                  builder: (context, snapshot) {
                                    var savedPosts = MyPref.notifications.val;
                                    if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                      final posts = snapshot.data!.data as NotificationModelEntity;
                                      return NotificationView(moments: posts.data!);
                                    } else if(savedPosts.isNotEmpty){
                                      var posts = NotificationModelEntity.fromJson(jsonDecode(savedPosts));
                                      return NotificationView(moments: posts.data!);
                                    }else{
                                      return const NotificationView(isLoading: true);
                                    }
                                  }),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<ApiResponse>(
                                  future: controller.getNotification,
                                  builder: (context, snapshot) {
                                    var savedPosts = MyPref.notifications.val;
                                    if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                      final posts = snapshot.data!.data as NotificationModelEntity;
                                      return NotificationView(moments: posts.data!);
                                    } else if(savedPosts.isNotEmpty){
                                      var posts = NotificationModelEntity.fromJson(jsonDecode(savedPosts));
                                      return NotificationView(moments: posts.data!);
                                    }else{
                                      return const NotificationView(isLoading: true);
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ]
                  ),
                )
              ],
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}