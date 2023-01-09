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
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/CommentModel.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/products_model_entity.dart';
import '../../data/model/promotion_pricing_model.dart';
import '../../data/model/wallet_model.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/app_button.dart';

import 'package:dio/dio.dart' as dio;

import '../../global_widgets/app_input.dart';
import '../../global_widgets/multiple_drop_down/model/selected_list_item.dart';
import '../../global_widgets/multiple_drop_down/src/drop_down.dart';
import '../../global_widgets/newsfeed_multiple_imageview.dart';
import '../../global_widgets/overlays.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';
import '../home/widgets/bottom_sheet.dart';
import '../home/widgets/posts_view.dart';

class PromoteProduct extends StatefulWidget {
  PromoteProduct({Key? key,required this.post}) : super(key: key);

  final ProductsModelData post;

  @override
  State<PromoteProduct> createState() => _PromoteProductState();
}

class _PromoteProductState extends State<PromoteProduct> {
  FocusNode inputNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PageController pageController = PageController();

  var impressionsController = TextEditingController(text: '0');
  var selectedStatesTextController = TextEditingController();
  var selectedInterestsTextController = TextEditingController();
  var selectedGoalsTextController = TextEditingController();
  var genderTextController = TextEditingController(text: 'Any Gender');
  var engagementsController = TextEditingController(text: '0');
  var intervalTextController = TextEditingController();
  var reachTextController = TextEditingController();
  var ageTextController = TextEditingController();
  var quantityTextController = TextEditingController(text: "1");
  var parentID = "";
  var usernameToReplyTo = "";

  WalletModel? walletModel;
  var accountTextController = TextEditingController();
  var pinTextController = TextEditingController();

  RangeValues currentRangeValues = RangeValues(0, 100);


  List<String> selectedStates = [];
  List<String> chosenGoals = [];
  List<String> chosenInterestList = [];

  List<PromotionPricingModel> promotionPricingModelList = [];

  void openKeyboard(){
    FocusScope.of(context).requestFocus(inputNode);
  }

