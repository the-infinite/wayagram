import 'package:carousel_slider/carousel_slider.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../app/global_widgets/app_button.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import 'onboarding_item.dart';

CarouselController buttonCarouselController = CarouselController();

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);
  static const route = '/onboarding';

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark
        ),
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppThemes.appPaddingVal),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {

                      },
                      child: Text(
                        'Skip',
                        style: AppTextStyle.bodyText1.copyWith(color: AppColors.grey,fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  const SizedBox(
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
                  const SizedBox(
                    height: 31,
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
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 5,
                      ),
                      itemCount: 7,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  AppButton(
                    title: 'Next',
                    onPressed: (){},
                    borderRadius: 360,
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                ],
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
    image: 'onboarding_1',
    title: 'Socialize',
    subtitle: 'Connect to the world of million\npeople, chat, voice/video call, post,\nbuy or sell product, manage\ndonations, manage events and\nadvertise your products...',
  ),
  OnboardingModel(
    image: 'onboarding_2',
    title: 'Digital Banking',
    subtitle:
        'Digital Banking personalised for\nyou to store funds safely, receive\nmoney, budget spendings, pay bills',
  ),
  OnboardingModel(
    image: 'onboarding_3',
    title: 'Payment Link',
    subtitle: 'Send links to your customers to\npay you with via card, bank, ussd,\nwallet, or payAttitude',
  ),
  OnboardingModel(
    image: 'onboarding_4',
    title: 'Request for Terminal POS',
    subtitle:
    'Request for Waya Point-of-sale (POS)\nTerminal Device and start\naccepting payment at your physical store.',
  ),
  OnboardingModel(
    image: 'onboarding_5',
    title: 'Follow your Metrics',
    subtitle:
    'Stay up-to-date with your revenue,\npayouts and recent activity\non your business.',
  ),
  OnboardingModel(
    image: 'onboarding_6',
    title: 'Safe & Secure',
    subtitle:
    'Your account & transactions are\nsafe & secure.',
  ),
  OnboardingModel(
    image: 'onboarding_7',
    title: 'Enjoy Instant Support',
    subtitle:
    'Search our FAQ for answers to\nany questions or chat with us ',
  ),
];
