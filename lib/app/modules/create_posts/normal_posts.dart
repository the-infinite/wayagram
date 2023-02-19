import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_list/chat_list.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hashtager/widgets/hashtag_text_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/app/global_widgets/app_input.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';
import 'package:wayagram/core/utils/validator.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/SearchHashtagsModel.dart';
import '../../data/model/SearhPeopleModel.dart';
import '../../data/model/TrendingHashtagsModel.dart';
import '../../data/model/following_model_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/app_button.dart';

import 'package:dio/dio.dart' as dio;

import '../../global_widgets/newsfeed_multiple_imageview.dart';
import '../../global_widgets/overlays.dart';
import '../../global_widgets/person_view.dart';
import '../../global_widgets/video_player/reusable_video_list_controller.dart';
import '../home/widgets/HashTagView.dart';
import '../home/widgets/group_view.dart';

import '../home/widgets/notification_view.dart';
import '../home/widgets/posts_view.dart' as post_view;

class CreatePosts extends StatefulWidget {
  const CreatePosts({Key? key}) : super(key: key);

  @override
  State<CreatePosts> createState() => _CreatePostsState();
}

class _CreatePostsState extends State<CreatePosts> {
  RefreshController refreshController = RefreshController(initialRefresh: false);
  ReusableVideoListController videoListController = ReusableVideoListController();
  final ImagePicker _imagePicker = ImagePicker();
  var textController = TextEditingController();
  var nameController = TextEditingController();
  var priceController = TextEditingController();
  var detectedHashtagController = TextEditingController();
  List<String> images = [];
  var postID = "";
  var searchedPeople = "";
  var searchedHashtags = "";
  var formKey = GlobalKey<FormState>();
  RegExp exp = RegExp(r"\B#\w\w+");

