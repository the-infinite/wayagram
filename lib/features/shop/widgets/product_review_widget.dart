import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';

import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/features/shop/seller/data/model/review_repsonse_model.dart';

class ProductReviewWidget extends StatelessWidget {
  final ReviewData review;
  const ProductReviewWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WayaImage(
                  imageUrl: "",
                  height: 40,
                  width: 40,
                  radius: BorderRadius.circular(40),
                ),
                const Gap(8),
                Text(
                  "${review.raterFirstName.capitalizeFirst} ${review.raterLastName.capitalizeFirst}",
                  style: wayaTheme.textTheme.bodyMedium,
                ),
              ],
            ),
            RatingStars(
              rating: review.score + 1,
            )
          ],
        ),
        const Gap(6),
        Text(
          review.review,
          style: wayaTheme.textTheme.hintStyle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const Gap(15)
      ],
    );
  }
}

class RatingStars extends StatefulWidget {
  final int rating;
  final double starSize;
  final Color initialColor;
  final Function(int rating)? onTap;
  const RatingStars(
      {super.key,
      required this.rating,
      this.starSize = 18,
      this.onTap,
      this.initialColor = WayaColors.customPrimary});

  @override
  State<StatefulWidget> createState() => _RatingStarState();
}

class _RatingStarState extends State<RatingStars> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Row(
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: widget.onTap == null
              ? null
              : () {
                  widget.onTap?.call(index + 1);
                },
          child: Icon(
            size: widget.starSize,
            index + 1 < widget.rating ? Icons.star : Icons.star_border,
            color: index + 1 < widget.rating
                ? wayaTheme.colorScheme.customPrimary
                : widget.initialColor,
          ),
        );
      }),
    );
  }
}
