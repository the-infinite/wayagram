import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:hashtager/widgets/hashtag_text_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/ActivityLogsModel.dart';
import '../../data/model/CommentModel.dart';
import '../../data/model/DonationsModel.dart';
import '../../data/model/InterestsModel.dart';
import '../../data/model/NewInterestModel.dart';
import '../../data/model/all_events_entity.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/donation_statistics.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/people_who_donated.dart';
import '../../data/model/promotion_analytics_model.dart';
import '../../data/model/promotion_list_model.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/app_button.dart';

import 'package:dio/dio.dart' as dio;

import '../../global_widgets/app_input.dart';
import '../../global_widgets/app_refresher.dart';
import '../../global_widgets/newsfeed_multiple_imageview.dart';
import '../../global_widgets/overlays.dart';
import '../../global_widgets/page_input.dart';
import '../home/widgets/group_view.dart';
import '../home/widgets/posts_view.dart';
import '../profile/other_profile.dart';
import '../search/search.dart';
import 'package:timeago/timeago.dart' as timeago;

class EventAnalytics extends StatefulWidget {
  EventAnalytics({Key? key}) : super(key: key);

  @override
  State<EventAnalytics> createState() => _EventAnalyticsState();
}

class _EventAnalyticsState extends State<EventAnalytics> with TickerProviderStateMixin {
  late TabController tabController;
  List<String> closedDonations = [];
  bool moneyRequested = false;
  var controller = Get.find<HomeControllerWayagram>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var donation = Get.arguments as AllEventsData;
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(donation.eventEnd!));
    bool closed = false;

    var savedClosedDonation = ReadWriteValue('wayagram_closed_event${donation.id}', '', MyPref.box);
    var savedMoneyRequested = ReadWriteValue('wayagram_event_money_requested${donation.id}', false, MyPref.box);

    var attendeeCount = 0;
    if(donation.eventParticipants != null){
      attendeeCount = donation.eventParticipants!.length;
    }

    moneyRequested = savedMoneyRequested.val;
    if(savedClosedDonation.val.isNotEmpty){
      closedDonations.clear();
      closedDonations = savedClosedDonation.val.split(',');
      if(closedDonations.contains(donation.id.toString())){
        closed = true;
      }
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeControllerWayagram>(id: "event_analytics",builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        var savedPosts = ReadWriteValue('wayagram_promotion_analytics_log', '', MyPref.box);
        var currentPage = ReadWriteValue('wayagram_promotion_analytics_log_current_page', 1, MyPref.box);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: getAppColor(AppColors.background),
            title: Text(
              "Event Analytics",
              style: TextStyle(
                color: getAppColor(Color(0xff4F4F4F)),
                fontSize: Get.textScaleFactor * 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            leading: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(FeatherIcons.arrowLeft, color: Colors.black)
            ),
            actions: [

            ],
            bottom: PreferredSize(
                preferredSize: Size(Get.width, 0.5),
                child: Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: Colors.grey,
                )),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: getAppColor(AppColors.background),
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.dark,
                systemNavigationBarColor: getAppColor(AppColors.background),
                systemNavigationBarIconBrightness: Brightness.dark
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: Get.height * 0.06,
                    width: Get.width * 0.2,
                    decoration: BoxDecoration(
                      color: getAppColor(AppColors.background),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Attendee",
                          style: TextStyle(
                            color: getAppColor(Color(0xff4F4F4F)),
                            fontSize: Get.textScaleFactor * 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          shortenCount(attendeeCount.toString()),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: Get.textScaleFactor * 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: Get.height * 0.06,
                    width: Get.width * 0.5,
                    decoration: BoxDecoration(
                      color: getAppColor(AppColors.background),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Ending Date",
                          style: TextStyle(
                            color: getAppColor(Color(0xff4F4F4F)),
                            fontSize: Get.textScaleFactor * 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          timeago.format(date,allowFromNow: true),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: Get.textScaleFactor * 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: Get.height * 0.06,
                    width: Get.width * 0.2,
                    decoration: BoxDecoration(
                      color: getAppColor(AppColors.background),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Amount",
                          style: TextStyle(
                            color: getAppColor(Color(0xff4F4F4F)),
                            fontSize: Get.textScaleFactor * 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          donation.isPaid == true ? shortenCount(((attendeeCount - 1) * donation.amount!).toString()) : "Free",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: Get.textScaleFactor * 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.01),
              Padding(
                padding: EdgeInsets.only(left: Get.width * 0.025, right: Get.width * 0.025, top: Get.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: Get.width*0.01),
                      child: Text(donation.eventName.toString(), style: AppTextStyle.subtitle1.copyWith(
                        color: Colors.black,
                        fontSize: Get.width*0.05,
                        fontWeight: FontWeight.w600,
                      )),
                    ),
                    SizedBox(height: Get.height*0.01),
                    Padding(
                      padding: EdgeInsets.only(left: Get.width*0.01),
                      child: Text("${DateFormat.yMMMMEEEEd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(donation.eventStart.toString())))} at  ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(donation.eventStart.toString())))}", style: AppTextStyle.subtitle1.copyWith(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: Get.width*0.04,
                        fontWeight: FontWeight.normal,
                      )),
                    ),
                    SizedBox(height: Get.height*0.01),
                    if(donation.eventOrganizer.toString() != "null")
                      _TextButton(
                        leading: Icon(Icons.people_alt_rounded, color: Colors.black.withOpacity(0.5)),
                        text:donation.eventOrganizer.toString(),
                        onPressed: () {
                        },
                      ),
                    SizedBox(height: Get.height*0.01),
                    _TextButton(
                      leading: Icon(Icons.location_on, color: Colors.black.withOpacity(0.5)),
                      text: donation.location.toString(),
                      onPressed: () {
                      },
                    ),
                    SizedBox(height: Get.height*0.01),
                    _TextButton(
                      leading: Icon(FeatherIcons.tag, color: Colors.black.withOpacity(0.5)),
                      text: donation.isPaid != true ? "Free to attend" : "Paid to attend: NGN ${donation.amount.toString()}",
                      onPressed: () {
                      },
                    ),
                    SizedBox(height: Get.height*0.01),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                height: 0.5,
                thickness: 0.5,
                color: Colors.grey,
              ),
              SizedBox(height: 10,),
              if(!closed)
                AppButton(
                  title: "Close Event",
                  onPressed: () async {
                    var body = {
                      //"action": "close",
                      "event_id": donation.id
                    };
                    //https://services.staging.wayagram.ng/wayagram-service/all-posts/close-event?sso_id=313
                    var response = await controller.deleteData(body, "/wayagram-service/all-posts/close-event");
                    if(response.isSuccessful){
                      closedDonations.add(donation.id.toString());
                      savedClosedDonation.val = closedDonations.join(",");
                      closed = true;
                      controller.update(["event_analytics"]);
                      AppOverlay.showSuccessSnackBar(content: "Event Closed Successfully");
                    }else{
                      AppOverlay.showErrorSnackBar(content: "Unable to close event, please try again later");
                    }
                  },
                  width: Get.width*0.9,
                  borderRadius: 10,
                  fontSize: Get.textScaleFactor * 18,
                ),
              if(closed && !moneyRequested)
                AppButton(
                  title: "Retrieve Money",
                  onPressed: () async {
                    var body = {
                      "item_type": "Event",
                      "item_id": donation.id
                    };
                    //https://services.staging.wayagram.ng/wayagram-serviceall-posts/receive-money?sso_id=313
                    var response = await controller.postData(body, "/wayagram-serviceall-posts/receive-money");
                    if(response.isSuccessful){
                      savedMoneyRequested.val = true;
                      moneyRequested = true;
                      controller.update(["event_analytics"]);
                      AppOverlay.showSuccessSnackBar(content: response.message.toString());
                    }else{
                      if(response.message == "Payment request has already been sent"){
                        savedMoneyRequested.val = true;
                        moneyRequested = true;
                        controller.update(["event_analytics"]);
                      }
                      AppOverlay.showErrorSnackBar(content: response.message.toString());
                    }
                  },
                  width: Get.width*0.9,
                  borderRadius: 10,
                  fontSize: Get.textScaleFactor * 18,
                ),
              if(closed && moneyRequested)
                Text(
                  "Money Requested Already",
                  style: TextStyle(
                    color: getAppColor(Color(0xff4F4F4F)),
                    fontSize: Get.textScaleFactor * 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 10,),
            ],
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}

String shortenCount(String amount){
  if(amount == "null" || amount.isEmpty){
    return "0";
  }
  if(amount.length > 6){
    return "${amount.substring(0, amount.length-6)}M";
  }
  if(amount.length > 3) {
    var first = amount.substring(0, amount.length - 3);
    var last = amount.substring(amount.length - 1, amount.length);
    return "$first.$last K";
  }
  return amount;
}

class _TextButton extends StatelessWidget {
  final Widget leading;
  final String text;
  final Function() onPressed;
  _TextButton({required this.text, required this.onPressed, required this.leading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Get.height*0.018),
        child: Row(children: [
          SizedBox(width: Get.width*0.01),
          leading,
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: AppTextStyle.subtitle1.copyWith(color: Colors.black.withOpacity(0.5)),
            ),
          ),
        ]),
      ),
    );
  }
}
