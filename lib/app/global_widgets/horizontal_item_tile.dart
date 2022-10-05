import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../../core/theme/app_themes.dart';
import 'app_ratings.dart';

class HorizontalItemTile extends StatelessWidget {
  const HorizontalItemTile(
      {Key? key,
      this.onTap,
      this.img = '',
      this.ist,
      this.scnd,
      this.fourth,
      this.hasRating = true,
      this.height = double.infinity,
      this.width,
      this.margin = const EdgeInsets.only(right: 25),
      this.rating})
      : super(key: key);

  final Function()? onTap;
  final String img;
  final String? ist;
  final String? scnd;
  final String? fourth;
  final bool hasRating;
  final double height;
  final double? width;
  final EdgeInsets margin;
  final double? rating;

  @override
  Widget build(BuildContext context) {
    double w = width ?? (Get.width / 2) - (AppThemes.appPaddingVal * 2);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: margin,
              height: height,
              width: w,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(img),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            width: w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 11),
                ist != null
                    ? Text(
                        ist!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : const SizedBox.shrink(),
                SizedBox(height: ist == null ? 0 : 3),
                scnd != null
                    ? Text(
                        scnd!,
                        style: AppTextStyle.caption,
                      )
                    : const SizedBox.shrink(),
                SizedBox(height: scnd == null ? 0 : 3),
                hasRating
                    ? AppRating(
                        onRatingUpdate: (val) {},
                        rating: rating,
                      )
                    : const SizedBox.shrink(),
                SizedBox(height: hasRating ? 3 : 0),
                fourth != null
                    ? Text(
                        fourth!,
                        style: AppTextStyle.caption
                            .copyWith(color: AppColors.bostonUniRed),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalItemShimmer extends StatelessWidget {
  const HorizontalItemShimmer({
    Key? key,
    this.height = double.infinity,
    this.width,
    this.margin = const EdgeInsets.only(right: 25),
  }) : super(key: key);

  final double height;
  final double? width;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    double w = width ?? (Get.width / 2) - (AppThemes.appPaddingVal * 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.4),
            highlightColor: Colors.white.withOpacity(0.2),
            child: Container(
              margin: margin,
              height: height,
              width: w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        SizedBox(
          width: w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 11),
              Shimmer.fromColors(
                baseColor: Colors.white.withOpacity(0.4),
                highlightColor: Colors.white.withOpacity(0.2),
                child: Container(
                  height: 15,
                  width: double.infinity,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 3),
              Shimmer.fromColors(
                baseColor: Colors.white.withOpacity(0.4),
                highlightColor: Colors.white.withOpacity(0.2),
                child: Container(
                  height: 12,
                  width: w / 1.6,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 3),
              Shimmer.fromColors(
                baseColor: Colors.white.withOpacity(0.4),
                highlightColor: Colors.white.withOpacity(0.2),
                child: Container(
                  height: 12,
                  width: w / 2,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HorizontalItemShimmer2 extends StatelessWidget {
  const HorizontalItemShimmer2({
    Key? key,
    this.height = double.infinity,
    this.width,
    this.margin = const EdgeInsets.only(right: 0),
  }) : super(key: key);

  final double height;
  final double? width;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    double w = width ?? (Get.width / 2) - (AppThemes.appPaddingVal * 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.4),
            highlightColor: Colors.white.withOpacity(0.2),
            child: Container(
              margin: margin,
              height: height,
              width: w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),

      ],
    );
  }
}
