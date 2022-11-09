import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/all_events_entity.dart';
import '../../../data/model/friends_suggestions_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../global_widgets/app_avatar.dart';
import '../../../global_widgets/app_button.dart';

class FriendsView extends StatefulWidget {
  const FriendsView({
    Key? key,
    this.isLoading = false,
    this.data = const [],
  }) : super(key: key);

  final bool isLoading;
  final List<FriendsSuggestionsEntity> data;

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            color: Colors.blue.shade50,
            width: Get.width,
            padding: const EdgeInsets.all(10),
            child: Text(
              'People To Follow',
              style: AppTextStyle.headline4.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        SizedBox(
          height: Get.height * 0.25,
          width: Get.width,
          child: ListView.builder(
            itemCount: widget.isLoading ? 5 : widget.data.length,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            // physics: widget.isLoading ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if(widget.isLoading){
                return SizedBox(
                  height: Get.height * 0.18,
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
              var person = widget.data[index];

              return Container(
                margin: const EdgeInsets.only(top: 5, bottom: 3.7, left: 5,right: 5),
                width: Get.width * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: Get.height * 0.01),
                    SizedBox(
                      width: Get.width * 0.2,
                      height: Get.width * 0.2,
                      child: IconButton(
                        icon: AppAvatar(
                          imgUrl: person.avatar.toString(),
                          radius: 50,
                        ),
                        onPressed: null,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.0025),
                    Text(
                      person.displayName.toString(),
                      style: const TextStyle(
                        color: Colors.black ,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "@${person.username}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Get.height * 0.02),
                    SizedBox(
                      width: Get.width * 0.3,
                      child: AppButton(
                        title: 'Follow',
                        onPressed: () {

                        },
                        borderRadius: 10,
                        fontColor: AppColors.primary,
                        bckgrndColor: AppColors.background,
                        border: Border.all(color: AppColors.primary, width: 1),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: Get.height * 0.015),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}