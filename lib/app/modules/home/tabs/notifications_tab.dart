import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../controllers/home_controller.dart';
import '../../../data/model/notification_model_entity.dart';
import '../../../data/model/products_model_entity.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../widgets/notification_view.dart';
import '../widgets/product_view.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<HomeController>(builder: (controller) {
      return SizedBox(
        width: Get.width,
        height: Get.height*0.71,
        child: TabBarView(
          controller: controller.notificationController,
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

                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}