  void closeKeyboard(){
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    var savedPosts = ReadWriteValue('wayagram_promotion_pricing_model', '', MyPref.box);

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

    if(savedPosts.val.isNotEmpty){
      promotionPricingModelList = PromotionPricingModel.listFromJson(jsonDecode(savedPosts.val));
    }

    List<String> interval = promotionPricingModelList.map((e) => e.interval.toString().trim()).toList().toSet().toList();
    intervalTextController.text = interval.first;
    Map<String,List<String>> priceMap = {};
    for (var element in interval) {
      List<String> reach = [];
      for (var e in promotionPricingModelList) {
        if(e.interval.toString().trim() == element){
          reach.add(e.price.toString());
        }
      }
      priceMap[element] = reach.toSet().toList();
    }
    reachTextController.text = priceMap[interval.first]!.first;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeControllerWayagram>(id: "promote_page",builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        return Scaffold(
          appBar: AppBar(
            backgroundColor: getAppColor(AppColors.background),
            title: Text(
              "Promote Product",
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
                preferredSize: Size.fromHeight(1.0),
                child: Container(
                  color: Color(0xffEDEAEA),
                  height: 1.0,
                )),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: getAppColor(AppColors.background),
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.dark,
                systemNavigationBarColor: getAppColor(AppColors.background),
                systemNavigationBarIconBrightness: Brightness.dark
            ),
          ),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.only(left: Get.width*0.008,right: Get.width*0.008),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /*Post(
                            post: widget.post,
                            fullProfile: fullProfile,
                            homeController: controller,
                            showActions: false,
                            decoration: BoxDecoration(
                              color: getAppColor(AppColors.background),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Color(0xffEDEAEA), width: 1),
                            ),
                          ),*/
                          SizedBox(height: 10,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              "Customize Your Audience",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: Get.textScaleFactor * 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              "Promote your Product to reach more people and boost engagements",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: Get.textScaleFactor * 16,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: Get.height*0.04),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: PageInput(
                              hint: 'Click to select one or more states',
                              label: 'Select Location To Target',
                              validator: (val){
                                if(val!.isEmpty){
                                  return 'Please select one or more states';
                                }
                                return null;
                              },
                              isCompulsory: true,
                              controller: selectedStatesTextController,
                              readOnly: true,
                              onTap: (){
                                DropDownState(
                                  DropDown(
                                    bottomSheetTitle: Text(
                                      "Select State",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: getAppColor(AppColors.onBackground)
                                      ),
                                    ),
                                    submitButtonChild: Text(
                                      'Done',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    data: NigerianStatesAndLGA.allStates.map<SelectedListItem>((String value) {
                                      return SelectedListItem(name: value,isSelected: selectedStates.contains(value));
                                    }).toList(),
                                    selectedItems: (List<dynamic> selectedList) {
                                      List<String> list = [];
                                      for(var item in selectedList) {
                                        if(item is SelectedListItem) {
                                          list.add(item.name);
                                        }
                                      }
                                      list.sort();
                                      selectedStates.clear();
                                      selectedStates.addAll(list.reversed);
                                      selectedStatesTextController.text = list.join(', ');
                                      controller.update(['promote_page']);
                                    },
                                    enableMultipleSelection: true,
                                  ),
                                ).showModal(context);
                              },
                            ),
                          ),
                          SizedBox(height: Get.height * 0.025),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: PageDropButton(
                              label: "Select Gender To Target",
                              hint: 'Select Gender',
                              padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                              onChanged: (val) {
                                genderTextController.text = val;
                              },
                              value: 'Any Gender',
                              items: ["Male","Female",'Any Gender'].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.025),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: PageInput(
                              hint: 'Click to select promotion goals',
                              label: 'Goals',
                              validator: (val){
                                if(val!.isEmpty){
                                  return 'Please select one or more goals';
                                }
                                return null;
                              },
                              isCompulsory: true,
                              controller: selectedGoalsTextController,
                              readOnly: true,
                              onTap: (){
                                DropDownState(
                                  DropDown(
                                    bottomSheetTitle: Text(
                                      "Select Interest",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          color: getAppColor(AppColors.onBackground)
                                      ),
                                    ),
                                    submitButtonChild: Text(
                                      'Done',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    data: ["More Messages","More Likes and Comments","More Profile Visits","More Sales","More Website Visits"].map<SelectedListItem>((String value) {
                                      return SelectedListItem(name: value,isSelected: chosenGoals.contains(value));
                                    }).toList(),
                                    selectedItems: (List<dynamic> selectedList) {
                                      List<String> list = [];
                                      for(var item in selectedList) {
                                        if(item is SelectedListItem) {
                                          list.add(item.name);
                                        }
                                      }
                                      list.sort();
                                      chosenGoals.clear();
                                      chosenGoals.addAll(list.reversed);
                                      selectedGoalsTextController.text = list.join(', ');
                                      controller.update(['promote_page']);
                                    },
                                    enableMultipleSelection: true,
                                  ),
                                ).showModal(context);
                              },
                            ),
                          ),
                          SizedBox(height: Get.height * 0.025),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: PageInput(
                              hint: 'Click to select promotion interests',
                              label: 'Select Interests',
                              validator: (val){
                                if(val!.isEmpty){
                                  return 'Please select one or more interests';
                                }
                                return null;
                              },
                              isCompulsory: true,
                              controller: selectedInterestsTextController,
                              readOnly: true,
                              onTap: (){
                                DropDownState(
                                  DropDown(
                                      bottomSheetTitle: Text(
                                        "Select Interest",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: getAppColor(AppColors.onBackground)
                                        ),
                                      ),
                                      submitButtonChild: Text(
                                        'Done',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      data: uniqueInterestList.map<SelectedListItem>((String value) {
                                        return SelectedListItem(name: value,isSelected: chosenInterestList.contains(value));
                                      }).toList(),
                                      selectedItems: (List<dynamic> selectedList) {
                                        List<String> list = [];
                                        for(var item in selectedList) {
                                          if(item is SelectedListItem) {
                                            list.add(item.name);
                                          }
                                        }
                                        list.sort();
                                        chosenInterestList.clear();
                                        chosenInterestList.addAll(list.reversed);
                                        selectedInterestsTextController.text = list.join(', ');
                                        controller.update(['promote_page']);
                                      },
                                      enableMultipleSelection: true,

                                  ),
                                ).showModal(context);
                              },
                            ),
                          ),
                          SizedBox(height: Get.height * 0.025),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: PageDropButton(
                              label: "Select Interval",
                              hint: 'Select Interval',
                              padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                              onChanged: (val) {
                                intervalTextController.text = val.toString();
                                reachTextController.text = priceMap[intervalTextController.text]!.first.toString();
                                controller.update(['promote_page']);
                              },
                              value: interval.first,
                              items: interval.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.025),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: PageDropButton(
                              label: "Select Interval",
                              hint: 'Select Interval',
                              padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                              onChanged: (val) {
                                reachTextController.text = val.toString();
                              },
                              value: priceMap[intervalTextController.text]!.isNotEmpty ? priceMap[intervalTextController.text]!.first : null,
                              items: priceMap[intervalTextController.text]!.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text("$value ${intervalTextController.text}"),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.025),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: PageInput(
                              hint: '',
                              label: 'Quantity',
                              validator: (val){
                                var value = int.tryParse(val.toString());
                                if(value == null){
                                  return 'Please enter a valid number';
                                }
                                if(val!.isEmpty){
                                  return 'Please enter needed quantity';
                                }else if(int.parse(val) > 100){
                                  return 'Please enter a quantity less than 100';
                                }else if(int.parse(val) < 1){
                                  return 'Please enter a quantity greater than 0';
                                }
                                return null;
                              },
                              isCompulsory: true,
                              controller: quantityTextController,
                              readOnly: false,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.025),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13),
                            child: Text(
                              "Select Age Range",
                              style: AppTextStyle.bodyText2.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF828282),
                              ),
                            ),
                          ),
                          RangeSlider(
                            values: currentRangeValues,
                            max: 100,
                            divisions: 100,
                            labels: RangeLabels(
                              currentRangeValues.start.round().toString(),
                              currentRangeValues.end.round().toString(),
                            ),
                            onChanged: (RangeValues values) {
                              currentRangeValues = values;
                              controller.update(['promote_page']);
                            },
                          ),

                          SizedBox(height: 40),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: AppButton(
                              title: 'Next',
                              onPressed: () {
                                if(formKey.currentState!.validate()){
                                  pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
                                }
                              },
                              borderRadius: 10,
                              fontColor: getAppColor(AppColors.background),
                              bckgrndColor: AppColors.primary,
                              width: double.infinity,
                              fontSize: Get.textScaleFactor * 18,
                              border: Border.all(color: AppColors.primary, width: 1),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.050),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: Get.width*0.008,right: Get.width*0.008),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Product Promotion Review",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Get.textScaleFactor * 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Review your product promotion",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: Get.textScaleFactor * 16,
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: Get.height*0.04),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Overview",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Get.textScaleFactor * 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        OverViewWidget(
                            title: "Price: ",
                            subtitle: "NGN ${int.parse(reachTextController.text)*int.parse(quantityTextController.text)} over ${quantityTextController.text} day"
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Estimated reach of ${promotionPricingModelList.firstWhere((element) => element.interval == intervalTextController.text).totalReach} persons per day",
                            style: TextStyle(
                              color: getAppColor(AppColors.onBackground),
                              fontSize: Get.textScaleFactor * 16,
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Divider(
                          color: Colors.black.withOpacity(0.5),
                          thickness: 1,
                        ),
                        SizedBox(height: Get.height*0.02),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Audience",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Get.textScaleFactor * 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        OverViewWidget(
                            title: "Location: ",
                            subtitle: selectedStatesTextController.text
                        ),
                        OverViewWidget(
                            title: "Age Range: ",
                            subtitle: "${currentRangeValues.start.round()} to ${currentRangeValues.end.round()} years"
                        ),
                        OverViewWidget(
                            title: "Gender: ",
                            subtitle: genderTextController.text
                        ),
                        Divider(
                          color: Colors.black.withOpacity(0.5),
                          thickness: 1,
                        ),
                        SizedBox(height: Get.height*0.02),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Promotion Goals",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Get.textScaleFactor * 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        OverViewWidget(
                            title: "Goals: ",
                            subtitle: selectedGoalsTextController.text
                        ),

                        SizedBox(height: Get.height*0.04),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: AppButton(
                            title: 'Continue to Payment',
                            onPressed: () {
                              pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
                            },
                            borderRadius: 10,
                            fontColor: getAppColor(AppColors.background),
                            bckgrndColor: AppColors.primary,
                            width: double.infinity,
                            fontSize: Get.textScaleFactor * 18,
                            border: Border.all(color: AppColors.primary, width: 1),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),

                        SizedBox(height: Get.height * 0.050),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: Get.width*0.008,right: Get.width*0.008),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 10,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              "Payment Overview",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: Get.textScaleFactor * 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(height: Get.height*0.04),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              "Overview",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: Get.textScaleFactor * 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          OverViewWidget(
                              title: "Price: ",
                              subtitle: "NGN ${int.parse(reachTextController.text)*int.parse(quantityTextController.text)}",
                            width: Get.width*0.3,
                          ),
                          OverViewWidget(
                              title: "Description: ",
                              subtitle: "Sponsored Content",
                            width: Get.width*0.3,
                          ),
                          OverViewWidget(
                              title: "Transaction Fee: ",
                              subtitle: "NGN 0.00",
                            width: Get.width*0.3,
                          ),

                          SizedBox(height: Get.height*0.01),
                          Divider(
                            color: Colors.black.withOpacity(0.5),
                            thickness: 1,
                          ),
                          SizedBox(height: Get.height*0.02),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              "Account Details",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: Get.textScaleFactor * 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(height: Get.height*0.02),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: PageInput(
                              hint: 'Click to select account',
                              label: 'Account To Debit',
                              validator: (val){
                                if(val!.isEmpty){
                                  return 'Please select an account to debit';
                                }else{
                                  if(walletModel!.clrBalAmt!.toInt() < int.parse(reachTextController.text)*int.parse(quantityTextController.text)){
                                    return 'Insufficient funds';
                                  }
                                }
                                return null;
                              },
                              isCompulsory: true,
                              controller: accountTextController,
                              readOnly: true,
                              onTap: (){
                                Get.bottomSheet(WalletBottomSheet(
                                  title: 'Select Account',
                                  onTap: (val){
                                    walletModel = val;
                                    accountTextController.text = val.accountNo.toString() + ' - ' + "${val.acctCrncyCode} ${val.clrBalAmt}";
                                  },
                                ),isScrollControlled: true);
                              },
                            ),
                          ),
                          SizedBox(height: Get.height*0.02),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: PageInput(
                              hint: 'Enter account pin',
                              label: 'PIN',
                              obscureText: true,
                              validator: (val){
                                if(val!.isEmpty){
                                  return 'Please enter your account pin';
                                }else{
                                  if(val.length < 4){
                                    return 'Invalid pin';
                                  }

                                  if(GetUtils.isNumericOnly(val) == false){
                                    return 'Invalid pin';
                                  }
                                }
                                return null;
                              },
                              isCompulsory: true,
                              controller: pinTextController,
                              keyboardType: TextInputType.number,
                            ),
                          ),

                          SizedBox(height: 40),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: AppButton(
                              title: 'Confirm Payment',
                              onPressed: () async {
                                if(formKey.currentState!.validate()){
                                  var gender = "any";
                                  if(genderTextController.text == "Male"){
                                    gender = "male";
                                  }else if(genderTextController.text == "Female"){
                                    gender = "female";
                                  }

                                  var body = {
                                    "profile_id": fullProfile.id,
                                    "promotion_pricing_id": promotionPricingModelList.firstWhere((element) => element.interval == intervalTextController.text).id.toString(),
                                    "post_id": widget.post.postId.toString(),
                                    "qty": quantityTextController.text,
                                    "age": promotionPricingModelList.firstWhere((element) => element.interval == intervalTextController.text).lengthOfDays.toString(),
                                    "debitAccountNumber": walletModel!.accountNo.toString(),
                                    "interests": chosenInterestList,
                                    "age_range": [
                                      currentRangeValues.start.toInt(),
                                      currentRangeValues.end.toInt()
                                    ],
                                    "goals": chosenGoals,
                                    "location": selectedGoalsTextController.text,
                                    "gender": gender,
                                  };
                                  var validatePin = await controller.getData("/auth-service/api/v1/pin/validate-pin/${pinTextController.text}", false);
                                  if(validatePin.isSuccessful){
                                    var res = await controller.postData(body, "wayagram-service/all-posts/promotion-create");
                                    if(Get.currentRoute == "/PromoteProduct"){
                                      if(res.isSuccessful){
                                        Navigator.popUntil(Get.context!, (route) => Get.currentRoute == "/ProductAnalytics");
                                        controller.update();
                                        AppOverlay.showSuccessSnackBar(title:"Product Promotion",content: "Product Promoted Successfully");
                                      }else{
                                        print(res.message);
                                        AppOverlay.showErrorSnackBar(title:"Product Promotion",content: "Unable to promote product, please try again later");
                                      }
                                    }
                                  }else{
                                    AppOverlay.showErrorSnackBar(content: "Invalid pin");
                                  }
                                }
                              },
                              borderRadius: 10,
                              fontColor: getAppColor(AppColors.background),
                              bckgrndColor: AppColors.primary,
                              width: double.infinity,
                              fontSize: Get.textScaleFactor * 18,
                              border: Border.all(color: AppColors.primary, width: 1),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.050),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Padding widgetAnalyticsWidget(String title, String subtitle, String amount) {
    return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: getAppColor(AppColors.background),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xffEDEAEA), width: 1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Get.width*0.025,vertical: Get.height*0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Get.textScaleFactor * 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Get.textScaleFactor * 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            Text(
                              amount,
                              style: TextStyle(
                                color: getAppColor(Color(0xff4F4F4F)),
                                fontSize: Get.textScaleFactor * 15,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
  }
}

class OverViewWidget extends StatelessWidget {
  OverViewWidget({
    Key? key,
    required this.subtitle,
    required this.title,
    this.width
  }) : super(key: key);

  final String title;
  final String subtitle;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width ?? Get.width*0.2,
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: Get.textScaleFactor * 16,
                fontWeight: FontWeight.normal,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(
            width: Get.width*0.6,
            child: Text(
              subtitle,
              style: TextStyle(
                color: getAppColor(AppColors.onBackground),
                fontSize: Get.textScaleFactor * 16,
                fontWeight: FontWeight.normal,
              ),
              softWrap: true,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}