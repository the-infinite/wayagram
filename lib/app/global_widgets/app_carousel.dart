import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

class AppCarousel extends StatefulWidget {
  const AppCarousel({
    Key? key,
    required this.img,
    this.subtitle,
    this.title,
    this.height,
  }) : super(key: key);
  final String img;
  final String? title;
  final String? subtitle;
  final double? height;

  @override
  State<AppCarousel> createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
  final height = widget. height ?? Get.height * 0.4;
    return Column(
      children: [
        CarouselSlider(
          items: [1, 3, 434]
              .map(
                (e) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: AppColors.bostonUniRed,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(widget.img),
                        fit: BoxFit.cover,
                      )),
                ),
              )
              .toList(),
          options: CarouselOptions(
              viewportFraction: 0.68,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
              height: height,
              enlargeCenterPage: true),
        ),
        SizedBox(height: widget.title != null ? 20 : 15),
        Column(
          children: [
            widget.title != null
                ? Text(widget.title!)
                : const SizedBox.shrink(),
            SizedBox(height: widget.title != null ? 3 : 0),
            widget.subtitle != null
                ? Text(
                    widget.subtitle!,
                    style: AppTextStyle.caption.copyWith(
                      color: AppColors.onyx,
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
            SizedBox(
              height: 10,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: index == currentIndex
                            ? AppColors.bostonUniRed
                            : AppColors.darkChocolate,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 6,
                      width: currentIndex == index ? 25 : 16,
                    )
                  ],
                ),
                separatorBuilder: (context, index) => const SizedBox(
                  width: 5,
                ),
                itemCount: 3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
