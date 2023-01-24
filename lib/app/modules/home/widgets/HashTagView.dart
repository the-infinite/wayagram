
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';



class HashTagView extends StatelessWidget{
  const HashTagView({
    Key? key,
    this.isLoading = false,
    required this.title, required this.subtitle, required this.onClick,
  }) : super(key: key);

  final bool isLoading;
  final List<String> title;
  final List<String> subtitle;
  final Function(String title,String subtitle) onClick;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: isLoading ? 3 : title.length,
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

        return InkWell(
          onTap: (){
            onClick(title[index],subtitle[index]);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: Get.width*0.015),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title[index],
                      style: TextStyle(
                        color: getAppColor(Colors.black) ,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: Get.width*0.5,
                      child: Text(
                        subtitle[index],
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
          ),
        );
      },
    );
  }

}