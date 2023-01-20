import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wayagram/app/controllers/home_controller.dart';
import 'package:wayagram/app/global_widgets/app_button.dart';
import 'package:wayagram/app/modules/home/home.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../core/theme/app_styles.dart';
import '../../controllers/auth_controller.dart';
import '../../data/model/all_events_entity.dart';
import '../../data/model/blocked_accounts_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/group_model_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/overlays.dart';
import '../../global_widgets/person_view.dart';
import '../home/widgets/events_view.dart';
import '../home/widgets/group_view.dart';
import '../home/widgets/notification_view.dart';
import '../profile/profile.dart';
import '../profile/update_profile.dart';

class AllEvents extends StatefulWidget{
  AllEvents({Key? key}) : super(key: key);

  static const route = '/allEvents';

  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return  GetBuilder<HomeControllerWayagram>(
      builder: (controller){
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: getAppColor(AppColors.background),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: getAppColor(AppColors.background),
                statusBarIconBrightness: getAppBrightness(),
                statusBarBrightness: getAppBrightness(),
                systemNavigationBarColor: getAppColor(AppColors.background),
                systemNavigationBarIconBrightness: getAppBrightness()
            ),
            title: Text('All Events', style: AppTextStyle.subtitle1.copyWith(
              color: getAppColor(Colors.black),
              fontSize: Get.textScaleFactor * 18,
              fontWeight: FontWeight.bold,
            )),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: getAppColor(Colors.black),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.5),
              child: Container(
                height: 0.5,
                color: Colors.grey,
              ),
            ),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: getAppColor(AppColors.background),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder<ApiResponse>(
                      future: controller.getCreatedEvents,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                          final moments = snapshot.data!.data as AllEventsEntity;
                          if(moments.data == null){
                            return SizedBox.shrink();
                          }
                          print(moments.data!.length);
                          return EventsView(
                            moments: moments.data,
                            title: 'My Created Events',
                            buttonText: 'View',
                            onLikeClick: (event){
                              var body = {"event_id": event.id.toString(), "going": "yes"};
                              controller.postData(body, "wayagram-service/all-posts/show-interest-in-event?profile_id=${fullProfile.id}").then((value) {
                                if(value.isSuccessful){
                                  AppOverlay.showSuccessSnackBar(content: "Event Liked Successfully");
                                  controller.update();
                                }else{
                                  AppOverlay.showErrorSnackBar(content: "An Error Occurred");
                                }
                              });
                            },
                          );
                        } else {
                          var savedEvents = MyPref.createdEvents.val;
                          if(savedEvents.isNotEmpty) {
                            var events = AllEventsEntity.fromJson(jsonDecode(savedEvents));
                            print(events.data!.length);
                            return EventsView(
                                moments: events.data,
                              title: 'My Created Events',
                              buttonText: 'View',
                              onButtonClick: (event){

                              },
                              onLikeClick: (event){
                                var body = {"event_id": event.id.toString(), "going": "yes"};
                                controller.postData(body, "wayagram-service/all-posts/show-interest-in-event?profile_id=${fullProfile.id}").then((value) {
                                  if(value.isSuccessful){
                                    AppOverlay.showSuccessSnackBar(content: "Event Liked Successfully");
                                    controller.update();
                                  }else{
                                    AppOverlay.showErrorSnackBar(content: "An Error Occurred");
                                  }
                                });
                              },
                            );
                          }else{
                            if(snapshot.connectionState == ConnectionState.done){
                              return SizedBox.shrink();
                            }
                            return EventsView(isLoading: true);
                          }
                        }
                      }),
                  FutureBuilder<ApiResponse>(
                      future: controller.getEventsToAttend,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                          final moments = snapshot.data!.data as AllEventsEntity;
                          if(moments.data == null){
                            return SizedBox.shrink();
                          }else{
                            for (var element in moments.data!) {
                              var containsLiked = element.eventLikes?.where((element) => element.profileId == fullProfile.id).toList();
                              if(containsLiked == null){
                                return SizedBox.shrink();
                              }else if(containsLiked.isEmpty){
                                return SizedBox.shrink();
                              }
                            }
                          }
                          return EventsView(
                            moments: moments.data,
                            title: 'Liked Events',
                            onLikeClick: (event){
                              var body = {"event_id": event.id.toString(), "going": "yes"};
                              controller.postData(body, "wayagram-service/all-posts/show-interest-in-event?profile_id=${fullProfile.id}").then((value) {
                                if(value.isSuccessful){
                                  AppOverlay.showSuccessSnackBar(content: "Event Liked Successfully");
                                  controller.update();
                                }else{
                                  AppOverlay.showErrorSnackBar(content: "An Error Occurred");
                                }
                              });
                            },
                          );
                        } else {
                          var savedEvents = MyPref.eventsToAttend.val;
                          if(savedEvents.isNotEmpty) {
                            var events = AllEventsEntity.fromJson(jsonDecode(savedEvents));
                            for (var element in events.data!) {
                              var containsLiked = element.eventLikes?.where((element) => element.profileId == fullProfile.id).toList();
                              if(containsLiked == null){
                                return SizedBox.shrink();
                              }else if(containsLiked.isEmpty){
                                return SizedBox.shrink();
                              }
                            }
                            return EventsView(moments: events.data,title: 'Liked Events',onLikeClick: (event){
                              var body = {"event_id": event.id.toString(), "going": "yes"};
                              controller.postData(body, "wayagram-service/all-posts/show-interest-in-event?profile_id=${fullProfile.id}").then((value) {
                                if(value.isSuccessful){
                                  AppOverlay.showSuccessSnackBar(content: "Event Liked Successfully");
                                  controller.update();
                                }else{
                                  AppOverlay.showErrorSnackBar(content: "An Error Occurred");
                                }
                              });
                            });
                          }else{
                            if(snapshot.connectionState == ConnectionState.done){
                              return SizedBox.shrink();
                            }
                            return EventsView(isLoading: true);
                          }
                        }
                      }),
                  FutureBuilder<ApiResponse>(
                      future: controller.getEventsToAttend,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                          final moments = snapshot.data!.data as AllEventsEntity;
                          if(moments.data == null){
                            return SizedBox.shrink();
                          }
                          return EventsView(
                              moments: moments.data,
                            title: 'All Events',
                            onLikeClick: (event){
                              var body = {"event_id": event.id.toString(), "going": "yes"};
                              controller.postData(body, "wayagram-service/all-posts/show-interest-in-event?profile_id=${fullProfile.id}").then((value) {
                                if(value.isSuccessful){
                                  AppOverlay.showSuccessSnackBar(content: "Event Liked Successfully");
                                  controller.update();
                                }else{
                                  AppOverlay.showErrorSnackBar(content: "An Error Occurred");
                                }
                              });
                            },
                          );
                        } else {
                          var savedEvents = MyPref.eventsToAttend.val;
                          if(savedEvents.isNotEmpty) {
                            var events = AllEventsEntity.fromJson(jsonDecode(savedEvents));
                            return EventsView(moments: events.data,title: 'All Events',onLikeClick: (event){
                              var body = {"event_id": event.id.toString(), "going": "yes"};
                              controller.postData(body, "wayagram-service/all-posts/show-interest-in-event?profile_id=${fullProfile.id}").then((value) {
                                if(value.isSuccessful){
                                  AppOverlay.showSuccessSnackBar(content: "Event Liked Successfully");
                                  controller.update();
                                }else{
                                  AppOverlay.showErrorSnackBar(content: "An Error Occurred");
                                }
                              });
                            });
                          }else{
                            if(snapshot.connectionState == ConnectionState.done){
                              return SizedBox.shrink();
                            }
                            return EventsView(isLoading: true);
                          }
                        }
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

