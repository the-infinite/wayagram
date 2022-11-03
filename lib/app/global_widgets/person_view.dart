import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import 'app_avatar.dart';

class PersonView extends StatefulWidget {
  const PersonView({
    Key? key,
    this.isLoading = false,
    required this.name,
    required this.username,
    required this.profilePic,
    this.length = 0,
  }) : super(key: key);

  final bool isLoading;
  final List<String> name;
  final List<String> username;
  final List<String> profilePic;
  final int length;

  @override
  State<PersonView> createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {

  @override
  Widget build(BuildContext context) {
    var isLoading = widget.isLoading;
    return ListView.builder(
      itemCount: isLoading ? 3 : widget.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if(isLoading){
          return SizedBox(
            height: Get.height * 0.08,
            width: Get.width * 0.35,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.8),
              highlightColor: Colors.grey.withOpacity(0.2),
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
                height: Get.height * 0.18,
                width: Get.width * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(.5),
                ),
              ),
            ),
          );
        }
        return Container(
          margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: IconButton(
                  icon: AppAvatar(
                    imgUrl: widget.profilePic.length>= index ?  widget.profilePic[index] : '',
                    radius: 50,
                  ),
                  onPressed: null,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name[index],
                    style: const TextStyle(
                      color: Colors.black ,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: Get.width*0.8,
                    child: Text(
                      "@${widget.username[index]}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}