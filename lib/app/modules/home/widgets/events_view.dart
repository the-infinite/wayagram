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
import '../../../data/model/moments_model_entity.dart';
import '../../../global_widgets/app_avatar.dart';
import '../../../global_widgets/app_button.dart';

class EventsView extends StatefulWidget {
  const EventsView({
    Key? key,
    this.isLoading = false,
    this.moments,
  }) : super(key: key);

  final bool isLoading;
  final List<AllEventsData>? moments;

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  var userID = "";
  List<AllEventsData> list = [];

  @override
  Widget build(BuildContext context) {
    widget.moments?.forEach((element) {
      if (element.profileId != userID) {
        list.add(element);
        userID = element.profileId.toString();
      }
    });
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
              'Events To Attend',
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
          height: Get.height * 0.285,
          width: Get.width,
          child: ListView.builder(
            itemCount: widget.isLoading ? 5 : list.length,
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
              var interested = 0;
              var going = 0;
              if(list[index].eventLikes != null){
                interested = list[index].eventLikes!.length;
              }
              if(list[index].eventParticipants != null){
                going = list[index].eventParticipants!.length;
              }
              return Container(
                margin: const EdgeInsets.only(top: 5, bottom: 3.7, left: 5,right: 5),
                width: Get.width * 0.45,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: Get.height * 0.12,
                      width: Get.width * 0.45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(.5),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                list[index].eventPoster.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children:  [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(180)),
                                      color: AppColors.background,
                                    ),
                                    width: 30,
                                    height:30,
                                    child: Center(
                                      child: IconButton(
                                        icon: const Icon(
                                          FeatherIcons.heart,
                                          color: Colors.black,
                                          size: 15,
                                        ),
                                        onPressed: (){},
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "Date here",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: Get.height * 0.018,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        list[index].eventName.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Get.height * 0.018,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        list[index].details.toString(),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: Get.height * 0.017,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "$interested Interested $going Going",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: Get.height * 0.017,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: Get.width*0.3,
                            height: Get.height*0.04,
                            child: AppButton(
                              title: 'Register',
                              onPressed: () async {

                              },
                              borderRadius: 5,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              fontSize: Get.height * 0.018,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.share,
                              color: Colors.black,
                              size: 15,
                            ),
                            onPressed: (){},
                          )
                        ],
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