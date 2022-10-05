import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import 'app_ratings.dart';

class VerticalListTile extends StatelessWidget {
  const VerticalListTile({
    this.onTap,
    Key? key,
    this.img = '',
    this.ist,
    this.scnd,
    this.third,
    this.fourth,
    this.fifth,
    this.hasRating = true,
    this.size = const Size(155, 155),
    this.rating,
  }) : super(key: key);

  final Function()? onTap;
  final String img;
  final String? ist;
  final String? scnd;
  final String? third;
  final String? fourth;
  final String? fifth;
  final bool hasRating;
  final double? rating;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.height,
        margin: const EdgeInsets.only(bottom: 25),
        child: Row(
          children: [
            Container(
              height: double.infinity,
              width: Get.width *0.28,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(img), fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: Get.height *0.005),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ist != null
                    ? Column(
                      children: [
                        Text(
                            ist!,
                            style: AppTextStyle.bodyText1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: 5),
                      ],
                    )
                    : const SizedBox.shrink(),
                hasRating
                    ? Column(
                      children: [
                        AppRating(
                            onRatingUpdate: (val) {},
                            rating: rating,
                          ),
                        const SizedBox(height: 5),
                      ],
                    )
                    : const SizedBox.shrink(),
                scnd != null
                    ? Column(
                      children: [
                        SizedBox(
                            width: Get.width * 0.6,
                          child: Text(
                              scnd!,
                              style: AppTextStyle.caption,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    )
                    : const SizedBox.shrink(),
                third != null
                    ?  Column(
                      children: [
                        SizedBox(
                  width: Get.width * 0.6,
                          child: Text(
                              third!,
                              style: AppTextStyle.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                            ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    )
                    : const SizedBox.shrink(),
                fourth != null
                    ?  Column(
                      children: [
                        SizedBox(
                  width: Get.width * 0.6,
                          child: Text(
                              fourth!,
                              style: AppTextStyle.caption.copyWith(color: AppColors.bostonUniRed,),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    )
                    : const SizedBox.shrink(),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

class VerticalTileShimmer extends StatelessWidget {
  const VerticalTileShimmer({
    Key? key,
    this.size = const Size(155, 155),
  }) : super(key: key);



  final Size size;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: size.height,
        margin: const EdgeInsets.only(bottom: 25),
        child: Row(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.white.withOpacity(0.4),
              highlightColor: Colors.white.withOpacity(0.2),
              child: Container(
                height: double.infinity,
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
               Shimmer.fromColors(
                        baseColor: Colors.white.withOpacity(0.4),
                        highlightColor: Colors.white.withOpacity(0.2),
                        child: Container(
                          width: constraints.maxWidth * 0.5,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      )
                   ,
              
                    Shimmer.fromColors(
                        baseColor: Colors.white.withOpacity(0.4),
                        highlightColor: Colors.white.withOpacity(0.2),
                        child: Container(
                          width: constraints.maxWidth * 0.25,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      )
                  ,
                Shimmer.fromColors(
                  baseColor: Colors.white.withOpacity(0.4),
                  highlightColor: Colors.white.withOpacity(0.2),
                  child: Container(
                    width: constraints.maxWidth * 0.25,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}
