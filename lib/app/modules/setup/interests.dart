import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wayagram/app/global_widgets/app_button.dart';
import 'package:wayagram/app/modules/home/home.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../controllers/auth_controller.dart';

class Interests extends GetView<AuthController>{
  const Interests({Key? key}) : super(key: key);

  static const route = '/interests';

  @override
  Widget build(BuildContext context) {
    List<String> interestList = [
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
      'Other'
    ];
    List<String> interestListEmoji = [
      '🌍',
      '🍔',
      '👗',
      '🎵',
      '⚽',
      '🎮',
      '🎥',
      '📺',
      '📚',
      '🎨',
      '📷',
      '🏋️',
      '💄',
      '🔨',
      '🎨',
      '🖥️',
      '🔬',
      '🌳',
      '🐶',
      '📜',
      '🗳️',
      '💰',
      '📚',
      '🙏',
      '🏥',
      '👶',
      '💑',
      '🎭',
      '📰',
      '🛋️',
      '🤷',
      '👍'
    ];
    return  GetBuilder<AuthController>(
      builder: (controller){
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
            actions: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: Get.width * 0.25,
                      height: Get.height * 0.04,
                      child: AppButton(title: "Continue", onPressed: () async {
                        //wait 10 seconds
                        await Future.delayed(const Duration(seconds: 2), () {
                          Get.offAllNamed(Home.route);
                        });
                        //Get.toNamed(Home.route);
                      },
                        padding: const EdgeInsets.only(top: 9, bottom: 9),
                      )
                  ),
                ],
              ),
              SizedBox(
                width: Get.width * 0.03,
              ),
            ],
          ),
          body: SizedBox(
            height: Get.height,
            child: GridView.builder(
              itemCount: interestList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      if (!controller.interests.contains(interestList[index])) {
                        controller.interests.add(interestList[index]);
                      } else {
                        controller.interests.remove(interestList[index]);
                      }
                      controller.update();
                    },
                    child: Container(
                      width: Get.width * 0.3,
                      height: Get.width * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.background,
                        border: Border.all(
                          color: AppColors.grey.withOpacity(0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          //Radio Button
                          Positioned(
                            top: 1,
                            left: 1,
                            child: Checkbox(
                              value: controller.interests.contains(interestList[index]),
                              onChanged: (value) {
                                if (value == true) {
                                  controller.interests.add(interestList[index]);
                                } else {
                                  controller.interests.remove(interestList[index]);
                                }
                                controller.update();
                              },
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //
                                Text(
                                  interestListEmoji[index],
                                  style: AppTextStyle.headline4.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 25,
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                Text(
                                  interestList[index],
                                  style: AppTextStyle.headline4.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
