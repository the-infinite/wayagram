import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/shop/data/model/model.dart';
import 'package:gap/gap.dart';

class ProductReviewWidget extends StatelessWidget {
  final Review review;
  const ProductReviewWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        image: AssetImage(review.customerImage),
                        fit: BoxFit.cover),
                  ),
                ),
                const Gap(8),
                Text(
                  review.customerName,
                  style: wayaTheme.textTheme.bodyMedium,
                ),
              ],
            ),
            RatingStars(
              rating: review.rating,
            )
          ],
        ),
        const Gap(6),
        Text(
          review.comments,
          style: wayaTheme.textTheme.hintStyle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const Gap(15)
      ],
    );
  }
}

class RatingStars extends StatelessWidget {
  final int rating;
  const RatingStars({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          size: 18,
          index < rating ? Icons.star : Icons.star_border,
          color: wayaTheme.colorScheme.customPrimary,
        );
      }),
    );
  }
}
