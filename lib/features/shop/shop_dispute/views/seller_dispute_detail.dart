import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/shop_dispute/dialogs/dispute_evidence.dart';
import 'package:wayagram/features/shop/shop_dispute/views/add_evidence.dart';
import 'package:wayagram/features/shop/shop_dispute/views/dispute_chat/dispute_chat.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';

class SellerDisputeDetail extends ConsumerWidget {
  static const route = '/seller-dispute-details';
  const SellerDisputeDetail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

    //? Then the actual widget.
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: 'Dispute Details',
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Dispute Details", style: wayaTheme.textTheme.titleLarge),
            const Gap(3),
            Text(
              'Here is the full description and details of your dispute',
              style: wayaTheme.textTheme.hintStyle,
            ),
            const Gap(30),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (context, index) {
                return Container(); //OrderedProductCard();
              },
            ),
            const Gap(15),
            WayaButton(
              centerWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 28,
                    color: wayaTheme.colorScheme.customPrimary,
                  ),
                  const Gap(8),
                  Text(
                    "Send Message",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
              callback: () {
                WayaNav.toNamed(DisputeChat.route);
              },
              color: wayaTheme.colorScheme.primar50,
            ),
            const Gap(20),
            Text(
              "Provided Dispute Detail",
              style: wayaTheme.textTheme.hintStyle,
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: wayaTheme.colorScheme.success50,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check_circle,
                          size: 30,
                          color: wayaTheme.colorScheme.success,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Img-0000000000001.png",
                          style: wayaTheme.textTheme.bodySemiBold,
                        ),
                        const Gap(4),
                        Text(
                          "11 Sep, 2023 12:24PM",
                          style: wayaTheme.textTheme.hintStyle,
                        )
                      ],
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => DisputeEvidence(
                        disputeImage:
                            "https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374175/product1_owvv1d.png",
                      ),
                    );
                  },
                  child: Text(
                    "View Evidence",
                    style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.customPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),

            // Some space.
            const Gap(15),

            //? The reason for the dispute.
            AboutProduct(title: 'Reason for Dispute', content: 'Item not as described'),

            // Some space.
            const Gap(15),

            AboutProduct(
              title: 'Dispute Description',
              content: "I recently purchased Dr Teal's Ultra Moisturizing Body Wash,"
                  "expecting a luxurious experience based on the product description."
                  "However, upon using it, I found that it did not deliver the hydration"
                  "and revitalization promised. The scent was less citrusy than advertised,"
                  "and I did not notice any uplifting effects on my mood. Additionally, the"
                  "texture felt different from what I anticipated, lacking the creamy"
                  "consistency that was highlighted. Overall, this product did not meet"
                  "my expectations based on its description.",
            ),

            // Some space.
            const Gap(15),

            //? Additional information about the timelines of the dispute.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AboutProduct(
                    title: 'Date Submitted',
                    content: 'Aug 11, 12:35PM',
                  ),
                ),
                Expanded(
                  child: AboutProduct(
                    title: 'Status',
                    content: 'pending',
                  ),
                )
              ],
            ),

            // Some space.
            const Gap(30),

            //? Add evidence to the dispute to support my own claim.
            WayaButton(
              text: 'Add Evidence',
              callback: () {
                WayaNav.toNamed(AddEvidence.route);
              },
            ),

            // Some space.
            const Gap(8),

            //? Escalate this to a mediator.
            WayaButton(
                text: 'Escalate to Mediator',
                color: wayaTheme.colorScheme.transparent,
                textColor: wayaTheme.colorScheme.customPrimary,
                border: Border.all(width: 1, color: wayaTheme.colorScheme.customPrimary),
                callback: () {
                  // to be removed
                  WayaUtils.showNotice(
                      context: context,
                      buttonText: 'Yes, Escalate to Mediator',
                      secondButtonText: 'Cancel',
                      title: "Escalate to Mediator",
                      message:
                          'Please confirm whether you’d like to escalate this  \n dispute to a mediator. This cannot be undone when confirmed',
                      onPress: () {},
                      icon: Image.asset('assets/images/shop/mediator.png'));
                }),
          ],
        ));
  }
}
