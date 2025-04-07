import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/bottom_view/bottom_view.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/shop/cart/data/model/cart_response_model.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/widgets/ordered_product_card.dart';
import 'package:wayagram/features/shop/widgets/product_review_widget.dart';

class ReviewProduct extends ConsumerStatefulWidget {
  final Order order;

  const ReviewProduct({
    super.key,
    required this.order,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReviewProductState();
}

class _ReviewProductState extends ConsumerState<ReviewProduct> {
  int rating = 0;
  late PageController _pageController;
  late TextEditingController controller;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();

    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              // Image.asset(WayaAssets.images.cEmptyConversation.path),
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
                " Help other buyers by sharing your thoughts about the product and service. Your feedback matters!",
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
                  const Gap(20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Product Ordered",
                        textAlign: TextAlign.start,
                        style: wayaTheme.textTheme.descriptionStyle.copyWith(
                          color: wayaTheme.colorScheme.customBlack,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      const Gap(10),
                      SizedBox(
                        height: 95.sp,
                        child: PageView.builder(
                            controller: _pageController,
                            itemCount: widget.order.items.length,
                            itemBuilder: (context, index) {
                              CartProduct order = CartProduct(
                                  price: double.parse(
                                          widget.order.items[index].price)
                                      .toInt(),
                                  quantity: widget.order.items[index].quantity,
                                  productId:
                                      widget.order.items[index].productId,
                                  productName:
                                      widget.order.items[index].productName,
                                  deliveryCharge: false,
                                  unitPrice: widget.order.items[index].price,
                                  productImage:
                                      widget.order.items[index].productImage ??
                                          '',
                                  deliveryOptions: '');
                              return OrderedProductCard(orders: order);
                            }),
                      ),
                    ],
                  ),
                  const Gap(4),
                  Align(
                    alignment: Alignment.center,
                    child: WayaCustomIndicator(
                      currentPage: 0,
                      pageCount: widget.order.items.length,
                      width: 30,
                      height: 6,
                      currentWidth: 30,
                    ),
                  ),
                  const Gap(20),
                  Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 220.sp,
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
                controller: controller,
                hintText:
                    "Write your review here, (e.g product quality, delivery experience, customer support)",
                line: 5,
                padding: const EdgeInsets.all(12),
                label: "What do you think of the product or service?",
              ),
              const Gap(24),
              WayaButton(
                callback: !state.isReviewing
                    ? () async {
                        if (controller.text.isEmpty) {
                          return WayaSnackBar.showToast("Add a review");
                        }

                        bool? result = await ref
                            .read(shopVmProvider.notifier)
                            .reviewProduct(
                                productId:
                                    widget.order.items[currentPage].productId,
                                review: controller.text,
                                score: rating > 1 ? rating - 1 : 0,
                                raterId: ConversationState.self.id,
                                context: context);

                        setState(() {
                          rating = 0;
                          controller = TextEditingController(text: "");
                        });

                        if (currentPage < widget.order.items.length - 1) {
                          setState(() {
                            currentPage = currentPage + 1;
                          });
                          _pageController.animateToPage(
                            currentPage,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );

                          return;
                        }

                        if (result == true &&
                            currentPage == widget.order.items.length - 1) {
                          WayaNav.goBack();
                          if (context.mounted) {
                            return WayaUtils.showNotice(
                                context: context,
                                title: 'Handover Successful!',
                                message:
                                    'The confirmation code has been verified. The product is now officially handed over to the buyer',
                                onPress: () {
                                  WayaNav.replaceNamed(BottomView.route,
                                      arguments: 1);
                                },
                                icon: Image.asset(
                                    WayaAssets.images.dCodeValid.path),
                                buttonText: 'Go To Shop');
                          }
                        }
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
