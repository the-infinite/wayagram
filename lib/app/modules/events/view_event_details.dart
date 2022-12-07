import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wayagram/app/controllers/home_controller.dart';
import 'package:wayagram/app/global_widgets/app_button.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
import 'package:wayagram/app/modules/home/home.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../controllers/auth_controller.dart';
import '../../data/model/all_events_entity.dart';
import '../../data/model/blocked_accounts_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/group_model_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/document_picker.dart';
import '../../global_widgets/person_view.dart';
import '../home/widgets/events_view.dart';
import '../home/widgets/group_view.dart';
import '../home/widgets/notification_view.dart';
import '../profile/profile.dart';
import '../profile/update_profile.dart';

class ViewEventDetails extends StatefulWidget{
  const ViewEventDetails({Key? key, required this.event}) : super(key: key);

  final AllEventsData event;

  @override
  State<ViewEventDetails> createState() => _ViewEventDetailsState();
}

class _ViewEventDetailsState extends State<ViewEventDetails> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController(text: widget.event.eventUrl);
    var attendeeCount = 0;
    if(widget.event.eventParticipants != null){
      attendeeCount = widget.event.eventParticipants!.length;
    }

    return  GetBuilder<HomeControllerWayagram>(
      builder: (controller){
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('Event Details', style: AppTextStyle.subtitle1.copyWith(
              color: Colors.black,
              fontSize: Get.textScaleFactor * 18,
              fontWeight: FontWeight.bold,
            )),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.5),
              child: Container(
                height: 0.5,
                color: Colors.grey,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.025, right: Get.width * 0.025, top: Get.height * 0.02),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.event.eventPoster.toString(),
                      height: Get.height * 0.23,
                      width: Get.width,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.image_rounded,color: Colors.grey,size: Get.height*0.04),
                      ),
                      errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.event_rounded,color: Colors.grey,size: Get.height*0.04)
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.01),
                if(textController.text.isNotEmpty)
                  Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.025, right: Get.width * 0.025, top: Get.height * 0.02),
                  child: PageInput(
                    hint: "",
                    label:"",
                    readOnly: true,
                    controller: textController,
                    suffix: IconButton(
                      icon: const Icon(Icons.copy_rounded, color: Colors.grey),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: textController.text));
                        AppOverlay.showSuccessSnackBar(content: 'Copied to clipboard');
                      },
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.01),
                Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.025, right: Get.width * 0.025, top: Get.height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: Get.width*0.01),
                        child: Text(widget.event.eventName.toString(), style: AppTextStyle.subtitle1.copyWith(
                          color: Colors.black,
                          fontSize: Get.width*0.05,
                          fontWeight: FontWeight.w600,
                        )),
                      ),
                      SizedBox(height: Get.height*0.01),
                      Padding(
                        padding: EdgeInsets.only(left: Get.width*0.01),
                        child: Text("${DateFormat.yMMMMEEEEd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.event.eventStart.toString())))} at  ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.event.eventStart.toString())))}", style: AppTextStyle.subtitle1.copyWith(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: Get.width*0.04,
                          fontWeight: FontWeight.normal,
                        )),
                      ),
                      SizedBox(height: Get.height*0.01),
                      if(widget.event.eventOrganizer.toString() != "null")
                        _TextButton(
                         leading: Icon(Icons.people_alt_rounded, color: Colors.black.withOpacity(0.5)),
                          text: widget.event.eventOrganizer.toString(),
                         onPressed: () {
                        },
                        ),
                      SizedBox(height: Get.height*0.01),
                      _TextButton(
                        leading: Icon(Icons.location_on, color: Colors.black.withOpacity(0.5)),
                        text: widget.event.location.toString(),
                        onPressed: () {
                        },
                      ),
                      SizedBox(height: Get.height*0.01),
                      _TextButton(
                        leading: Icon(FeatherIcons.tag, color: Colors.black.withOpacity(0.5)),
                        text: widget.event.isPaid != true ? "Free to attend" : "Paid to attend: ₦${widget.event.amount.toString()}",
                        onPressed: () {
                        },
                      ),
                      SizedBox(height: Get.height*0.01),
                      _TextButton(
                        leading: Icon(Icons.perm_contact_calendar_rounded, color: Colors.black.withOpacity(0.5)),
                        text: "Registered:  ${attendeeCount.toString()}",
                        onPressed: () {
                        },
                      ),
                    ],
                  ),
                ),
              ],
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

class _TextButton extends StatelessWidget {
  final Widget leading;
  final String text;
  final Function() onPressed;
  const _TextButton({required this.text, required this.onPressed, required this.leading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Get.height*0.018),
        child: Row(children: [
          SizedBox(width: Get.width*0.01),
          leading,
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: AppTextStyle.subtitle1.copyWith(color: Colors.black.withOpacity(0.5)),
            ),
          ),
        ]),
      ),
    );
  }
}

