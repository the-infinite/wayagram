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
import '../../data/model/all_posts_entity.dart';
import '../../data/model/donation_statistics.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/people_who_donated.dart';
import '../../data/model/poll_details.dart';
import '../../data/model/poll_votes.dart';
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

class PollAnalytics extends StatefulWidget {
  PollAnalytics({Key? key}) : super(key: key);

  @override
  State<PollAnalytics> createState() => _PollAnalyticsState();
}

class _PollAnalyticsState extends State<PollAnalytics> with TickerProviderStateMixin {
  late TabController tabController;
  List<String> closedPoll = [];
  bool moneyRequested = false;
  var controller = Get.find<HomeControllerWayagram>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var poll = Get.arguments as AllPostsPoll;
    bool closed = false;
    RefreshController refreshController = RefreshController(initialRefresh: false);
    var savedClosedPoll = ReadWriteValue('wayagram_closed_poll${poll.id}', '', MyPref.box);
    var savedMoneyRequested = ReadWriteValue('wayagram_poll_money_requested${poll.id}', false, MyPref.box);

    var savedPollAnalytics = ReadWriteValue('wayagram_poll_statistics_${poll.id}', '', MyPref.box);
    var savedVotes = ReadWriteValue('wayagram_poll_votes_${poll.id}', '', MyPref.box);

    PollDetails pollStatistics = PollDetails.fromJson(jsonDecode(savedPollAnalytics.val));
    List<PollVotesProfile> pollVotes = [];
    if(savedVotes.val.isNotEmpty){
      pollVotes = PollVotesProfile.fromJsonList(jsonDecode(savedVotes.val));
    }
    int total = 0;
    if(pollStatistics.pollVotes != null){
      if(pollStatistics.isPaid == true){
        total = int.parse((pollStatistics.pollVotes!.length * pollStatistics.amount!).toString());
      }
    }

    moneyRequested = savedMoneyRequested.val;
    if(savedClosedPoll.val.isNotEmpty){
      closedPoll.clear();
      closedPoll = savedClosedPoll.val.split(',');
      if(closedPoll.contains(poll.id.toString())){
        closed = true;
      }
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(id: "donation_analytics",builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        var savedPosts = ReadWriteValue('wayagram_promotion_analytics_log', '', MyPref.box);
        var currentPage = ReadWriteValue('wayagram_promotion_analytics_log_current_page', 1, MyPref.box);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: getAppColor(AppColors.background),
            title: Text(
              "Poll Analytics",
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
                child: Icon(FeatherIcons.arrowLeft, color: getAppColor(Colors.black))
            ),
            bottom: PreferredSize(
                preferredSize: Size(Get.width, 0.5),
                child: Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: Colors.grey,
                )),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: getAppColor(AppColors.background),
                statusBarIconBrightness: getAppBrightness(),
                statusBarBrightness: getAppBrightness(),
                systemNavigationBarColor: getAppColor(AppColors.background),
                systemNavigationBarIconBrightness: getAppBrightness()
            ),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: getAppColor(AppColors.background),
            child: Column(
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
                            "Votes",
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
                           shortenCount(pollStatistics.pollVotes == null ? "0" : pollStatistics.pollVotes!.length.toString()),
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
                            "End Date",
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
                            timeago.format(DateTime.parse(pollStatistics.endDate.toString()),allowFromNow: true),
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
                            pollStatistics.isPaid == true ?  "NGN  ${shortenCount(total.toString())}" : "Free",
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
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: AppRefresher(
                    onRefresh: () {

                    },
                    onLoading: () {

                    },
                    enablePullDown: false,
                    enablePullUp: false,
                    controller: refreshController,
                    child: SingleChildScrollView(
                      child: pollVotes.isEmpty ?
                      SizedBox(
                        width: Get.width,
                        height: Get.height * 0.5,
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(height: Get.height*0.2,),
                              Icon(Icons.poll_rounded, color: AppColors.primary, size: Get.height*0.1,),
                              SizedBox(height: 20,),
                              Text("No Votes Yet", style: TextStyle(
                                color: Colors.grey,
                                fontSize: Get.textScaleFactor * 17,
                                fontWeight: FontWeight.w500,
                              ),),
                            ],
                          ),
                        ),
                      ) :
                      ListView.builder(
                        itemCount: pollVotes.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var post = pollVotes[index];
                          var widget =  InkWell(
                            onTap: (){
                              if(post.voterProfile != null){
                                var person = post.voterProfile!;
                                Get.to(() => OtherProfile(),arguments: [
                                  person.displayName.toString(),
                                  person.username.toString(),
                                  person.avatar.toString(),
                                  person.userId.toString(),
                                  person.bio.toString(),
                                  person.posts.toString(),
                                  person.followers.toString(),
                                  person.followings.toString(),
                                  person.coverImage.toString(),
                                  person.id.toString(),
                                  person.notPublic == true ? "true" : "false"
                                ]);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: Get.height*0.04,
                                    width: Get.height*0.04,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: AppAvatar(
                                      imgUrl: post.voterProfile!.avatar.toString(),
                                      radius: 100,
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: Get.width*0.7,
                                        child: HashTagText(text: post.voterProfile!.displayName.toString(), decoratedStyle: TextStyle(
                                          color: Colors.blue,
                                          fontSize: Get.textScaleFactor * 17,
                                          fontWeight: FontWeight.w500,
                                        ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                          color: getAppColor(Colors.black),
                                          fontSize: Get.textScaleFactor * 17,
                                          fontWeight: FontWeight.w500,),
                                          softWrap: true,
                                          onTap: (text) {
                                            controller.defaultSearchValue = text;
                                            Get.to(() => Search());
                                          },
                                          decorateAtSign: true,
                                        ),
                                      ),
                                      Text(post.choice.toString(), style: TextStyle(
                                        color: AppColors.button,
                                        fontSize: Get.textScaleFactor * 15,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                     /* Text("NGN ${pollStatistics.amount!.toString()}", style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: Get.textScaleFactor * 15,
                                        fontWeight: FontWeight.w500,
                                      ),),*/
                                      Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(post.createdAt.toString())), style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: Get.textScaleFactor * 15,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          );
                          return widget;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            color: getAppColor(AppColors.background),
            child: Column(
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
                  title: "Close Poll",
                  onPressed: () async {
                    var body = {
                      "action": "close",
                      "poll_id": poll.id
                    };
                    //https://services.staging.wayagram.ng/wayagram-service/all-posts/manage-poll-post?sso_id=313
                    var response = await controller.patchData(body, "/wayagram-service/all-posts/manage-poll-post");
                    if(response.isSuccessful){
                      closedPoll.add(poll.id.toString());
                      savedClosedPoll.val = closedPoll.join(",");
                      closed = true;
                      controller.update(['donation_analytics']);
                      AppOverlay.showSuccessSnackBar(content: "Poll Closed Successfully");
                    }else{
                      AppOverlay.showErrorSnackBar(content: "Unable to close poll, please try again later");
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
                        "item_type": "Poll",
                        "item_id": poll.id
                      };
                      var response = await controller.postData(body, "/wayagram-serviceall-posts/receive-money");
                      if(response.isSuccessful){
                        //savedMoneyRequested.val = true;
                        moneyRequested = true;
                        controller.update(['donation_analytics']);
                        AppOverlay.showSuccessSnackBar(content: response.message.toString());
                      }else{
                        if(response.message == "Payment request has already been sent"){
                          //savedMoneyRequested.val = true;
                          moneyRequested = true;
                          controller.update(['donation_analytics']);
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