  @override
  Widget build(BuildContext context) {
    var currentPage = ReadWriteValue('wayagram_following_current_page', 1, MyPref.box);
    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(builder: (controller) {

        return Scaffold(
          appBar: AppBar(
            backgroundColor: getAppColor(AppColors.background),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  controller.isProductPost ? "Create Product" : controller.postToQuote == null ? "Create Post" : "Quote Post",
                  style: TextStyle(
                    color: getAppColor(const Color(0xff4F4F4F)),
                    fontSize: Get.textScaleFactor * 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                if(controller.groupToPost != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'To Group: ',
                        style: TextStyle(
                          color: getAppColor(const Color(0xff4F4F4F)),
                          fontSize: Get.textScaleFactor * 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        controller.groupToPost!.name.toString(),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: Get.textScaleFactor * 14,
                        ),
                      ),
                    ],
                  ),
                if(controller.pageToPost != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'To Page: ',
                        style: TextStyle(
                          color: getAppColor(const Color(0xff4F4F4F)),
                          fontSize: Get.textScaleFactor * 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        controller.pageToPost!.name.toString(),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: Get.textScaleFactor * 14,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            leading: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                FeatherIcons.arrowLeft,
                color: getAppColor(Colors.black),
              ),
              onPressed: () {
                Get.back();
              },
              iconSize: Get.width * 0.06,
            ),
            actions: [
              Center(
                child: SizedBox(
                  child: AppButton(
                    title: 'Send',
                    onPressed: () async {
                      if(formKey.currentState!.validate()){
                        if(controller.isProductPost){
                          bool create = true;
                          await AppOverlay.showDeviceDialog(
                            title: "Payment Information",
                            content: "Waya will take a commission from every sales and the rest of the money will be paid into your account",
                            onPositivePressed: () {
                              create = true;
                            },
                            onNegativePressed: () {
                              create = false;
                            },
                          );
                          if(create){
                            Map<String, dynamic> body = {
                              'description': textController.text,
                              'name':nameController.text,
                              'amount':priceController.text,
                              'profile_id': fullProfile.id,
                            };
                            if(images.isNotEmpty){
                              body['image'] = await dio.MultipartFile.fromFile(
                                images[0],
                                filename: images[0].split('/').last,
                              );
                            }
                            var formData = dio.FormData.fromMap(body);
                            ApiResponse? response;
                            if(postID.isNotEmpty){
                              formData.fields.add(MapEntry('product_id', postID));
                              for (var element in images) {
                                body['product_id'] = postID;
                                body['image'] = await dio.MultipartFile.fromFile(
                                  element,
                                  filename: element.split('/').last,
                                );
                                formData = dio.FormData.fromMap(body);
                                response = await controller.putData(formData, "/wayagram-service/all-posts/update-product");
                              }
                              if(response!.isSuccessful || response.message.toString().trim().toLowerCase() == "WAYAGram product created successfully".toLowerCase() || response.message.toString().trim().toLowerCase() == "WAYAGram Product updated successfully".toLowerCase()){
                                postID = "";
                                Get.back();
                                AppOverlay.showSuccessSnackBar(content: "Product created successfully");
                              }
                            }else{
                              response = await controller.postData(formData, "/wayagram-service/all-posts/create-product");
                              if(response.isSuccessful || response.message == "WAYAGram product created successfully" || response.message == "WAYAGram Product updated successfully"){
                                if(images.isNotEmpty){
                                  images.removeAt(0);
                                }
                                postID = response.data['id'] as String;
                                for (var element in images) {
                                  body['product_id'] = postID;
                                  body['image'] = await dio.MultipartFile.fromFile(
                                    element,
                                    filename: element.split('/').last,
                                  );
                                  formData = dio.FormData.fromMap(body);
                                  response = await controller.putData(formData, "/wayagram-service/all-posts/update-product");
                                }
                                if(response!.isSuccessful || response.message.toString().trim().toLowerCase() == "WAYAGram product created successfully".toLowerCase() || response.message.toString().trim().toLowerCase() == "WAYAGram Product updated successfully".toLowerCase()){
                                  postID = "";
                                  Get.back();
                                  AppOverlay.showSuccessSnackBar(content: "Product created successfully");
                                }
                              }else{
                                AppOverlay.showErrorSnackBar(title: 'Error', content: "Something went wrong, please try again later");
                              }
                            }
                          }
                        }
                        else{
                          if(controller.postToQuote != null){
                            var body = {
                              "original_post_id": controller.postToQuote!.id,
                              "reposter_profile_id": fullProfile.id,
                              "repost_comment_desc": textController.text,
                            };
                            var response = await controller.postData(body, "/wayagram-service/all-posts/repost-post");
                            if(response.isSuccessful){
                              controller.getPosts.then((value){
                                controller.update(['profile_page','home_tab','home']);
                              });
                              Get.back();
                              AppOverlay.showSuccessSnackBar(content: "Post quoted successfully");
                            }else{
                              AppOverlay.showErrorSnackBar(content: "An error occurred, please try again later");
                            }
                          }else{
                            var hashtags = [];
                            await Future.forEach(exp.allMatches(textController.text), (element){
                              var match = element as RegExpMatch;
                              hashtags.add(match.group(0)!.substring(1));
                            });
                            Map<String, dynamic> body = {
                              'description': textController.text,
                              'profile_id': fullProfile.id,
                              'type': 'user',
                              //'hashtags': hashtags.join(","),
                            };
                            if(controller.groupToPost != null){
                              body['group_id'] = controller.groupToPost!.id;
                              body['type'] = 'group';
                            }
                            if(controller.pageToPost != null){
                              body['page_id'] = controller.pageToPost!.id;
                              body['type'] = 'page';
                            }

                            if(images.isNotEmpty){
                              body['images'] = await dio.MultipartFile.fromFile(
                                images[0],
                                filename: images[0].split('/').last,
                              );
                            }
                            var formData = dio.FormData.fromMap(body);
                            ApiResponse? response;
                            if(postID.isNotEmpty){
                              formData.fields.add(MapEntry('post_id', postID));
                              //images.removeAt(0);
                              body['type'] = null;
                              for (var element in images) {
                                body['post_id'] = postID;
                                body['images'] = await dio.MultipartFile.fromFile(
                                  element,
                                  filename: element.split('/').last,
                                );
                                body.removeWhere((key, value) => key == "hashtags");
                                formData = dio.FormData.fromMap(body);
                                response = await controller.putData(formData, "/wayagram-service/all-posts/update");
                              }
                              if(response!.isSuccessful){
                                postID = "";
                                controller.getPosts.then((value){
                                  controller.update(['profile_page','home_tab','home']);
                                });
                                //AppOverlay.showInfoDialog(title: 'Success', content: response.message);
                                Get.back();
                                AppOverlay.showSuccessSnackBar(content: "Post created successfully");
                              }
                            }else{
                              var postBody = body;
                              postBody['hashtags'] = hashtags.join(",");
                              var postFormData = dio.FormData.fromMap(postBody);
                              response = await controller.postData(postFormData, "/wayagram-service/all-posts/create");

                              if(response.isSuccessful){
                                if(images.isNotEmpty){
                                  images.removeAt(0);
                                }
                                if(response.data['id'] == null){
                                  controller.getPosts.then((value){
                                    controller.update(['profile_page','home_tab','home']);
                                  });
                                  Get.back();
                                  AppOverlay.showSuccessSnackBar(content: "Post created successfully");
                                }else{
                                  postID = response.data['id'] as String;
                                  for (var element in images) {
                                    body['post_id'] = postID;
                                    body['type'] = null;
                                    body['images'] = await dio.MultipartFile.fromFile(
                                      element,
                                      filename: element.split('/').last,
                                    );
                                    body.removeWhere((key, value) => key == "hashtags");
                                    formData = dio.FormData.fromMap(body);
                                    response = await controller.putData(formData, "/wayagram-service/all-posts/update");
                                  }
                                  if(response!.isSuccessful){
                                    postID = "";
                                    //AppOverlay.showInfoDialog(title: 'Success', content: response.message);
                                    controller.getPosts.then((value){
                                      controller.update(['profile_page','home_tab','home']);
                                    });
                                    //AppOverlay.showInfoDialog(title: 'Success', content: response.message);
                                    Get.back();
                                    AppOverlay.showSuccessSnackBar(content: "Post created successfully");
                                  }
                                }
                              }else{
                                AppOverlay.showInfoDialog(title: 'Error', content: response.message);
                              }
                            }
                          }
                        }
                      }
                    },
                    borderRadius: 10,
                    fontColor: AppColors.button,
                    bckgrndColor: getAppColor(AppColors.background),
                    border: Border.all(color: getAppColor(AppColors.background), width: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    width: Get.width * 0.2,
                    fontSize: Get.textScaleFactor * 18,
                  ),
                ),
              )
            ],
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(
                  color: const Color(0xffEDEAEA),
                  height: 1.0,
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
            color: getAppColor(AppColors.background),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width*0.01, vertical: Get.height*0.01),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width*0.13,
                            height: Get.width*0.13,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: getAppColor(AppColors.background), width: 2),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: AppAvatar(
                                imgUrl: (fullProfile.avatar as String?).toString(),
                              ),
                              onPressed: () {

                              },
                            ),
                          ),
                          SizedBox(
                            width: Get.width*0.02
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FormField<String>(
                                      initialValue: '',
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (val){
                                        if(textController.text.isEmpty){
                                          if(controller.isProductPost){
                                            return 'Please enter product description';
                                          }
                                          return "Please enter post description";
                                        }
                                        return null;
                                      },
                                      builder: (field) {
                                        return Padding(
                                          padding: EdgeInsets.only(left: Get.width*0.01,right: Get.width*0.015),
                                          child: Column(
                                            children: [
                                              HashTagTextField(
                                                decoratedStyle: AppTextStyle.subtitle1.copyWith(
                                                  color: Colors.blue,
                                                  fontSize: 16,
                                                ),
                                                basicStyle: AppTextStyle.subtitle1.copyWith(
                                                  color: getAppColor(Colors.black),
                                                  fontSize: 16,
                                                ),
                                                expands: false,
                                                maxLines: null,
                                                minLines: null,
                                                decoration: InputDecoration(
                                                  hintText: controller.isProductPost ? "Enter Product Description" : controller.postToQuote == null ? "Create New Post" : "Quote Post Description",
                                                  hintStyle: AppTextStyle.subtitle1.copyWith(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                                controller: textController,
                                                decorateAtSign: true,
                                                onDetectionTyped: (String value) {
                                                  detectedHashtagController.text = value;
                                                  controller.update(["post_bottom_bar"]);
                                                },
                                                onDetectionFinished: () {
                                                  detectedHashtagController.text = "";
                                                  searchedPeople = "";
                                                  searchedHashtags = "";
                                                  controller.update(["post_bottom_bar"]);
                                                },
                                                onChanged: (String value){
                                                  //controller.update(["post_bottom_bar"]);
                                                },
                                              ),
                                              if(field.hasError)
                                                Padding(
                                                  padding: EdgeInsets.only(top: Get.height*0.01),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                        size: 16,
                                                      ),
                                                      SizedBox(
                                                        width: Get.width*0.01,
                                                      ),
                                                      Text(
                                                        field.errorText.toString(),
                                                        style: AppTextStyle.subtitle1.copyWith(
                                                          color: Colors.red,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      },
                                  ),
                                  if(images.isNotEmpty && !controller.isProductPost)
                                    SizedBox(
                                      height: Get.height*0.25,
                                      child: NewsfeedMultipleImageView(
                                        imageUrls: images,
                                        marginLeft: 5,
                                        marginRight: 5,
                                        marginBottom: 0,
                                        marginTop: 0,
                                        radius: 15,
                                        isFile: true,
                                        useAspectRatio: true,
                                        isSlideShow: false,
                                        videoListController: videoListController,
                                  ),
                                    ),
                                  if(controller.postToQuote != null)
                                    post_view.Post(
                                      post: controller.postToQuote!,
                                      fullProfile: fullProfile,
                                      homeController: controller,
                                      showActions: false,
                                      videoListController: videoListController,
                                      decoration: BoxDecoration(
                                        color: getAppColor(AppColors.background),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: const Color(0xffEDEAEA), width: 1),
                                      ),
                                    ),
                                  if(controller.isProductPost)
                                    Container(
                                      //height: Get.height*0.4,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: getAppColor(AppColors.background),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: const Color(0xffEDEAEA), width: 1),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          FormField<String>(
                                              initialValue: '',
                                              validator: (val){
                                                if(images.isEmpty){
                                                  return "Please add product image";
                                                }
                                                return null;
                                              },
                                              builder: (field) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(top: 10, bottom: 0, left: 5,right: 5),
                                                  child: Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: SizedBox(
                                                          height: Get.height * 0.20,
                                                          child: images.isNotEmpty ?  ListView.builder(
                                                            itemCount: images.length,
                                                            shrinkWrap: false,
                                                            scrollDirection: Axis.horizontal,
                                                            itemBuilder: (context, index) {
                                                              return Container(
                                                                margin: const EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 5),
                                                                padding: const EdgeInsets.all(0),
                                                                height: Get.height * 0.15,
                                                                width: Get.width * 0.3,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  color: Colors.grey.withOpacity(.5),
                                                                ),
                                                                child: Stack(
                                                                  alignment: Alignment.center,
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      child: Image.file(
                                                                        File(images[index]),
                                                                        fit: BoxFit.cover,
                                                                        height: Get.height * 0.20,
                                                                        width: Get.width * 0.3,
                                                                        errorBuilder: (context, error, stackTrace) {
                                                                          return const Icon(Icons.error);
                                                                        },
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top: 5,
                                                                      right: 5,
                                                                      child: Container(
                                                                        height: Get.width * 0.06,
                                                                        width: Get.width * 0.06,
                                                                        decoration: BoxDecoration(
                                                                          color: getAppColor(Colors.black).withOpacity(.8),
                                                                          borderRadius: BorderRadius.circular(100),
                                                                        ),
                                                                        child: Center(
                                                                          child: IconButton(
                                                                            padding: EdgeInsets.zero,
                                                                            icon: Icon(Icons.cancel_rounded, color: getAppColor(AppColors.background)),
                                                                            onPressed: () {
                                                                              images.removeAt(index);
                                                                              controller.update();
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ): InkWell(
                                                            onTap: () async {
                                                              final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 30);
                                                              if (pickedFile != null) {
                                                                CroppedFile? croppedFile = await ImageCropper().cropImage(
                                                                  sourcePath: pickedFile.path,
                                                                  cropStyle: CropStyle.rectangle,
                                                                  aspectRatioPresets: [
                                                                    CropAspectRatioPreset.square,
                                                                    CropAspectRatioPreset.ratio3x2,
                                                                    CropAspectRatioPreset.original,
                                                                    CropAspectRatioPreset.ratio4x3,
                                                                    CropAspectRatioPreset.ratio16x9
                                                                  ],
                                                                  uiSettings: [
                                                                    AndroidUiSettings(
                                                                        toolbarTitle: 'Crop Photo',
                                                                        toolbarColor: AppColors.primary,
                                                                        toolbarWidgetColor: Colors.white,
                                                                        activeControlsWidgetColor: AppColors.primary,
                                                                        cropGridColor: AppColors.primary,
                                                                        initAspectRatio: CropAspectRatioPreset.original,
                                                                        lockAspectRatio: false),
                                                                    IOSUiSettings(
                                                                      title: 'Crop Photo',
                                                                    ),
                                                                    WebUiSettings(
                                                                      context: context,
                                                                    ),
                                                                  ],
                                                                );
                                                                if(croppedFile!=null){
                                                                  images = List.from(images)..add(croppedFile.path);
                                                                }else{
                                                                  images = List.from(images)..add(pickedFile.path);
                                                                }
                                                                controller.update();
                                                              }
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.grey.withOpacity(.5),
                                                                borderRadius: BorderRadius.circular(10),
                                                                border: Border.all(color: const Color(0xffEDEAEA), width: 1),
                                                              ),
                                                              child: const Center(
                                                                child: Icon(Icons.image_rounded, color: Colors.grey),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      if(field.hasError)
                                                        Padding(
                                                          padding: EdgeInsets.only(top: Get.height*0.01),
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons.error,
                                                                color: Colors.red,
                                                                size: 16,
                                                              ),
                                                              SizedBox(
                                                                width: Get.width*0.01,
                                                              ),
                                                              Text(
                                                                field.errorText.toString(),
                                                                style: AppTextStyle.subtitle1.copyWith(
                                                                  color: Colors.red,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                );
                                              }
                                          ),
                                          SizedBox(height: Get.height * 0.01),
                                          Container(
                                            color: const Color(0xffEDEAEA),
                                            height: 1.0,
                                          ),
                                          AppInput(
                                            hintText: "Enter Product Name",
                                            borderRadius: 0,
                                            borderSide: BorderSide.none,
                                            controller: nameController,
                                            keyboardType: TextInputType.text,
                                            validator: Validator.textValidation,
                                          ),
                                          SizedBox(height: Get.height * 0.01),
                                          Container(
                                            color: const Color(0xffEDEAEA),
                                            height: 1.0,
                                          ),
                                          AppInput(
                                            hintText: "Enter Product Price",
                                            borderRadius: 0,
                                            borderSide: BorderSide.none,
                                            controller: priceController,
                                            keyboardType: TextInputType.number,
                                            validator: Validator.moneyValidation,
                                          ),
                                          SizedBox(height: Get.height * 0.01),
                                        ],
                                      ),
                                    ),
                                  if(controller.isProductPost)
                                    InkWell(
                                      onTap: (){
                                        controller.launchURL("https://wayagram.ng/terms");
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 10,),
                                          Text(
                                            "By creating, you agree with our terms and conditions \nof donation product creation",
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: Get.textScaleFactor * 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 10,),
                                        ],
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: GetBuilder<HomeControllerWayagram>(id: "post_bottom_bar",builder: (controller) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  color: getAppColor(AppColors.background),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if(controller.postToQuote == null)
                        Container(
                        color: const Color(0xffEDEAEA),
                        height: 1.0,
                      ),
                      if(detectedHashtagController.text.isEmpty && controller.postToQuote == null && !(textController.text.endsWith("#") || textController.text.endsWith("@")))
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: Get.width*0.025,
                              ),
                              IconButton(
                                icon: Icon(Icons.image_outlined, color: images.length > 29 ? Colors.grey : getAppColor(Colors.black)),
                                onPressed: () async {
                                  if(images.length <= 29){
                                    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 30);
                                    if (pickedFile != null) {
                                      CroppedFile? croppedFile = await ImageCropper().cropImage(
                                        sourcePath: pickedFile.path,
                                        cropStyle: CropStyle.rectangle,
                                        aspectRatioPresets: [
                                          CropAspectRatioPreset.square,
                                          CropAspectRatioPreset.ratio3x2,
                                          CropAspectRatioPreset.original,
                                          CropAspectRatioPreset.ratio4x3,
                                          CropAspectRatioPreset.ratio16x9
                                        ],
                                        uiSettings: [
                                          AndroidUiSettings(
                                              toolbarTitle: 'Crop Photo',
                                              toolbarColor: AppColors.primary,
                                              toolbarWidgetColor: Colors.white,
                                              activeControlsWidgetColor: AppColors.primary,
                                              cropGridColor: AppColors.primary,
                                              initAspectRatio: CropAspectRatioPreset.original,
                                              lockAspectRatio: false),
                                          IOSUiSettings(
                                            title: 'Crop Photo',
                                          ),
                                          WebUiSettings(
                                            context: context,
                                          ),
                                        ],
                                      );
                                      if(croppedFile!=null){
                                        images = List.from(images)..add(croppedFile.path);
                                      }else{
                                        images = List.from(images)..add(pickedFile.path);
                                      }
                                      controller.update();
                                    }
                                  }
                                },
                              ),
                              if(!controller.isProductPost)
                                IconButton(
                                icon: Icon(Icons.video_camera_back_outlined, color: images.length > 29 ? Colors.grey : getAppColor(Colors.black),size: Get.width*0.065),
                                onPressed: () async {
                                  if(images.length <= 29){
                                    final pickedFile = await _imagePicker.pickVideo(source: ImageSource.gallery, maxDuration: const Duration(minutes: 10));
                                    if (pickedFile != null) {
                                      images = List.from(images)..add(pickedFile.path);
                                      controller.update();
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: Get.width*0.025),
                            child: IconButton(
                              icon: Icon(Icons.camera_alt_outlined, color: images.length > 29 ? Colors.grey : getAppColor(Colors.black)),
                              onPressed: () async {
                                if(images.length <= 29){
                                  final pickedFile = await _imagePicker.pickImage(
                                    source: ImageSource.camera,
                                    imageQuality: 30,
                                  );
                                  if (pickedFile != null && pickedFile.path.isNotEmpty) {
                                    CroppedFile? croppedFile = await ImageCropper().cropImage(
                                      sourcePath: pickedFile.path,
                                      cropStyle: CropStyle.rectangle,
                                      aspectRatioPresets: [
                                        CropAspectRatioPreset.square,
                                        CropAspectRatioPreset.ratio3x2,
                                        CropAspectRatioPreset.original,
                                        CropAspectRatioPreset.ratio4x3,
                                        CropAspectRatioPreset.ratio16x9
                                      ],
                                      uiSettings: [
                                        AndroidUiSettings(
                                            toolbarTitle: 'Crop Photo',
                                            toolbarColor: AppColors.primary,
                                            toolbarWidgetColor: Colors.white,
                                            activeControlsWidgetColor: AppColors.primary,
                                            cropGridColor: AppColors.primary,
                                            initAspectRatio: CropAspectRatioPreset.original,
                                            lockAspectRatio: false),
                                        IOSUiSettings(
                                          title: 'Crop Photo',
                                        ),
                                        WebUiSettings(
                                          context: context,
                                        ),
                                      ],
                                    );
                                    if(croppedFile!=null){
                                      images = List.from(images)..add(croppedFile.path);
                                    }else{
                                      images = List.from(images)..add(pickedFile.path);
                                    }
                                    controller.update();
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      if(detectedHashtagController.text.isNotEmpty)
                        Container(
                          color: getAppColor(AppColors.background),
                          height: Get.height*0.25,
                          child: SingleChildScrollView(
                            child: detectedHashtagController.text.startsWith("#") ?
                            FutureBuilder<ApiResponse>(
                              //https://services.staging.wayagram.ng/wayagram-service/all-posts/search-hashtags?query=trend&sso_id=41
                                future: controller.getData("/wayagram-service/all-posts/search-hashtags?query=${detectedHashtagController.text.replaceAll("#", "").replaceAll("@","")}", true),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                    final posts = SearchHashtagsModel.listFromJson(snapshot.data!.data);
                                    searchedHashtags = jsonEncode(posts);
                                    List<String> title = [];
                                    List<String> subtitle = [];
                                    for (var element in posts) {
                                      if(element.hashtag != null){
                                        if(element.hashtag.toString().startsWith("#")){
                                          title.add(element.hashtag!);
                                        }else{
                                          title.add("#${element.hashtag!}");
                                        }
                                        if(element.postToHashtags != null){
                                          subtitle.add('${element.postToHashtags!.length} Conversations');
                                        }else{
                                          subtitle.add('0 Conversations');
                                        }
                                      }
                                    }
                                    if(title.isEmpty){
                                      return SizedBox(
                                        height: Get.height*0.25,
                                        child: const Center(
                                          child: Text('No Hashtags Found'),
                                        ),
                                      );
                                    }
                                    return HashTagView(
                                      title: title,
                                      subtitle: subtitle,
                                      onClick: (title, subtitle) {
                                        //replace last only
                                        //textController.text = textController.text.replaceAll(detectedHashtagController.text, title);
                                        var pos = textController.text.lastIndexOf(detectedHashtagController.text);
                                        textController.text = textController.text.replaceRange(pos, pos+detectedHashtagController.text.length, "$title ");
                                        textController.selection = TextSelection.collapsed(offset: textController.text.length);
                                      },
                                    );
                                  }else{
                                    if(searchedHashtags.isNotEmpty){
                                      final posts = SearchHashtagsModel.listFromJson(jsonDecode(searchedHashtags));
                                      List<String> title = [];
                                      List<String> subtitle = [];
                                      for (var element in posts) {
                                        if(element.hashtag != null){
                                          if(element.hashtag.toString().startsWith("#")){
                                            title.add(element.hashtag!);
                                          }else{
                                            title.add("#${element.hashtag!}");
                                          }
                                          if(element.postToHashtags != null){
                                            subtitle.add('${element.postToHashtags!.length} Conversations');
                                          }else{
                                            subtitle.add('0 Conversations');
                                          }
                                        }
                                      }
                                      if(title.isEmpty){
                                        return SizedBox(
                                          height: Get.height*0.25,
                                          child: const Center(
                                            child: Text('No Hashtags Found'),
                                          ),
                                        );
                                      }
                                      return HashTagView(
                                        title: title,
                                        subtitle: subtitle,
                                        onClick: (title, subtitle) {
                                          //replace last only
                                          //textController.text = textController.text.replaceAll(detectedHashtagController.text, title);
                                          var pos = textController.text.lastIndexOf(detectedHashtagController.text);
                                          textController.text = textController.text.replaceRange(pos, pos+detectedHashtagController.text.length, "$title ");
                                          textController.selection = TextSelection.collapsed(offset: textController.text.length);
                                        },
                                      );
                                    }
                                    if(snapshot.connectionState == ConnectionState.done){
                                      return SizedBox(
                                        height: Get.height*0.25,
                                        child: const Center(
                                          child: Text('No Hashtags Found'),
                                        ),
                                      );
                                    }
                                    return const GroupView(isLoading: true);
                                  }
                                }) : FutureBuilder<ApiResponse>(
                                future: controller.searchPeople(detectedHashtagController.text.replaceAll("#", "").replaceAll("@","")),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                    //final posts = snapshot.data!.suggestion as List<GroupModelEntity>;
                                    var posts = SearchPeopleModel.getService(snapshot.data!.data);
                                    searchedPeople = jsonEncode(posts);
                                    if(posts.isEmpty){
                                      return SizedBox(
                                        height: Get.height * 0.7,
                                        child: const Center(
                                          child: Text('No People Found'),
                                        ),
                                      );
                                    }
                                    return PersonView(
                                      name: posts.map((e) => e.displayName.toString()).toList(),
                                      username: posts.map((e) => e.username.toString()).toList(),
                                      profilePic: posts.map((e) => e.avatar.toString()).toList(),
                                      length: posts.length,
                                      userIDs: posts.map((e) => e.userId.toString()).toList(),
                                      onClick: (value){
                                        var pos = textController.text.lastIndexOf(detectedHashtagController.text);
                                        textController.text = textController.text.replaceRange(pos, pos+detectedHashtagController.text.length, "@${value.username} ");
                                        textController.selection = TextSelection.collapsed(offset: textController.text.length);
                                      },
                                    );
                                  }else{
                                    if(searchedPeople.isNotEmpty){
                                      var posts = SearchPeopleModel.getService(jsonDecode(searchedPeople));
                                      if(posts.isEmpty){
                                        return SizedBox(
                                          height: Get.height * 0.7,
                                          child: const Center(
                                            child: Text('No People Found'),
                                          ),
                                        );
                                      }
                                      return PersonView(
                                        name: posts.map((e) => e.displayName.toString()).toList(),
                                        username: posts.map((e) => e.username.toString()).toList(),
                                        profilePic: posts.map((e) => e.avatar.toString()).toList(),
                                        length: posts.length,
                                        userIDs: posts.map((e) => e.userId.toString()).toList(),
                                        onClick: (value){
                                          var pos = textController.text.lastIndexOf(detectedHashtagController.text);
                                          textController.text = textController.text.replaceRange(pos, pos+detectedHashtagController.text.length, "@${value.username} ");
                                          textController.selection = TextSelection.collapsed(offset: textController.text.length);
                                        },
                                      );
                                    }
                                    if(snapshot.connectionState == ConnectionState.done){
                                      return SizedBox(
                                        height: Get.height * 0.7,
                                        child: const Center(
                                          child: Text('No People Found'),
                                        ),
                                      );
                                    }
                                    return const GroupView(isLoading: true,isGroup: true,);
                                  }
                                }),
                          ),
                        ),
                      /*if(textController.text.endsWith("#") || textController.text.endsWith("@"))
                        Container(
                          color: getAppColor(AppColors.background),
                          height: Get.height*0.25,
                          child: textController.text.endsWith("#") ? SingleChildScrollView(
                            child: FutureBuilder<ApiResponse>(
                                future: controller.getData("/wayagram-service/all-posts/get-trending-hashtags?profile_id=${fullProfile.id}", true),
                                builder: (context, snapshot) {
                                  var savedPosts = ReadWriteValue('wayagram_trending_hashtags', '', MyPref.box);
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                    final posts = TrendingHashtagsModel.listFromJson(snapshot.data!.data['data']);
                                    savedPosts.val = jsonEncode(posts);
                                    List<String> title = [];
                                    List<String> subtitle = [];
                                    for (var element in posts) {
                                      if(element.hashtag != null){
                                        title.add("#${element.hashtag!}");
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
                                        var pos = textController.text.lastIndexOf("#");
                                        textController.text = textController.text.replaceRange(pos, pos+1, "$title ");
                                        textController.selection = TextSelection.collapsed(offset: textController.text.length);
                                      },
                                    );
                                  } else if(savedPosts.val.isNotEmpty){
                                    var posts = TrendingHashtagsModel.listFromJson(jsonDecode(savedPosts.val));
                                    List<String> title = [];
                                    List<String> subtitle = [];
                                    for (var element in posts) {
                                      if(element.hashtag != null){
                                        title.add("#${element.hashtag!}");
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
                                        var pos = textController.text.lastIndexOf("#");
                                        textController.text = textController.text.replaceRange(pos, pos+1, "$title ");
                                        textController.selection = TextSelection.collapsed(offset: textController.text.length);
                                      },
                                    );
                                  }else{
                                    if(snapshot.connectionState == ConnectionState.done){
                                      return SizedBox(
                                        height: Get.height*0.25,
                                        child: const Center(
                                          child: Text('No Trending Hashtags Found'),
                                        ),
                                      );
                                    }
                                    return const GroupView(isLoading: true);
                                  }
                                }),
                          ) : SingleChildScrollView(
                            child: FutureBuilder<ApiResponse>(
                                future: controller.getData('/wayagram-service/graph/friend/following?user_id=${fullProfile.userId}&page=1',true),
                                builder: (context, snapshot) {
                                  var savedPosts = MyPref.following.val;
                                  if(savedPosts.isNotEmpty){
                                    var posts = FollowingModelEntity.fromJson(jsonDecode(savedPosts));
                                    var names = posts.following!.map((e) => e.displayName.toString()).toList();
                                    var username = posts.following!.map((e) => e.username.toString()).toList();
                                    var profile = posts.following!.map((e) => e.avatar.toString()).toList();
                                    var userIds = posts.following!.map((e) => e.userId.toString()).toList();
                                    return PersonView(
                                      name: names,
                                      username: username,
                                      profilePic: profile,
                                      length: posts.following == null ? 0 : posts.following!.length,
                                      userIDs: userIds,
                                      following: posts.following,
                                      showButton: false,
                                      onClick: (person) {
                                        var pos = textController.text.lastIndexOf("@");
                                        textController.text = textController.text.replaceRange(pos, pos+1, "@${person.username} ");
                                        textController.selection = TextSelection.collapsed(offset: textController.text.length);
                                        controller.update(["post_bottom_bar"]);
                                      },
                                    );
                                  }else{
                                    if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                      var posts = FollowingModelEntity.fromJson(snapshot.data!.data);
                                      var names = posts.following!.map((e) => e.displayName.toString()).toList();
                                      var username = posts.following!.map((e) => e.username.toString()).toList();
                                      var profile = posts.following!.map((e) => e.avatar.toString()).toList();
                                      var userIds = posts.following!.map((e) => e.userId.toString()).toList();
                                      MyPref.following.val = jsonEncode(posts);
                                      currentPage.val = 2;
                                      return PersonView(
                                        name: names,
                                        username: username,
                                        profilePic: profile,
                                        length: posts.following == null ? 0 : posts.following!.length,
                                        userIDs: userIds,
                                        following: posts.following,
                                        showButton: true,
                                        onClick: (person) {
                                          var pos = textController.text.lastIndexOf("@");
                                          textController.text = textController.text.replaceRange(pos, pos+1, "@${person.username} ");
                                          textController.selection = TextSelection.collapsed(offset: textController.text.length);
                                          controller.update(["post_bottom_bar"]);
                                        },
                                      );
                                    }
                                    return NotificationView(isLoading: true);
                                  }
                                }),
                          ),
                        )*/
                    ],
                  ),
                ),
              );
            }
          ),
        );
      }),
    );
  }
}