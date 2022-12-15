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

class DonationAnalytics extends StatefulWidget {
  const DonationAnalytics({Key? key}) : super(key: key);

  @override
  State<DonationAnalytics> createState() => _DonationAnalyticsState();
}

class _DonationAnalyticsState extends State<DonationAnalytics> with TickerProviderStateMixin {
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
    var donation = Get.arguments as DonationsModel;
    bool closed = donation.isClosed == true;
    RefreshController refreshController = RefreshController(initialRefresh: false);
    var savedAnalytics = ReadWriteValue('wayagram_post_promotion_overview', '', MyPref.box);

    var savedDonationAnalytics = ReadWriteValue('wayagram_donation_statistics_${donation.id}', '', MyPref.box);
    var savedClosedDonation = ReadWriteValue('wayagram_closed_donation${donation.id}', '', MyPref.box);
    var savedMoneyRequested = ReadWriteValue('wayagram_donation_money_requested${donation.id}', false, MyPref.box);

    moneyRequested = savedMoneyRequested.val;
    if(savedClosedDonation.val.isNotEmpty){
      closedDonations.clear();
      closedDonations = savedClosedDonation.val.split(',');
      if(closedDonations.contains(donation.id.toString())){
        closed = true;
      }
    }
    List<PeopleWhoDonated> peopleWhoDonated = PeopleWhoDonated.fromJsonList(jsonDecode(savedDonationAnalytics.val)['data']);
    DonationStatistics donationStatistics = DonationStatistics.fromJson(jsonDecode(savedDonationAnalytics.val)['statistics']);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeControllerWayagram>(id: "donation_analytics",builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        var savedPosts = ReadWriteValue('wayagram_promotion_analytics_log', '', MyPref.box);
        var currentPage = ReadWriteValue('wayagram_promotion_analytics_log_current_page', 1, MyPref.box);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text(
              "Donation Analytics",
              style: TextStyle(
                color: const Color(0xff4F4F4F),
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
                child: const Icon(FeatherIcons.arrowLeft, color: Colors.black)
            ),
            bottom: PreferredSize(
                preferredSize: Size(Get.width, 0.5),
                child: const Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: Colors.grey,
                )),
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: AppColors.background,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.dark,
                systemNavigationBarColor: AppColors.background,
                systemNavigationBarIconBrightness: Brightness.dark
            ),
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: Get.height * 0.06,
                    width: Get.width * 0.2,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Donors",
                          style: TextStyle(
                            color: const Color(0xff4F4F4F),
                            fontSize: Get.textScaleFactor * 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          shortenCount(donationStatistics.totalDonates.toString()),
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
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Expiry Date",
                          style: TextStyle(
                            color: const Color(0xff4F4F4F),
                            fontSize: Get.textScaleFactor * 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          timeago.format(DateTime.fromMillisecondsSinceEpoch(int.parse(donation.donationExpiresAt!)),allowFromNow: true),
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
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Raised",
                          style: TextStyle(
                            color: const Color(0xff4F4F4F),
                            fontSize: Get.textScaleFactor * 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "₦ ${shortenCount(donationStatistics.amountRaised.toString())}",
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
              const SizedBox(
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
                    child: peopleWhoDonated.isEmpty ?
                    SizedBox(
                      width: Get.width,
                      height: Get.height,
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(height: Get.height*0.2,),
                            Icon(Icons.money_rounded, color: AppColors.primary, size: Get.height*0.1,),
                            const SizedBox(height: 20,),
                            Text("No Donations Yet", style: TextStyle(
                              color: Colors.grey,
                              fontSize: Get.textScaleFactor * 17,
                              fontWeight: FontWeight.w500,
                            ),),
                          ],
                        ),
                      ),
                    ) :
                    ListView.builder(
                      itemCount: peopleWhoDonated.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var post = peopleWhoDonated[index];
                        return InkWell(
                          onTap: (){
                            if(post.donatorProfile != null){
                              var person = post.donatorProfile!;
                              Get.to(() => const OtherProfile(),arguments: [
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
                                    imgUrl: post.donatorProfile!.avatar.toString(),
                                    radius: 100,
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: Get.width*0.7,
                                      child: HashTagText(text: post.donatorProfile!.displayName.toString(), decoratedStyle: TextStyle(
                                        color: Colors.blue,
                                        fontSize: Get.textScaleFactor * 17,
                                        fontWeight: FontWeight.w500,
                                      ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                        color: Colors.black,
                                        fontSize: Get.textScaleFactor * 17,
                                        fontWeight: FontWeight.w500,),
                                        softWrap: true,
                                        onTap: (text) {
                                          controller.defaultSearchValue = text;
                                          Get.to(() => const Search());
                                        },
                                        decorateAtSign: true,
                                      ),
                                    ),
                                    Text("₦${post.amount.toString()}", style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: Get.textScaleFactor * 15,
                                      fontWeight: FontWeight.w500,
                                    ),),
                                    Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(post.createdAt.toString())), style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: Get.textScaleFactor * 15,
                                      fontWeight: FontWeight.w500,
                                    ),),
                                  ],
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(
                height: 0.5,
                thickness: 0.5,
                color: Colors.grey,
              ),
              const SizedBox(height: 10,),
              if(!closed)
                AppButton(
                title: "Close Donation",
                onPressed: () async {
                  var body = {
                    "action": "close",
                    "donation_id": donation.id
                  };
                  var response = await controller.patchData(body, "/wayagram-service/all-posts/manage-donation");
                  if(response.isSuccessful){
                    closedDonations.add(donation.id.toString());
                    savedClosedDonation.val = closedDonations.join(",");
                    closed = true;
                    controller.update(['donation_analytics']);
                    AppOverlay.showSuccessSnackBar(content: "Donation Closed Successfully");
                  }else{
                    AppOverlay.showErrorSnackBar(content: "Unable to close donation post, please try again later");
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
                      "item_type": "Donation",
                      "item_id": donation.id
                    };
                    var response = await controller.postData(body, "/wayagram-serviceall-posts/receive-money");
                    if(response.isSuccessful){
                      savedMoneyRequested.val = true;
                      moneyRequested = true;
                      controller.update(['donation_analytics']);
                      AppOverlay.showSuccessSnackBar(content: response.message.toString());
                    }else{
                      if(response.message == "Payment request has already been sent"){
                        savedMoneyRequested.val = true;
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
                    color: const Color(0xff4F4F4F),
                    fontSize: Get.textScaleFactor * 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 10,),
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
