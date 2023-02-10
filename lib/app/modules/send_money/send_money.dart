import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text_field.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../controllers/chat_controller.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/wallet_model.dart';
import '../../data/providers/my_pref.dart';
import '../../data/socket_models/chat_list_over_view.dart';
import '../../data/socket_models/send_message_response.dart';
import '../../global_widgets/app_button.dart';


import '../../global_widgets/overlays.dart';
import '../../global_widgets/page_input.dart';
import '../home/widgets/bottom_sheet.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({Key? key,required this.userIDToSendTo, required this.userDisplayName, this.post}) : super(key: key);

  final String userIDToSendTo;
  final String userDisplayName;
  final ChatOverview? post;

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  FocusNode inputNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var nameController = TextEditingController(text: '');
  var descController = TextEditingController(text: '');
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
    ChatOverview? post = widget.post;
    nameController.text = widget.userDisplayName;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(id: "donate_page",builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        return Scaffold(
          appBar: AppBar(
            backgroundColor: getAppColor(AppColors.background),
            title: Column(
              children: [
                Text(
                  "Send Money",
                  style: TextStyle(
                    color: getAppColor(const Color(0xff4F4F4F)),
                    fontSize: Get.textScaleFactor * 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Send money to ${widget.userDisplayName}",
                  style: TextStyle(
                    color: getAppColor(const Color(0xff4F4F4F)),
                    fontSize: Get.textScaleFactor * 14,
                    fontWeight: FontWeight.normal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            leading: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(FeatherIcons.arrowLeft, color: getAppColor(Colors.black))
            ),
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
                      SizedBox(height: Get.height*0.02),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: PageInput(
                          hint: 'Enter amount to send',
                          label: 'Amount',
                          obscureText: false,
                          validator: (val){
                            if(val!.isEmpty){
                              return 'Please enter an amount';
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
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: PageInput(
                          hint: 'Add description(optional)',
                          label: 'Description',
                          obscureText: false,
                          isCompulsory: false,
                          controller: descController,
                        ),
                      ),
                      SizedBox(height: Get.height*0.02),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: PageInput(
                          hint: 'Click to select account',
                          label: 'Account To Debit',
                          validator: (val){
                            if(val!.isEmpty){
                              return 'Please select an account to debit';
                            }else{
                              if(walletModel!.clrBalAmt!.toInt() <= 0){
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
                        padding: const EdgeInsets.symmetric(horizontal: 8),
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

                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: AppButton(
                          title: 'Send Money',
                          onPressed: () async {
                            if(formKey.currentState!.validate()){
                              var body = {
                                "amount": priceTextController.text,
                                "senderId": fullProfile.userId.toString(),
                                "senderAccountNumber": walletModel!.accountNo.toString(),
                              };

                              if(descController.text.isNotEmpty){
                                body['description'] = descController.text;
                              }

                              var validatePin = await controller.getData("/auth-service/api/v1/pin/validate-pin/${pinTextController.text}", false);
                              if(validatePin.isSuccessful){
                                var res = await  controller.postData(body,"/contact-service/contact/account/service/send/money/to/userId/${widget.userIDToSendTo}",pin:pinTextController.text);
                                if(Get.currentRoute == "/SendMoney"){
                                  if(res.isSuccessful){
                                    if(post != null){
                                      var chatController = Get.find<ChatControllerWayagram>();
                                      var message = {
                                        "receiverId":post.otherId.toString(),
                                        "chatId":post.chatId.toString(),
                                        "message": "NGN ${priceTextController.text} sent",
                                        "forwardMessage":false,
                                        "messageType": "textMessage"
                                      };
                                      chatController.listenToCustomEvent('notify_user',(data){
                                        SendMessageResponse sendMessageResponse = SendMessageResponse.fromJson(data);
                                        if(sendMessageResponse.status == true){
                                          chatController.update(['chats_screen']);
                                        }
                                        chatController.stopListeningToEvent("notify_user");
                                      });
                                      chatController.emitMessages("send_message", message);
                                    }
                                    Navigator.pop(Get.context!);
                                    AppOverlay.showSuccessSnackBar(title : "Success",content: "Money sent successfully");
                                  }else{
                                    AppOverlay.showErrorSnackBar(title : "Error",content: res.message ?? "An error occurred, please try again");
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
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 5,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Padding widgetAnalyticsWidget(String title, String subtitle, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
          color: getAppColor(AppColors.background),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xffEDEAEA), width: 1),
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
                      color: getAppColor(Colors.black),
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
                      color: getAppColor(Colors.black),
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
                  color: getAppColor(const Color(0xff4F4F4F)),
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