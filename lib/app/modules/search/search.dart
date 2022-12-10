import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wayagram/app/data/model/SearhPeopleModel.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/core/utils/validator.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/SearchHashtagsModel.dart';
import '../../data/model/TrendingHashtagsModel.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/group_model_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/document_picker.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';
import 'package:dio/dio.dart' as dio;

import '../../global_widgets/person_view.dart';
import '../home/widgets/HashTagView.dart';
import '../home/widgets/group_view.dart';
import '../home/widgets/posts_view.dart';

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
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
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
            appBar: AppBar(
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
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
                centerTitle: false,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Get.height * 0.015),
                TabBar(
                  controller: tabController,
                  padding: EdgeInsets.zero,
                  labelColor: Colors.black,
                  unselectedLabelColor: const Color(0xff9A9A9A),
                  indicatorColor: AppColors.primary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: EdgeInsets.only(left: Get.width * 0.02),
                  indicatorPadding: EdgeInsets.zero,
                  tabs: const [
                    Tab(text: 'Hashtags',iconMargin: EdgeInsets.zero,),
                    Tab(text: 'Posts',iconMargin: EdgeInsets.zero,),
                    Tab(text: 'People',iconMargin: EdgeInsets.zero,),
                    Tab(text: 'Groups',iconMargin: EdgeInsets.zero,),
                    Tab(text: 'Pages',iconMargin: EdgeInsets.zero,),
                  ],
                ),
                const Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      SingleChildScrollView(
                        child: FutureBuilder<ApiResponse>(
                          //https://services.staging.wayagram.ng/wayagram-service/all-posts/search-hashtags?query=trend&sso_id=41
                            future: controller.getData("/wayagram-service/all-posts/search-hashtags?query=${searchController.text.replaceAll("#", "").replaceAll("@","")}", true),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                final posts = SearchHashtagsModel.listFromJson(snapshot.data!.data);
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

                                  },
                                );
                              } else if(searchedHashtags.isNotEmpty){
                                var posts = SearchHashtagsModel.listFromJson(jsonDecode(searchedHashtags));
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
                      SingleChildScrollView(
                        child: FutureBuilder<ApiResponse>(
                            future: controller.searchPost(searchController.text.replaceAll("#", "").replaceAll("@","")),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                //final posts = snapshot.data!.data as List<AllPostsEntity>;
                                searchedPosts = jsonEncode(snapshot.data!.data);
                                var posts = AllPostsEntity.getService(snapshot.data!.data);
                                return PostsView(posts: posts);
                              }
                              else if(searchedPosts.isNotEmpty){
                                var posts = AllPostsEntity.getService(jsonDecode(searchedPosts));
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
                      SingleChildScrollView(
                        child: FutureBuilder<ApiResponse>(
                            future: controller.searchGroups(searchController.text.replaceAll("#", "").replaceAll("@","")),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                //final posts = snapshot.data!.suggestion as List<GroupModelEntity>;
                                searchedGroups = jsonEncode(snapshot.data!.data);
                                var posts = GroupModelEntity.getService(snapshot.data!.data);
                                return GroupView(posts: posts,isGroup: true,);
                              } else if(searchedGroups.isNotEmpty){
                                var posts = GroupModelEntity.getService(jsonDecode(searchedGroups));
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
                      SingleChildScrollView(
                        child: FutureBuilder<ApiResponse>(
                            future: controller.searchPages(searchController.text.replaceAll("#", "").replaceAll("@","")),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                //final posts = snapshot.data!.suggestion as List<GroupModelEntity>;
                                searchedPages = jsonEncode(snapshot.data!.data);
                                var posts = GroupModelEntity.getService(snapshot.data!.data);
                                return GroupView(posts: posts,isGroup: false,);
                              } else if(searchedPages.isNotEmpty){
                                var posts = GroupModelEntity.getService(jsonDecode(searchedPages));
                                return GroupView(posts: posts,isGroup: false);
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
                    ],
                  ),
                ),
              ],
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
