import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/core/utils/validator.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/document_picker.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';
import 'package:dio/dio.dart' as dio;

import '../home/widgets/posts_view.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  static const route = '/search';

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with TickerProviderStateMixin{
  var homeController = Get.find<HomeController>();
  var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
  var searchController = TextEditingController();
  var searchedPosts = "";
  var searchedPeople = "";
  var searchedGroups = "";
  var searchedPages = "";
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    searchController.addListener(() {
      if(searchController.text.isNotEmpty) {
        homeController.update(['search']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<HomeController>(
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
                  labelPadding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  tabs: const [
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
                            future: controller.searchPost(searchController.text),
                            builder: (context, snapshot) {
                              var savedPosts = MyPref.posts.val;
                              if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                //final posts = snapshot.data!.data as List<AllPostsEntity>;
                                searchedPosts = jsonEncode(snapshot.data!.data);
                                var posts = AllPostsEntity.getService(snapshot.data!.data);
                                return PostsView(posts: posts);
                              }else if(searchedPosts.isNotEmpty){
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
                      const Center(child: Text('People')),
                      const Center(child: Text('Groups')),
                      const Center(child: Text('Pages')),
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
