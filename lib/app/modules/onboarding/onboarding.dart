import 'package:carousel_slider/carousel_slider.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:wayagram/app/modules/multiplexor/multiplexor.dart';
import '../../../app/global_widgets/app_button.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../bindings/wayagram_binding.dart';
import '../../global_widgets/helpers/dark_mode_helper.dart';
import 'onboarding_item.dart';

CarouselController buttonCarouselController = CarouselController();

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key? key}) : super(key: key);
  static const route = '/onboarding';

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: getAppColor(AppColors.background),
            statusBarIconBrightness: getAppBrightness(),
            statusBarBrightness: getAppBrightness(),
            systemNavigationBarColor: getAppColor(AppColors.background),
            systemNavigationBarIconBrightness: getAppBrightness()
        ),
        child: Scaffold(
          body: SafeArea(
            child: Container(
              color: getAppColor(AppColors.background),
              child: Padding(
                padding: EdgeInsets.all(AppThemes.appPaddingVal),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () {
                          Get.to(() => Multiplexor(),binding: WayagramBinding());
                        },
                        child: Text(
                          'Skip',
                          style: AppTextStyle.bodyText1.copyWith(color: AppColors.grey,fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: CarouselSlider(
                        items: _screen
                            .map((e) => OnboardingItem(
                          onboardingModel: e, pos: _screen.indexOf(e),
                        ))
                            .toList(),
                        carouselController: buttonCarouselController,
                        options: CarouselOptions(
                          height: double.infinity,
                          autoPlay: false,
                          viewportFraction: 1,
                          initialPage: 0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height*0.03,
                    ),
                    SizedBox(
                      height: 10,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            index == currentIndex
                                ? Container(
                              decoration: BoxDecoration(
                                color: index == currentIndex
                                    ? AppColors.primary
                                    : AppColors.fadedPrimary,
                                //borderRadius: BorderRadius.circular(8),
                                  shape: BoxShape.circle
                              ),
                              height: 8,
                              width: 8,
                            )
                                : Container(
                              decoration: BoxDecoration(
                                  color: index == currentIndex
                                      ? AppColors.primary
                                      : AppColors.fadedPrimary,
                                  shape: BoxShape.circle),
                              height: 8,
                              width: 8,
                            ),
                          ],
                        ),
                        separatorBuilder: (context, index) => SizedBox(
                          width: 5,
                        ),
                        itemCount: 7,
                      ),
                    ),
                    SizedBox(
                      height: Get.height*0.06,
                    ),
                    AppButton(
                      title: currentIndex == 6 ? 'Continue' : 'Next',
                      onPressed: (){
                        buttonCarouselController.nextPage();
                        if (currentIndex == 6) {
                          Get.to(() => Multiplexor(),binding: WayagramBinding());
                        }
                      },
                      borderRadius: 360,
                    ),
                    SizedBox(
                      height: Get.height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}

class OnboardingModel {
  final String image;
  final String title;
  final String subtitle;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

List<OnboardingModel> _screen = [
  OnboardingModel(
    image: 'one',
    title: 'Socialize',
    subtitle: 'Connect to the world of million\npeople, chat, voice/video call, post,\nbuy or sell product, manage\ndonations, manage events and\nadvertise your products...',
  ),
  OnboardingModel(
    image: 'two',
    title: 'Digital Banking',
    subtitle:
        'Digital Banking personalised for\nyou to store funds safely, receive\nmoney, budget spendings, pay bills',
  ),
  OnboardingModel(
    image: 'three',
    title: 'Payment Link',
    subtitle: 'Send links to your customers to\npay you with via card, bank, ussd,\nwallet, or payAttitude',
  ),
  OnboardingModel(
    image: 'four',
    title: 'Request for Terminal POS',
    subtitle:
    'Request for Waya Point-of-sale (POS)\nTerminal Device and start\naccepting payment at your physical store.',
  ),
  OnboardingModel(
    image: 'five',
    title: 'Follow your Metrics',
    subtitle:
    'Stay up-to-date with your revenue,\npayouts and recent activity\non your business.',
  ),
  OnboardingModel(
    image: 'six',
    title: 'Safe & Secure',
    subtitle:
    'Your account & transactions are\nsafe & secure.',
  ),
  OnboardingModel(
    image: 'seven',
    title: 'Enjoy Instant Support',
    subtitle:
    'Search our FAQ for answers to\nany questions or chat with us ',
  ),
];
