import 'dart:convert';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wayagram/app/data/model/SearhPeopleModel.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';
import 'package:wayagram/core/utils/validator.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/SearchHashtagsModel.dart';
import '../../data/model/TrendingHashtagsModel.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/group_model_entity.dart';
import '../../data/model/products_model_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/document_picker.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';
import 'package:dio/dio.dart' as dio;

import '../../global_widgets/person_view.dart';
import '../../global_widgets/wayagram_images_helpers/wayagram_image_helper.dart';
import '../home/widgets/HashTagView.dart';
import '../home/widgets/bottom_sheet.dart';
import '../home/widgets/group_view.dart';
import '../home/widgets/posts_view.dart';
import '../home/widgets/product_view.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  static const route = '/search';

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with TickerProviderStateMixin{
  var homeController = Get.find<HomeControllerWayagram>();
  var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
  var searchController = TextEditingController();
  var searchedPosts = "";
  var searchedPeople = "";
  var searchedGroups = "";
  var searchedPages = "";
  var searchedHashtags = "";
  var searchedProducts = "";
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 6, vsync: this,initialIndex: homeController.defaultSearchPos);
    searchController.text = homeController.defaultSearchValue;
    homeController.defaultSearchValue = "";
    searchController.addListener(() {
      if(searchController.text.isNotEmpty) {
        homeController.update(['search']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<HomeControllerWayagram>(
        id: 'search',
        builder: (controller) {
          return Scaffold(
            backgroundColor: getAppColor(AppColors.background),
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: getAppColor(Colors.black),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              title: Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.02,bottom: Get.height * 0.02),
                  child: PageInput(
                    hint: 'Search',
                    label: '',
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    borderRadius: 180,
                  ),
                ),
              titleSpacing: 5,
              centerTitle: false,
              backgroundColor: getAppColor(AppColors.background),
              bottom: PreferredSize(
                preferredSize: Size(Get.width, Get.height * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TabBar(
                      controller: tabController,
                      padding: EdgeInsets.zero,
                      labelColor: getAppColor(Colors.black),
                      unselectedLabelColor: const Color(0xff9A9A9A),
                      indicatorColor: AppColors.primary,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding: EdgeInsets.only(left: Get.width * 0.025, right:  Get.width * 0.025),
                      indicatorPadding: EdgeInsets.zero,
                      isScrollable: true,
                      tabs: [
                        SizedBox(
                            width:  Get.width * 0.2,
                            child: const Tab(text: 'Hashtags',iconMargin: EdgeInsets.zero,)
                        ),
                        SizedBox(
                            width:  Get.width * 0.2,
                            child: const Tab(text: 'Posts',iconMargin: EdgeInsets.zero,)
                        ),
                        SizedBox(
                            width:  Get.width * 0.2,child: const Tab(text: 'People',iconMargin: EdgeInsets.zero,)),
                        SizedBox(
                            width:  Get.width * 0.2,child: const Tab(text: 'Groups',iconMargin: EdgeInsets.zero,)),
                        SizedBox(
                            width:  Get.width * 0.2,child: const Tab(text: 'Pages',iconMargin: EdgeInsets.zero,)),
                        SizedBox(
                            width:  Get.width * 0.2,child: const Tab(text: 'Product',iconMargin: EdgeInsets.zero,)),
                      ],
                    ),
                    const Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    IconlyLight.filter,
                    color: getAppColor(Colors.black),
                  ),
                  onPressed: () {
                    Get.bottomSheet(
                        const FilterBottomSheet(

                        ),
                        isScrollControlled: true
                    );
                  },
                )
              ],
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: getAppBrightness(),
                  statusBarBrightness: getAppBrightness(),
                  systemNavigationBarColor: getAppColor(AppColors.background),
                  systemNavigationBarIconBrightness: getAppBrightness()
              ),
            ),
            body: Container(
              color: getAppColor(AppColors.background),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        //Hashtags
                        SingleChildScrollView(
                          child: FutureBuilder<ApiResponse>(
                              future: controller.getData("/wayagram-service/all-posts/search-hashtags?query=${searchController.text.replaceAll("#", "").replaceAll("@","")}", true),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                  final posts = SearchHashtagsModel.listFromJson(snapshot.data!.data);

                                  if(controller.searchFilter == "Most Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Most Engaged"){
                                    posts.sort((a,b) {
                                      return b.postToHashtags!.length.compareTo(a.postToHashtags!.length);
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Engaged"){
                                    posts.sort((a,b) {
                                      return a.postToHashtags!.length.compareTo(b.postToHashtags!.length);
                                    });
                                  }

                                  searchedHashtags = jsonEncode(posts);
                                  List<String> title = [];
                                  List<String> subtitle = [];
                                  for (var element in posts) {
                                    if(element.hashtag != null){
                                      title.add(element.hashtag!);
                                      if(element.postToHashtags != null){
                                        subtitle.add('${element.postToHashtags!.length} Conversations');
                                      }else{
                                        subtitle.add('0 Conversations');
                                      }
                                    }
                                  }
                                  return HashTagView(
                                    title: title,
                                    subtitle: subtitle,
                                    onClick: (title, subtitle) {
                                      controller.defaultSearchValue = title;
                                      searchController.text = title;
                                      tabController.animateTo(1);
                                    },
                                  );
                                } else if(searchedHashtags.isNotEmpty){
                                  var posts = SearchHashtagsModel.listFromJson(jsonDecode(searchedHashtags));

                                  if(controller.searchFilter == "Most Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Most Engaged"){
                                    posts.sort((a,b) {
                                      return b.postToHashtags!.length.compareTo(a.postToHashtags!.length);
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Engaged"){
                                    posts.sort((a,b) {
                                      return a.postToHashtags!.length.compareTo(b.postToHashtags!.length);
                                    });
                                  }

                                  List<String> title = [];
                                  List<String> subtitle = [];
                                  for (var element in posts) {
                                    if(element.hashtag != null){
                                      title.add(element.hashtag!);
                                      if(element.postToHashtags != null){
                                        subtitle.add('${element.postToHashtags!.length} Conversations');
                                      }else{
                                        subtitle.add('0 Conversations');
                                      }
                                    }
                                  }
                                  return HashTagView(
                                    title: title,
                                    subtitle: subtitle,
                                    onClick: (title, subtitle) {
                                      tabController.animateTo(1);
                                      controller.defaultSearchValue = title;
                                      searchController.text = title;
                                    },
                                  );
                                }else{
                                  if(searchController.text.isEmpty && snapshot.connectionState == ConnectionState.done){
                                    return SizedBox(
                                      height: Get.height * 0.7,
                                      child: const Center(
                                        child: Text('Enter a search term to search for hashtags'),
                                      ),
                                    );
                                  }
                                  return const GroupView(isLoading: true);
                                }
                              }),
                        ),
                        //Posts
                        SingleChildScrollView(
                          child: FutureBuilder<ApiResponse>(
                              future: controller.searchPost(searchController.text.replaceAll("#", "").replaceAll("@","")),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                  searchedPosts = jsonEncode(snapshot.data!.data);
                                  var posts = AllPostsEntity.getService(snapshot.data!.data);

                                  if(controller.searchFilter == "Most Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Most Engaged"){
                                    posts.sort((a,b) {
                                      if(a.engagement != null && b.engagement != null){
                                        var totalA = (a.engagement!.likeCount ?? 0) + (a.engagement!.repostCount ?? 0) + (a.engagement!.commentCount ?? 0);
                                        var totalB = (b.engagement!.likeCount ?? 0) + (b.engagement!.repostCount ?? 0) + (b.engagement!.commentCount ?? 0);
                                        return totalB.compareTo(totalA);
                                      }else{
                                        var totalA = (a.likeCount ?? 0) + (double.tryParse(a.repostCount.toString()) ?? 0) + (double.tryParse(a.commentCount.toString()) ?? 0);
                                        var totalB = (b.likeCount ?? 0) + (double.tryParse(b.repostCount.toString()) ?? 0) + (double.tryParse(b.commentCount.toString()) ?? 0);
                                        return totalB.compareTo(totalA);
                                      }
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Engaged"){
                                    posts.sort((a,b) {
                                      if(a.engagement != null && b.engagement != null){
                                        var totalA = (a.engagement!.likeCount ?? 0) + (a.engagement!.repostCount ?? 0) + (a.engagement!.commentCount ?? 0);
                                        var totalB = (b.engagement!.likeCount ?? 0) + (b.engagement!.repostCount ?? 0) + (b.engagement!.commentCount ?? 0);
                                        return totalA.compareTo(totalB);
                                      }else{
                                        var totalA = (a.likeCount ?? 0) + (double.tryParse(a.repostCount.toString()) ?? 0) + (double.tryParse(a.commentCount.toString()) ?? 0);
                                        var totalB = (b.likeCount ?? 0) + (double.tryParse(b.repostCount.toString()) ?? 0) + (double.tryParse(b.commentCount.toString()) ?? 0);
                                        return totalA.compareTo(totalB);
                                      }
                                    });
                                  }

                                  return PostsView(posts: posts);
                                }
                                else if(searchedPosts.isNotEmpty){
                                  var posts = AllPostsEntity.getService(jsonDecode(searchedPosts));

                                  if(controller.searchFilter == "Most Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Most Engaged"){
                                    posts.sort((a,b) {
                                      if(a.engagement != null && b.engagement != null){
                                        var totalA = (a.engagement!.likeCount ?? 0) + (a.engagement!.repostCount ?? 0) + (a.engagement!.commentCount ?? 0);
                                        var totalB = (b.engagement!.likeCount ?? 0) + (b.engagement!.repostCount ?? 0) + (b.engagement!.commentCount ?? 0);
                                        return totalB.compareTo(totalA);
                                      }else{
                                        var totalA = (a.likeCount ?? 0) + (double.tryParse(a.repostCount.toString()) ?? 0) + (double.tryParse(a.commentCount.toString()) ?? 0);
                                        var totalB = (b.likeCount ?? 0) + (double.tryParse(b.repostCount.toString()) ?? 0) + (double.tryParse(b.commentCount.toString()) ?? 0);
                                        return totalB.compareTo(totalA);
                                      }
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Engaged"){
                                    posts.sort((a,b) {
                                      if(a.engagement != null && b.engagement != null){
                                        var totalA = (a.engagement!.likeCount ?? 0) + (a.engagement!.repostCount ?? 0) + (a.engagement!.commentCount ?? 0);
                                        var totalB = (b.engagement!.likeCount ?? 0) + (b.engagement!.repostCount ?? 0) + (b.engagement!.commentCount ?? 0);
                                        return totalA.compareTo(totalB);
                                      }else{
                                        var totalA = (a.likeCount ?? 0) + (double.tryParse(a.repostCount.toString()) ?? 0) + (double.tryParse(a.commentCount.toString()) ?? 0);
                                        var totalB = (b.likeCount ?? 0) + (double.tryParse(b.repostCount.toString()) ?? 0) + (double.tryParse(b.commentCount.toString()) ?? 0);
                                        return totalA.compareTo(totalB);
                                      }
                                    });
                                  }

                                  return PostsView(posts: posts);
                                }else{
                                  if(searchController.text.isEmpty && snapshot.connectionState == ConnectionState.done){
                                    return SizedBox(
                                      height: Get.height * 0.7,
                                      child: const Center(
                                        child: Text('Enter a search term to search for posts'),
                                      ),
                                    );
                                  }
                                  return const PostsView(isLoading: true);
                                }
                              }),
                        ),
                        //People
                        SingleChildScrollView(
                          child: FutureBuilder<ApiResponse>(
                              future: controller.searchPeople(searchController.text.replaceAll("#", "").replaceAll("@","")),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                  //final posts = snapshot.data!.suggestion as List<GroupModelEntity>;
                                  searchedPeople = jsonEncode(snapshot.data!.data);
                                  var posts = SearchPeopleModel.getService(snapshot.data!.data);

                                  return PersonView(
                                    name: posts.map((e) => e.displayName.toString()).toList(),
                                    username: posts.map((e) => e.username.toString()).toList(),
                                    profilePic: posts.map((e) => e.avatar.toString()).toList(),
                                    length: posts.length,
                                    userIDs: posts.map((e) => e.userId.toString()).toList(),
                                    iDs: posts.map((e) => e.id.toString()).toList(),
                                    privateUser: posts.map((e) => e.notPublic == true ? "true" : "false").toList(),
                                  );
                                } else if(searchedPeople.isNotEmpty){
                                  var posts = SearchPeopleModel.getService(jsonDecode(searchedPeople));
                                  return PersonView(
                                    name: posts.map((e) => e.displayName.toString()).toList(),
                                    username: posts.map((e) => e.username.toString()).toList(),
                                    profilePic: posts.map((e) => e.avatar.toString()).toList(),
                                    length: posts.length,
                                    userIDs: posts.map((e) => e.userId.toString()).toList(),
                                    iDs: posts.map((e) => e.id.toString()).toList(),
                                    privateUser: posts.map((e) => e.notPublic == true ? "true" : "false").toList(),
                                  );
                                }else{
                                  if(searchController.text.isEmpty && snapshot.connectionState == ConnectionState.done){
                                    return SizedBox(
                                      height: Get.height * 0.7,
                                      child: const Center(
                                        child: Text('Enter a search term to search for People'),
                                      ),
                                    );
                                  }
                                  return const GroupView(isLoading: true,isGroup: true,);
                                }
                              }),
                        ),
                        //Groups
                        SingleChildScrollView(
                          child: FutureBuilder<ApiResponse>(
                              future: controller.searchGroups(searchController.text.replaceAll("#", "").replaceAll("@","")),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                  //final posts = snapshot.data!.suggestion as List<GroupModelEntity>;
                                  searchedGroups = jsonEncode(snapshot.data!.data);
                                  var posts = GroupModelEntity.getService(snapshot.data!.data);

                                  if(controller.searchFilter == "Most Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Most Engaged"){
                                    posts.sort((a,b) {
                                      return (b.numberOfMembers ?? 0).compareTo((a.numberOfMembers ?? 0));
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Engaged"){
                                    posts.sort((a,b) {
                                      return (a.numberOfMembers ?? 0).compareTo((b.numberOfMembers ?? 0));
                                    });
                                  }

                                  return GroupView(
                                    posts: posts,
                                    isGroup: true,
                                    onButtonClick: (group) async {
                                      var body = {
                                      "groupId": group.id,
                                      "userId": fullProfile.id,
                                    };
                                      var response = await controller.postData(body, "/wayagram-service/main/group/join-group");
                                      if(response.isSuccessful){
                                      var newRes = await controller.getData("/wayagram-service/main/group/get-all-user-created-groups?pageNumber=1&userId=${fullProfile.id}", true);
                                      if(newRes.isSuccessful){
                                        var savedPosts = ReadWriteValue('wayagram_joined_groups', '', MyPref.box);
                                        final posts = GroupModelEntity.getService(response.groups);
                                        savedPosts.val = jsonEncode(posts);
                                      }
                                      controller.update();
                                      Get.snackbar("Success", response.message == null ? "Success" : response.message.toString(),backgroundColor: Colors.green, colorText: Colors.white);
                                    }else{
                                        Get.snackbar("Error", response.message == null ? "Something went wrong" : response.message.toString(),backgroundColor: Colors.red, colorText: Colors.white);
                                      }
                                  }
                                  );
                                } else if(searchedGroups.isNotEmpty){
                                  var posts = GroupModelEntity.getService(jsonDecode(searchedGroups));

                                  if(controller.searchFilter == "Most Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Most Engaged"){
                                    posts.sort((a,b) {
                                      return (b.numberOfMembers ?? 0).compareTo((a.numberOfMembers ?? 0));
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Engaged"){
                                    posts.sort((a,b) {
                                      return (a.numberOfMembers ?? 0).compareTo((b.numberOfMembers ?? 0));
                                    });
                                  }

                                  return GroupView(posts: posts,isGroup: true);
                                }else{
                                  if(searchController.text.isEmpty && snapshot.connectionState == ConnectionState.done){
                                    return SizedBox(
                                      height: Get.height * 0.7,
                                      child: const Center(
                                        child: Text('Enter a search term to search for groups'),
                                      ),
                                    );
                                  }
                                  return const GroupView(isLoading: true,isGroup: true,);
                                }
                              }),
                        ),
                        //Pages
                        SingleChildScrollView(
                          child: FutureBuilder<ApiResponse>(
                              future: controller.searchPages(searchController.text.replaceAll("#", "").replaceAll("@","")),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                  //final posts = snapshot.data!.suggestion as List<GroupModelEntity>;
                                  searchedPages = jsonEncode(snapshot.data!.data);
                                  var posts = GroupModelEntity.getService(snapshot.data!.data);

                                  if(controller.searchFilter == "Most Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Most Engaged"){
                                    posts.sort((a,b) {
                                      return (b.numberOfMembers ?? 0).compareTo((a.numberOfMembers ?? 0));
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Engaged"){
                                    posts.sort((a,b) {
                                      return (a.numberOfMembers ?? 0).compareTo((b.numberOfMembers ?? 0));
                                    });
                                  }

                                  return GroupView(posts: posts,isGroup: false,onButtonClick: (group) async {
                                    var body = {
                                      "pageId": group.id,
                                      "userId": fullProfile.id,
                                    };
                                    var response = await controller.putData(body, "/wayagram-service/main/page/follow-or-un-follow");
                                    if(response.isSuccessful){
                                      await controller.getSuggestedPages;
                                      await controller.getPagesFollowed;
                                      controller.update();
                                      Get.snackbar("Success", response.message == null ? "Success" : response.message.toString(),backgroundColor: Colors.green, colorText: Colors.white);
                                    }else{
                                      Get.snackbar("Error", response.message == null ? "Something went wrong" : response.message.toString(),backgroundColor: Colors.red, colorText: Colors.white);
                                    }
                                  });
                                } else if(searchedPages.isNotEmpty){
                                  var posts = GroupModelEntity.getService(jsonDecode(searchedPages));

                                  if(controller.searchFilter == "Most Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Most Engaged"){
                                    posts.sort((a,b) {
                                      return (b.numberOfMembers ?? 0).compareTo((a.numberOfMembers ?? 0));
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Engaged"){
                                    posts.sort((a,b) {
                                      return (a.numberOfMembers ?? 0).compareTo((b.numberOfMembers ?? 0));
                                    });
                                  }

                                  return GroupView(posts: posts,isGroup: false,onButtonClick: (group) async {
                                    var body = {
                                      "pageId": group.id,
                                      "userId": fullProfile.id,
                                    };
                                    var response = await controller.putData(body, "/wayagram-service/main/page/follow-or-un-follow");
                                    if(response.isSuccessful){
                                      await controller.getSuggestedPages;
                                      await controller.getPagesFollowed;
                                      controller.update();
                                      Get.snackbar("Success", response.message == null ? "Success" : response.message.toString(),backgroundColor: Colors.green, colorText: Colors.white);
                                    }else{
                                      Get.snackbar("Error", response.message == null ? "Something went wrong" : response.message.toString(),backgroundColor: Colors.red, colorText: Colors.white);
                                    }
                                  });
                                }else{
                                  if(searchController.text.isEmpty && snapshot.connectionState == ConnectionState.done){
                                    return SizedBox(
                                      height: Get.height * 0.7,
                                      child: const Center(
                                        child: Text('Enter a search term to search for pages'),
                                      ),
                                    );
                                  }
                                  return const GroupView(isLoading: true,isGroup: false,);
                                }
                              }),
                        ),
                        //Products
                        SingleChildScrollView(
                          child: FutureBuilder<ApiResponse>(
                              future: controller.searchProduct(searchController.text.replaceAll("#", "").replaceAll("@","")),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                  //final posts = snapshot.data!.data as List<AllPostsEntity>;
                                  searchedProducts = jsonEncode(snapshot.data!.data);
                                  var post = ProductsModelEntity.fromJson(snapshot.data!.data);

                                  if(searchController.text.isEmpty && post.data == null){
                                    return SizedBox(
                                      height: Get.height * 0.7,
                                      child: const Center(
                                        child: Text('No Products Available'),
                                      ),
                                    );
                                  }

                                  var posts = post.data!;

                                  if(controller.searchFilter == "Most Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Most Engaged"){
                                    posts.sort((a,b) {
                                      return (b.noOfPurchase ?? 0).compareTo((a.noOfPurchase ?? 0));
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Engaged"){
                                    posts.sort((a,b) {
                                      return (a.noOfPurchase ?? 0).compareTo((b.noOfPurchase ?? 0));
                                    });
                                  }

                                  return ProductView(posts: posts);
                                }
                                else if(searchedProducts.isNotEmpty){
                                  var post = ProductsModelEntity.fromJson(jsonDecode(searchedProducts));
                                  if(searchController.text.isEmpty && post.data == null){
                                    return SizedBox(
                                      height: Get.height * 0.7,
                                      child: const Center(
                                        child: Text('No Products Available'),
                                      ),
                                    );
                                  }

                                  var posts = post.data!;

                                  if(controller.searchFilter == "Most Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Recent"){
                                    posts.sort((a,b) {
                                      return DateTime.parse(a.createdAt.toString()).millisecondsSinceEpoch.compareTo(DateTime.parse(b.createdAt.toString()).millisecondsSinceEpoch);
                                    });
                                  }
                                  else if(controller.searchFilter == "Most Engaged"){
                                    posts.sort((a,b) {
                                      return (b.noOfPurchase ?? 0).compareTo((a.noOfPurchase ?? 0));
                                    });
                                  }
                                  else if(controller.searchFilter == "Least Engaged"){
                                    posts.sort((a,b) {
                                      return (a.noOfPurchase ?? 0).compareTo((b.noOfPurchase ?? 0));
                                    });
                                  }

                                  return ProductView(posts: posts);
                                }else{
                                  if(searchController.text.isEmpty && snapshot.connectionState == ConnectionState.done){
                                    return SizedBox(
                                      height: Get.height * 0.7,
                                      child: const Center(
                                        child: Text('Enter a search term to search for products'),
                                      ),
                                    );
                                  }
                                  return const PostsView(isLoading: true);
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}
