import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/all_events_entity.dart';
import '../../../data/model/full_user_profile_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/app_avatar.dart';
import '../../../global_widgets/app_button.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../global_widgets/payment_widget/wayapay.dart';
import '../../events/pay_for_event.dart';
import '../../events/view_event_details.dart';

class EventsView extends StatefulWidget {
  EventsView({
    Key? key,
    this.isLoading = false,
    this.moments,
    this.title = 'Events To Attend',
    this.buttonText = 'Attend',
    this.actionIcon = Icons.share,
    this.onEventClick,
    this.onActionClick,
    this.onButtonClick,
    this.onLikeClick
  }) : super(key: key);

  final bool isLoading;
  final List<AllEventsData>? moments;
  final String title;
  final String buttonText;
  final IconData actionIcon;
  final Function(AllEventsData data)? onEventClick;
  final Function(AllEventsData data)? onButtonClick;
  final Function(AllEventsData data)? onActionClick;
  final Function(AllEventsData data)? onLikeClick;

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  var userID = "";
  List<AllEventsData> list = [];

  @override
  Widget build(BuildContext context) {
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    list = widget.moments ?? [];


    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Container(
            color: getAppColor(Colors.blue.shade50),
            width: Get.width,
            padding: EdgeInsets.all(8),
            child: Text(
              widget.title,
              style: AppTextStyle.headline4.copyWith(
                color: getAppColor(Colors.black),
                fontWeight: FontWeight.bold,
                fontSize: Get.textScaleFactor * 15,
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
            padding: EdgeInsets.zero,
            // physics: widget.isLoading ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if(widget.isLoading){
                return SizedBox(
                  height: Get.height * 0.18,
                  width: Get.width * 0.35,
                  child: Shimmer.fromColors(
                    baseColor: getAppColor(Colors.grey).withOpacity(0.8),
                    highlightColor: getAppColor(Colors.grey).withOpacity(0.2),
                    child: Container(
                      margin: EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
                      height: Get.height * 0.18,
                      width: Get.width * 0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: getAppColor(Colors.grey).withOpacity(.5),
                      ),
                    ),
                  ),
                );
              }
              var interested = 0;
              var going = 0;
              var isLiked = false;
              if(list[index].eventLikes != null){
                interested = list[index].eventLikes!.length;
                var eventLikedProfileID = list[index].eventLikes!.firstWhere((element) => element.profileId.toString() == profile.id, orElse: () => AllEventsDataEventLikes());
                if(eventLikedProfileID.profileId.toString() == profile.id){
                  isLiked = true;
                }
                if(widget.title.trim() == 'Liked Events'){
                  if(isLiked == false){
                    return SizedBox.shrink();
                  }
                }
              }else{
                if(widget.title.trim() == 'Liked Events'){
                  if(isLiked == false){
                    return SizedBox.shrink();
                  }
                }
              }

              if(widget.title.trim() == 'All Events'){
                if(list[index].profileId.toString() == profile.id){
                  return SizedBox.shrink();
                }
              }

              if(list[index].eventParticipants != null){
                going = list[index].eventParticipants!.length;
              }
              var date = DateTime.fromMillisecondsSinceEpoch(int.parse(list[index].eventStart!));
              var time = timeago.format(date);
              var isEnded = date.isBefore(DateTime.now());
              isEnded = false;
              return Container(
                margin: EdgeInsets.only(top: Get.height*0.007, left: Get.width*0.02,right: Get.width*0.02,bottom: Get.height*0.007),
                width: Get.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: getAppColor(Colors.white),
                  boxShadow: [
                    BoxShadow(
                      color: getAppColor(Colors.grey).withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    if(widget.onEventClick != null){
                      widget.onEventClick!(list[index]);
                    }else{
                      Get.to(() => ViewEventDetails(event: list[index]));
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: Get.height * 0.12,
                        width: Get.width * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: getAppColor(Colors.grey[200]!),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: getAppColor(Colors.white),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: list[index].eventPoster.toString(), placeholder: (context, url) => Container(
                                    color: Colors.transparent,
                                    child: Icon(Icons.image_rounded,color: getAppColor(Colors.grey),size: Get.height*0.04),
                                  ),
                                    errorWidget: (context, url, error) => Container(
                                        color: Colors.transparent,
                                        child: Icon(Icons.event_rounded,color: getAppColor(Colors.grey),size: Get.height*0.04)
                                    ),
                                    fit: BoxFit.cover,
                                  ),
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
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(180)),
                                        color: getAppColor(AppColors.background),
                                      ),
                                      width: 30,
                                      height:30,
                                      child: Center(
                                        child: IconButton(
                                          icon: Icon(
                                            isLiked ?  Icons.favorite : FeatherIcons.heart,
                                            color: isLiked ? AppColors.primary : getAppColor(Colors.black),
                                            size: 15,
                                          ),
                                          onPressed: (){
                                            if(widget.onLikeClick != null){
                                              widget.onLikeClick!(list[index]);
                                            }
                                          },
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
                        padding: EdgeInsets.only(left: Get.width*0.02,right: Get.width*0.02,top: Get.height*0.01),
                        child: Text(
                          time.capitalizeFirst.toString(),
                          style: TextStyle(
                            color: getAppColor(Colors.grey.shade600),
                            fontSize: Get.height * 0.018,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Get.width*0.02,right: Get.width*0.02,),
                        child: Text(
                          list[index].eventName.toString(),
                          style: TextStyle(
                            color: getAppColor(Colors.black),
                            fontSize: Get.height * 0.018,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Get.width*0.02,right: Get.width*0.02,),
                        child: Text(
                          list[index].details.toString(),
                          style: TextStyle(
                            color: getAppColor(Colors.grey.shade600),
                            fontSize: Get.height * 0.017,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Get.width*0.02,right: Get.width*0.02,),
                        child: Text(
                          "$interested Interested $going Going",
                          style: TextStyle(
                            color: getAppColor(Colors.grey.shade600),
                            fontSize: Get.height * 0.017,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Get.width*0.02,right: Get.width*0.05,top: Get.height*0.015),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: Get.width*0.33,
                              child: AppButton(
                                title: (isEnded && (widget.buttonText != 'Delete')) ? "Ended" : widget.buttonText,
                                onPressed: () async {
                                  if(widget.onButtonClick != null){
                                    widget.onButtonClick!(list[index]);
                                  }else{
                                    if(list[index].profileId.toString() != profile.id){
                                      var event = list[index];
                                      Get.to(PayForEvent(post: event));
                                      //await WayapayUtil().pay(context, amount: event.amount ?? 0, description: "Payment For Event",isTest: true);
                                    }else{
                                      Get.to(() => ViewEventDetails(event: list[index]));
                                    }
                                  }
                                },
                                borderRadius: 10,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                fontSize: Get.height * 0.018,
                                bckgrndColor: (isEnded && (widget.buttonText != 'Delete')) ? getAppColor(Colors.grey) : AppColors.primary,
                              ),
                            ),
                            SizedBox(
                              height: Get.height*0.03,
                              child: InkWell(
                                onTap: () async {
                                  if(widget.onActionClick != null){
                                    widget.onActionClick!(list[index]);
                                  }else{
                                    await Share.share('https://app.staging.wayagram.ng/events/${list[index].id}"?from=shared"', subject: 'Invite');
                                  }
                                },
                                child: Icon(
                                  widget.actionIcon,
                                  color: getAppColor(Colors.black),
                                  size: Get.width*0.05,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}