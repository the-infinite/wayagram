import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/bottom_view/bottom_view.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/shop/order/vm/order_vm.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/widgets/product_review_widget.dart';

class ReviewProduct extends ConsumerStatefulWidget {
  final String shopId;

  const ReviewProduct({
    super.key,
    required this.shopId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReviewProductState();
}

class _ReviewProductState extends ConsumerState<ReviewProduct> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    final wayaTheme = Theme.of(context);
    final state = ref.watch(shopVmProvider);

    void rateProduct(int r) {
      setState(() {
        rating = r + 1;
      });
    }

    return Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
              left: Radius.circular(16), right: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(WayaAssets.images.cEmptyConversation.path),
              const Gap(24),
              Text(
                "Share your Experience",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(14),
              Text(
                " Help other buyers by sharing your thoughts about the shop product and service. Your feedback matters!",
                textAlign: TextAlign.center,
                style: wayaTheme.textTheme.descriptionStyle,
              ),
              const Gap(24),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "How would you rate your experience?",
                    textAlign: TextAlign.center,
                    style: wayaTheme.textTheme.descriptionStyle,
                  ),
                  const Gap(10),
                  Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 220,
                        child: RatingStars(
                          rating: rating,
                          starSize: 40,
                          initialColor: WayaColors.greyColor300,
                          onTap: rateProduct,
                        ),
                      ))
                ],
              ),
              const Gap(24),
              WayaTextFormField(
                controller: _controller,
                hintText:
                    "Write your review here, (e.g product quality, delivery experience, customer support)",
                line: 5,
                padding: const EdgeInsets.all(12),
                label: "What do you think of the shop?",
              ),
              const Gap(24),
              WayaButton(
                callback: !state.isReviewing
                    ? () {
                        if (_controller.text.isEmpty) {
                          return WayaSnackBar.showToast("Add a review");
                        }

                        ref.read(shopVmProvider.notifier).reviewProduct(
                            shopId: widget.shopId,
                            review: _controller.text,
                            score: rating > 1 ? rating - 1 : 0,
                            raterId: ConversationState.self.id,
                            context: context);
                      }
                    : null,
                centerWidget: LoadingState(
                    loading: state.isReviewing, text: "Submit Review"),
              ),
              const Gap(10),
              WayaButton(
                  callback: () {
                    WayaUtils.showNotice(
                        context: context,
                        title: 'Review Submitted',
                        message:
                            'Thank you for your feedback! Your review helps us improve and guide other buyers',
                        onPress: () {
                          WayaNav.replaceNamed(BottomView.route, arguments: 1);
                        },
                        icon: Image.asset(WayaAssets.images.dCodeValid.path),
                        buttonText: 'Go To Shop');
                  },
                  textColor: wayaTheme.colorScheme.greyColor500,
                  color: wayaTheme.colorScheme.transparent,
                  border: Border.all(
                      color: wayaTheme.colorScheme.greyColor500, width: 1),
                  text: 'Skip')
            ],
          ),
        ));
  }
}
