import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../data/model/notification_model_entity.dart';
import '../../../global_widgets/app_avatar.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({
    Key? key,
    this.isLoading = false,
    this.moments,
  }) : super(key: key);

  final bool isLoading;
  final List<NotificationModelData>? moments;

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  var userID = "";
  List<NotificationModelData> list = [];

  @override
  Widget build(BuildContext context) {
    var isLoading = widget.isLoading;
    var posts = widget.moments;
    return ListView.builder(
      itemCount: isLoading ? 3 : posts!.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if(isLoading){
          return SizedBox(
            height: Get.height * 0.08,
            width: Get.width * 0.35,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.8),
              highlightColor: Colors.grey.withOpacity(0.2),
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
                height: Get.height * 0.18,
                width: Get.width * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(.5),
                ),
              ),
            ),
          );
        }
        var post = posts![index];
        return Container(
          margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: IconButton(
                  icon: AppAvatar(
                    imgUrl: post.profile == null ? "" : post.profile!.avatar.toString(),
                    radius: 50,
                    isNotification: true,
                  ),
                  onPressed: null,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width*0.8,
                    child: Text(
                      post.title.toString().capitalizeFirst.toString(),
                      style: TextStyle(
                        color: getAppColor(Colors.black) ,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width*0.8,
                    child: Text(
                      (post.content.toString()),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}