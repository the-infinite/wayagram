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
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

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
  AddInterestPage({Key? key}) : super(key: key);

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
      'Computer Hardware',
      'Computer Software',
      'Computer Networking',
      'Computer Security',
      'Computer Data Storage',
      'Computer Data Management',
      'Computer Data Analysis',
      'Computer Data Processing',
      'Computer Data Recovery',
      'Computer Data Encryption',
      'Internet',
      'Agriculture',
      'Architecture',
      'Art',
      'Automotive',
      'Aviation',
      'Biology',
      'Business',
      'Chemistry',
      'Civil Engineering',
      'Computer Science',
      'Construction',
      'Culinary Arts',
      'Dance',
      'Design',
      'Economics',
      'Education',
      'Electrical Engineering',
      'Engineering',
      'English',
      'Environmental Science',
      'Fashion',
      'Film',
      'Finance',
      'Food',
      'Forestry',
      'Graphic Design',
      'Health',
      'History',
      'Hospitality',
      'Human Resources',
      'Information Technology',
      'Interior Design',
      'Journalism',
      'Law',
      'Literature',
      'Management',
      'Marketing',
      'Mathematics',
      'Mechanical Engineering',
      'Medicine',
      'Music',
      'Nursing',
      'Performing Arts',
      'Philosophy',
      'Photography',
      'Physics',
      'Political Science',
      'Psychology',
      'Public Relations',
      'Real Estate',
      'Religion',
      'Sales',
      'Social Work',
      'Sociology',
      'Sports',
      'Theatre',
      'Tourism',
      'Veterinary Medicine',
      'Writing',
      'Yoga',
      'Zoology',
      'Astronomy',
      'Biology',
      'Chemistry',
      'Geology',
      'Physics',
      'Aeronautics',
      'Astronautics',
      'Aviation',
      'Aerospace Engineering',
      'Aerospace Medicine',
      'Aerospace Science',
      'Aerospace Technology',
      'Aerospace Engineering',
      'Aerospace Medicine',
      'Aerospace Science',
      'Aerospace Technology',
      'Aeronautical Engineering',
      'Aeronautical Science',
      'Aeronautical Technology',
      'Aeronautical Engineering',
      'Aeronautical Science',
      'Aeronautical Technology',
      'Aeronautical Engineering',
      'Aeronautical Science',
      'Marine Engineering',
      'Karate',
      'Judo',
      'Taekwondo',
      'Kung',
      'Ballet',
      'Jazz',
      'Tap',
      'Hip Hop',
      'Salsa',
      'Zumba',
      'Yoga',
      'Pilates',
      'Aerobics',
      'Food',
      'Fashion',
      'Music',
      'Sports',
      'Fiction',
      'Non-Fiction',
      'Poetry',
      'Drama',
      'Comedy',
      'Horror',
      'Romance',
      'Action',
      'Novels',
      'Short Stories',
      'Biographies',
      'Autobiographies',
      'Mystery',
      'Thriller',
      'Fantasy',
      'Science Fiction',
      'Graphic Novels',
      'Manga',
      'Anime',
      'Comics',
      'Painting',
      'Sculpture',
      'Drawing',
      'Photography',
      'Architecture',
      'Graphic Design',
      'Singing',
      'Interior `Design',
      'Wayagram',
      'Wayapos',
      'Wayabank',
      'Wayalink',
      'Love',
      'Karaoke',
      'Space',
      'Space Exploration',
      'Space Travel',
      'Space Technology',
      'Space Science',
      'Space Medicine',
      'Space Engineering',
      'Sea',
      'Ocean',
      'Ocean Exploration',
      'Ocean Travel',
      'Ocean Technology',
      'Ocean Science',
      'Ocean Medicine',
      'Ocean Engineering',
      'Crickets',
      'Community service',
      'Cooking or baking',
      'Crafts',
      'Exercising',
      'Gardening',
      'Hiking',
      'Healthcare',
      'Woodworking',
      'Writing',
      'Blogging',
      'Reading',
      'Nature',
      'Theater'
          'Foreign languages',
      'Acting',

      "Jewelry making",
      "Knitting",
      "Origami",
      "Painting",
      "Photography",
      "Quilling",
      "Quilting",
      "Scrapbooking",
      "Sculpting",
      "Sewing",
      "Sketching",
      "Soap making",
      "Pottery",
      "Wood-burning",
      "Woodcarving",
      "Woodworking",
      "Collecting",
      "Action figures",
      "Amateur-geology",
      "Antiques",
      "Autographs",
      "Cars",
      "Coins",
      "Comic books",
      "Dolls",
      "Fine art",
      "LEGO sets",
      "Model die cast cars",
      "Movie memorabilia",
      "Music memorabilia",
      "Sports memorabilia",
      "Sports trading cards",
      "Stamps",
      "Vinyl records",
      "Watches",
      "Food and drink",
      "Baking",
      "Bartending",
      "Beer tasting",
      "Brewing",
      "Coffee roasting",
      "Cooking",
      "Grilling",
      "Doxology",
      "Mixology",
      "Sushi making",
      "Whiskey tasting",
      "Wine making",
      "Wine tasting",
      "Games",
      "3D games",
      "Arcade games",
      "Billiards",
      "Board games",
      "Bridge",
      "Card games",
      "Chess",
      "Crossword puzzles",
      "Dominoes",
      "Geocaching",
      "Jigsaw puzzles",
      "Sudoku",
      "Table tennis",
      "Video games",
      "Word scrambles",
      "Model, electronic and tech",
      "App building",
      "Blogging",
      "Car restoration",
      "Model airplanes",
      "Model cars",
      "Model railroading",
      "Model rockets",
      "Model ships",
      "Podcasting",
      "Programming / Coding",
      "RC boats",
      "RC cars",
      "RC helicopters",
      "RC planes",
      "Robotics",
      "Scale miniature building",
      "Web design",
      "YouTubing",
      "Music",
      "Choir singing",
      "Composing music",
      "DJ-ing",
      "Mashups",
      "Opera",
      "Playing a musical instrument",
      "Rapping",
      "Singing",
      "Performing arts",
      "Acting",
      "Ballet",
      "Break-dancing",
      "Historical reenactments",
      "Juggling",
      "Line dancing",
      "Magic tricks",
      "Puppetry",
      "Salsa",
      "Stand-up comedy",
      "Swing",
      "Tango",
      "Waltz",
      "Pets and animals",
      "Animal breeding",
      "Animal rescue",
      "Animal training",
      "Beekeeping",
      "Dog walking",
      "Fish-keeping",
      "Pet fostering",
      "Pet grooming",
      "Spiritual and mental",
      "Astrology",
      "Freelance writing",
      "Genealogy",
      "Journaling",
      "Languages",
      "Meditation",
      "Neurolinguistic programming",
      "Novel writing",
      "Online classes",
      "Play writing",
      "Poetry",
      "Reading",
      "Screenwriting",
      "Sign language",
      "Songwriting",
      "Speed reading",
      "Volunteering",
      "Sports and outdoors",
      "Acrobatics",
      "Archery",
      "Badminton",
      "Backpacking travel",
      "Base jumping",
      "Baseball",
      "Basketball",
      "Birdwatching",
      "Bodybuilding",
      "Bowling",
      "Boxing",
      "Camping",
      "Canoeing",
      "Croquet",
      "Cycling",
      "Darts",
      "Diving",
      "Fantasy football",
      "Fencing",
      "Figure skating",
      "Fishing",
      "Flying",
      "Football",
      "Go karting",
      "Golf",
      "Gymnastics",
      "Hang gliding",
      "Hiking",
      "Horse racing",
      "Horseback riding",
      "Ice skating",
      "Kayaking",
      "Marathon running",
      "Martial arts",
      "Mountain biking",
      "Mountaineering",
      "Paintball",
      "Paragliding",
      "Pilates",
      "Rock climbing",
      "Running",
      "RV traveling",
      "Sailing",
      "Scuba diving",
      "Sightseeing",
      "Skateboarding",
      "Skiing",
      "Skydiving",
      "Snowboarding",
      "Squash",
      "Surfing",
      "Swimming",
      "Tennis",
      "Travel",
      "Water skiing",
      "Weight training",
      "Windsurfing",
      "Yoga",
      'Animation',
      'Architecture',
      'Calligraphy',
      'Candle making',
      'Card-making',
      'Ceramics',
      'Crocheting',
      'Drawing',
      'Embroidery',
      'Fashion design',
      'Filmmaking',
      'Floristry',
      'Furniture building',
      'Gardening',
      'Glass painting',
      'Home decorating',
    ];

    List<String> uniqueInterestList = interestList.toSet().toList();
    uniqueInterestList.sort();
    uniqueInterestList.add('Others');
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeControllerWayagram>(id: "add_interests_page",builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        return Scaffold(
          appBar: AppBar(
            backgroundColor: getAppColor(AppColors.background),
            title: Text(
              "Interests",
              style: TextStyle(
                color: getAppColor(Color(0xff4F4F4F)),
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
                child: Icon(FeatherIcons.arrowLeft, color: Colors.black)
            ),
            bottom: PreferredSize(
                preferredSize: Size(Get.width, Get.height * 0.06),
                child: Column(
                  children: [
                    Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    TabBar(
                      controller: tabController,
                      padding: EdgeInsets.zero,
                      labelColor: Colors.black,
                      unselectedLabelColor: Color(0xff9A9A9A),
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
                      tabs: [
                        Tab(text: 'All Interests',iconMargin: EdgeInsets.zero,),
                        Tab(text: 'Your Interests',iconMargin: EdgeInsets.zero,),
                      ],
                      onTap: (index) {
                        //pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
                        //controller.update(['profile_page']);
                      },
                    ),
                    Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                  ],
                )),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: getAppColor(AppColors.background),
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.dark,
                systemNavigationBarColor: getAppColor(AppColors.background),
                systemNavigationBarIconBrightness: Brightness.dark
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              ListView.builder(
                itemCount: uniqueInterestList.length,
                itemBuilder: (context, index) {
                  var currentInterest = uniqueInterestList[index];
                  if(chosenInterestList.contains(currentInterest)){
                    return SizedBox.shrink();
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
                          SizedBox(width: 10,),
                          Text(currentInterest, style: TextStyle(
                            color: Colors.black,
                            fontSize: Get.textScaleFactor * 17,
                            fontWeight: FontWeight.w500,
                          ),),
                          Spacer(),
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
                              }, child: Icon(Icons.add_circle, color: AppColors.primary,)
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
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
                                  SizedBox(width: 10,),
                                  Text(post.title.toString().capitalizeFirst.toString(), style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Get.textScaleFactor * 17,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  Spacer(),
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
                                      child: Icon(Icons.remove_circle, color: AppColors.primary,)
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
                                  SizedBox(width: 10,),
                                  Text(post.title.toString().capitalizeFirst.toString(), style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Get.textScaleFactor * 17,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                  Spacer(),
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
                                      child: Icon(Icons.remove_circle, color: AppColors.primary,)
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }else{
                      if(snapshot.connectionState == ConnectionState.done){
                        return SizedBox.shrink();
                      }
                      return GroupView(isLoading: true);
                    }
                  }),
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