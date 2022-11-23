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
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/CommentModel.dart';
import '../../data/model/InterestsModel.dart';
import '../../data/model/NewInterestModel.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/app_button.dart';

import 'package:dio/dio.dart' as dio;

import '../../global_widgets/app_input.dart';
import '../../global_widgets/newsfeed_multiple_imageview.dart';
import '../../global_widgets/overlays.dart';
import '../../global_widgets/page_input.dart';
import '../home/widgets/group_view.dart';
import '../home/widgets/posts_view.dart';

class AddInterestPage extends StatefulWidget {
  const AddInterestPage({Key? key}) : super(key: key);

  @override
  State<AddInterestPage> createState() => _AddInterestPageState();
}

class _AddInterestPageState extends State<AddInterestPage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    List<String> chosenInterestList = [];
    List<String> interestList = [
      'Others',
      'Travel',
      'Food',
      'Fashion',
      'Music',
      'Sports',
      'Gaming',
      'Movies',
      'TV Shows',
      'Books',
      'Art',
      'Photography',
      'Fitness',
      'Beauty',
      'DIY',
      'Design',
      'Technology',
      'Science',
      'Nature',
      'Animals',
      'History',
      'Politics',
      'Business',
      'Finance',
      'Education',
      'Religion',
      'Health',
      'Parenting',
      'Relationships',
      'Entertainment',
      'News',
      'Lifestyle',
      //generate more interests
      'School',
      'Football',
      'Basketball',
      'Baseball',
      'Soccer',
      'Tennis',
      'Golf',
      'Hockey',
      'Rugby',
      'Volleyball',
      'Swimming',
      'Cycling',
      'Running',
      'Boxing',
      'Wrestling',
      'MMA',
      'Gymnastics',
      'Dancing',
      'Skiing',
      'Snowboarding',
      'Surfing',
      'Skateboarding',
      'Biking',
      'Hiking',
      'Crypto',
      'Stocks',
      'Real Estate',
      'Investing',
      'Trading',
      'Commodities',
      'Forex',
      'Options',
      'Bonds',
      'ETFs',
      'Tech Personalities',
      'Tech Companies',
      'Tech Startups',
      'Tech News',
      'Tech Events',
      'Tech Products',
      'Crypto Personalities',
      'Celebrities',
      'Fashion Personalities',
      'Fashion Brands',
    ];
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeController>(id: "add_interests_page",builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text(
              "Interests",
              style: TextStyle(
                color: const Color(0xff4F4F4F),
                fontSize: Get.textScaleFactor * 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
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
                preferredSize: Size(Get.width, Get.height * 0.06),
                child: Column(
                  children: [
                    const Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
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
                      tabs: const [
                        Tab(text: 'Your Interests',iconMargin: EdgeInsets.zero,),
                        Tab(text: 'All Interests',iconMargin: EdgeInsets.zero,),
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
                )),
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: AppColors.background,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.dark,
                systemNavigationBarColor: AppColors.background,
                systemNavigationBarIconBrightness: Brightness.dark
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              FutureBuilder<ApiResponse>(
                  future: controller.getData("/wayagram-service/graph/user-interest/userInterest?profileId=${fullProfile.id}", true),
                  builder: (context, snapshot) {
                    var savedPosts = ReadWriteValue('wayagram_interests', '', MyPref.box);
                    if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                      final posts = InterestsModel.fromJsonList(snapshot.data!.data);
                      savedPosts.val = jsonEncode(posts);
                      return ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          var post = posts[index];
                          if(!chosenInterestList.contains(post.title)){
                            chosenInterestList.add(post.title.toString());
                          }
                          return InkWell(
                            onTap: (){

                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                              child: Row(
                                children: [
                                  Container(
                                    height: Get.height*0.04,
                                    width: Get.height*0.04,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Icon(Icons.interests, color: Colors.white, size: Get.height*0.02,),
                                  ),
                                  const SizedBox(width: 10,),
                                  Text(post.title.toString(), style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Get.textScaleFactor * 17,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  const Spacer(),
                                  InkWell(
                                    onTap: (){
                                      var innerBody = {
                                        "profileId": fullProfile.id,
                                        "userInterestId" : post.id.toString()
                                      };
                                      controller.deleteData(dio.FormData.fromMap(innerBody), "/wayagram-service/graph/user-interest/deleteUserInterest").then((value) {
                                        if(value.isSuccessful){
                                          controller.userRepo.getData("/wayagram-service/graph/user-interest/userInterest?profileId=${fullProfile.id}").then((valueRes){
                                            if(valueRes.isSuccessful){
                                              var savedPosts = ReadWriteValue('wayagram_interests', '', MyPref.box);
                                              savedPosts.val = jsonEncode(InterestsModel.fromJsonList(valueRes.data));
                                            }
                                            chosenInterestList.remove(post.title.toString());
                                            AppOverlay.showSuccessSnackBar(content: "Interest removed successfully");
                                            controller.update(["add_interests_page"]);
                                          });
                                        }
                                      });
                                    },
                                      child: const Icon(Icons.remove_circle, color: AppColors.primary,)
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if(savedPosts.val.isNotEmpty){
                      var posts = InterestsModel.fromJsonList(jsonDecode(savedPosts.val));
                      return ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          var post = posts[index];
                          if(!chosenInterestList.contains(post.title)){
                            chosenInterestList.add(post.title.toString());
                          }
                          return InkWell(
                            onTap: (){

                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                              child: Row(
                                children: [
                                  Container(
                                    height: Get.height*0.04,
                                    width: Get.height*0.04,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Icon(Icons.interests, color: Colors.white, size: Get.height*0.02,),
                                  ),
                                  const SizedBox(width: 10,),
                                  Text(post.title.toString(), style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Get.textScaleFactor * 17,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  const Spacer(),
                                  InkWell(
                                      onTap: (){
                                        var innerBody = {
                                          "profileId": fullProfile.id,
                                          "userInterestId" : post.id.toString()
                                        };
                                        controller.deleteData(dio.FormData.fromMap(innerBody), "/wayagram-service/graph/user-interest/deleteUserInterest").then((value) {
                                          if(value.isSuccessful){
                                            controller.userRepo.getData("/wayagram-service/graph/user-interest/userInterest?profileId=${fullProfile.id}").then((valueRes){
                                              if(valueRes.isSuccessful){
                                                var savedPosts = ReadWriteValue('wayagram_interests', '', MyPref.box);
                                                savedPosts.val = jsonEncode(InterestsModel.fromJsonList(valueRes.data));
                                              }
                                              chosenInterestList.remove(post.title.toString());
                                              AppOverlay.showSuccessSnackBar(content: "Interest removed successfully");
                                              controller.update(["add_interests_page"]);
                                            });
                                          }
                                        });
                                      },
                                      child: const Icon(Icons.remove_circle, color: AppColors.primary,)
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }else{
                      if(snapshot.connectionState == ConnectionState.done){
                        return const SizedBox.shrink();
                      }
                      return const GroupView(isLoading: true);
                    }
                  }),
              ListView.builder(
                itemCount: interestList.length,
                itemBuilder: (context, index) {
                  var currentInterest = interestList.reversed.toList()[index];
                  if(chosenInterestList.contains(currentInterest)){
                    return const SizedBox.shrink();
                  }
                  return InkWell(
                    onTap: (){

                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                      child: Row(
                        children: [
                          Container(
                            height: Get.height*0.04,
                            width: Get.height*0.04,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(Icons.interests, color: Colors.white, size: Get.height*0.02,),
                          ),
                          const SizedBox(width: 10,),
                          Text(currentInterest, style: TextStyle(
                            color: Colors.black,
                            fontSize: Get.textScaleFactor * 17,
                            fontWeight: FontWeight.w500,
                          ),),
                          const Spacer(),
                          InkWell(
                            onTap: (){
                              var body = {
                                "title": currentInterest,
                                "description" : currentInterest
                              };
                              var formData = dio.FormData.fromMap(body);
                              controller.postData(formData, "/wayagram-service/graph/createInterest").then((value1) {
                                if(value1.isSuccessful){
                                  var res = NewInterestModel.fromJson(value1.data);
                                  var innerBody = {
                                    "profileId": fullProfile.id,
                                    "interestId" : res.id.toString()
                                  };
                                  controller.postData(dio.FormData.fromMap(innerBody), "/wayagram-service/graph/user-interest/selectUserInterest").then((value) {
                                    if(value1.isSuccessful){
                                      controller.userRepo.getData("/wayagram-service/graph/user-interest/userInterest?profileId=${fullProfile.id}").then((valueRes){
                                        if(valueRes.isSuccessful){
                                          var savedPosts = ReadWriteValue('wayagram_interests', '', MyPref.box);
                                          savedPosts.val = jsonEncode(InterestsModel.fromJsonList(valueRes.data));
                                        }
                                        interestList.remove(currentInterest);
                                        AppOverlay.showSuccessSnackBar(content: "Interest added successfully");
                                        controller.update(["add_interests_page"]);
                                      });
                                    }
                                  });
                                }else{
                                  controller.getData("/wayagram-service/graph/search?query=${currentInterest}&filterBy=NAME",true).then((value) {
                                    if(value.isSuccessful){
                                      var res = NewInterestModel.fromJsonList(value.data["data"]);
                                      var innerBody = {
                                        "profileId": fullProfile.id,
                                        "interestId" : res[0].id.toString()
                                      };
                                      controller.postData(dio.FormData.fromMap(innerBody), "/wayagram-service/graph/user-interest/selectUserInterest").then((value) {
                                        if(value.isSuccessful){
                                          controller.userRepo.getData("/wayagram-service/graph/user-interest/userInterest?profileId=${fullProfile.id}").then((valueRes){
                                            if(valueRes.isSuccessful){
                                              var savedPosts = ReadWriteValue('wayagram_interests', '', MyPref.box);
                                              savedPosts.val = jsonEncode(InterestsModel.fromJsonList(valueRes.data));
                                            }
                                            interestList.remove(currentInterest);
                                            AppOverlay.showSuccessSnackBar(content: "Interest added successfully");
                                            controller.update(["add_interests_page"]);
                                          });
                                        }else{
                                          AppOverlay.showErrorSnackBar(content: "Something went wrong, please try again later");
                                        }
                                      });
                                    }
                                  });
                                }
                              });
                            }, child: const Icon(Icons.add_circle, color: AppColors.primary,)
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
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