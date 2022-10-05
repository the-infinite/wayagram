import 'package:carousel_slider/carousel_slider.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return Scaffold(
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
                    style: AppTextStyle.bodyText1.copyWith(color: Colors.white),
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
                                    ? AppColors.bostonUniRed
                                    : AppColors.darkChocolate,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 6,
                              width: 16,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: index == currentIndex
                                      ? AppColors.bostonUniRed
                                      : AppColors.darkChocolate,
                                  shape: BoxShape.circle),
                              height: 8,
                              width: 8,
                            ),
                    ],
                  ),
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 5,
                  ),
                  itemCount: 4,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {

                },
                child: InkWell(
                  borderRadius: BorderRadius.circular(1000),
                  onTap: () {
                    buttonCarouselController.nextPage();
                    if (currentIndex == 3) {

                    }
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.bostonUniRed,
                    child: Icon(
                      currentIndex == 3
                          ? FeatherIcons.check
                          : FeatherIcons.arrowRight,
                      size: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
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
    image: 'onboarding1',
    title: 'Get all your tickets at ease',
    subtitle: 'Do you want to get tickets for concerts, cinema movies,vr games ? Do it here with ease.',
  ),
  OnboardingModel(
    image: 'onboarding2',
    title: 'Easy access to all booking ',
    subtitle:
        'Handle all your bookings ranging from hotels, apartments, and equipments here ',
  ),
  OnboardingModel(
    image: 'onboarding3',
    title: 'Book studio sessions easily',
    subtitle:
        'Your studio bookings have been simplified, you can now book studio time without hassle',
  ),
];
