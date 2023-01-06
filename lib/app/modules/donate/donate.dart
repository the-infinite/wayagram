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
import '../../data/model/DonationsModel.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/promotion_pricing_model.dart';
import '../../data/model/wallet_model.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/app_button.dart';

import 'package:dio/dio.dart' as dio;

import '../../global_widgets/app_input.dart';
import '../../global_widgets/newsfeed_multiple_imageview.dart';
import '../../global_widgets/overlays.dart';
import '../../global_widgets/page_input.dart';
import '../../global_widgets/wayagram_to_wayabank_widgets/wayagram_to_wayabank_widgets.dart';
import '../home/widgets/bottom_sheet.dart';
import '../home/widgets/posts_view.dart';
import '../promotion/promote_post.dart';

class DonateScreen extends StatefulWidget {
  DonateScreen({Key? key,required this.post}) : super(key: key);

  final AllPostsEntity post;

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  FocusNode inputNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var impressionsController = TextEditingController(text: '0');
  var engagementsController = TextEditingController(text: '0');
  var parentID = "";
  var usernameToReplyTo = "";

  WalletModel? walletModel;
  var accountTextController = TextEditingController();
  var pinTextController = TextEditingController();
  var priceTextController = TextEditingController();

  void openKeyboard(){
    FocusScope.of(context).requestFocus(inputNode);
  }

  void closeKeyboard(){
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    var donation = DonationsModel.fromJson(widget.post.donation);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeControllerWayagram>(id: "donate_page",builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        return Scaffold(
          appBar: AppBar(
            backgroundColor: getAppColor(AppColors.background),
            title: Text(
              "Donate",
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
            child: Padding(
              padding: EdgeInsets.only(left: Get.width*0.008,right: Get.width*0.008),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Post(
                        post: widget.post,
                        fullProfile: fullProfile,
                        homeController: controller,
                        showActions: false,
                        decoration: BoxDecoration(
                          color: getAppColor(AppColors.background),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xffEDEAEA), width: 1),
                        ),
                      ),
                      SizedBox(height: 10,),
                      SizedBox(height: Get.height*0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: PageInput(
                          hint: 'Enter amount to donate',
                          label: 'Amount',
                          obscureText: false,
                          validator: (val){
                            if(val!.isEmpty){
                              return 'Please enter an amount';
                            }else{
                              if(GetUtils.isNumericOnly(val) == false){
                                return 'Invalid amount';
                              }
                              var min = 0;
                              if(donation.minimumAmount != null){
                                min = donation.minimumAmount!.toInt();
                              }
                              if(int.parse(val) < min){
                                return 'Invalid amount, at least NGN $min is required';
                              }
                            }
                            return null;
                          },
                          isCompulsory: true,
                          controller: priceTextController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(height: Get.height*0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: PageInput(
                          hint: 'Click to select account',
                          label: 'Account To Debit',
                          validator: (val){
                            if(val!.isEmpty){
                              return 'Please select an account to debit';
                            }else{
                              var min = 0;
                              if(donation.minimumAmount != null){
                                min = donation.minimumAmount!.toInt();
                              }
                              if(walletModel!.clrBalAmt!.toInt() < min){
                                return 'Insufficient funds, at least NGN $min is required';
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
                        padding: EdgeInsets.symmetric(horizontal: 8),
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
                          title: 'Donate',
                          onPressed: () async {
                            if(formKey.currentState!.validate()){
                              var body = {
                                "donation_id": donation.id,
                                "amount": priceTextController.text,
                                "debitAccountNumber": walletModel!.accountNo,
                              };
                              
                              var validatePin = await controller.getData("/auth-service/api/v1/pin/validate-pin/${pinTextController.text}", false);
                              if(validatePin.isSuccessful){
                                var res = await  controller.postData(body,"/wayagram-service/all-posts/donate?profile_id=${fullProfile.id}");
                                if(Get.currentRoute == "/DonateScreen"){
                                  if(res.isSuccessful){
                                    Navigator.pop(Get.context!);
                                    AppOverlay.showSuccessSnackBar(title : "Donation Success",content: "Your donation was successful");
                                  }else{
                                    AppOverlay.showErrorSnackBar(title : "Donation Error",content: res.message ?? "An error occurred");
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
                      SizedBox(height: Get.height*0.02),
                      FundWalletButton(),
                      SizedBox(height: 5,),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: PinPrompt(),
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