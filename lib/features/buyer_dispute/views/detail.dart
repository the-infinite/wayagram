import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/buyer_dispute/modals/add_evidence.dart';
import 'package:wayagram/features/buyer_dispute/modals/evidence.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';

class DisputeDetail extends ConsumerWidget {
  final String id;
  static const route = '/dispute/detail';

  // Construct.
  const DisputeDetail({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    //? Then the actual widget.
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: 'Dispute Details',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //? This is fine.
          Text(
            "Dispute Details",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24.sp,
            ),
          ),

          // Space.
          const Gap(3),

          //? Subtitle.
          Text(
            'Here is the full description and details of your dispute',
            style: theme.textTheme.hintStyle,
          ),

          // Some space.
          const Gap(30),

          Text(
            "Product Ordered",
            style: theme.textTheme.descriptionStyle.copyWith(
              color: theme.colorScheme.customBlack,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),

          const Gap(15),

          //? Other things.
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container();
            },
          ),

          // Some space.
          Gap(20.h),

          //? Section title.
          Text(
            "Provided Dispute Detail",
            style: theme.textTheme.hintStyle,
          ),

          // Some space.
          Gap(15.h),

          //? Our selected dispute evidence.
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
                      color: theme.colorScheme.success50,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check_circle,
                        size: 30,
                        color: theme.colorScheme.success,
                      ),
                    ),
                  ),
                  const Gap(10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "skp9khjszrmt1gzy4ufa.jpg",
                        style: theme.textTheme.bodySemiBold,
                      ),
                      const Gap(4),
                      Text(
                        "11 Sep, 2023 12:24PM",
                        style: theme.textTheme.hintStyle,
                      )
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () => WayaUtils.showModalSheet(
                  context,
                  child: BuyerDisputeEvidenceModal(
                    image:
                        "https://res.cloudinary.com/dr99moeep/image/upload/v1737303486/uploads/skp9khjszrmt1gzy4ufa.jpg",
                  ),
                ),
                child: Text(
                  "View Evidence",
                  style: TextStyle().wayaCopyWith(
                    color: theme.colorScheme.customPrimary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),

          // Some space.
          const Gap(15),

          //? The reason for the dispute.
          AboutProduct(
            title: 'Reason for Dispute',
            content: 'Item not as described',
          ),

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
                child: AboutProductStatus(
                  title: 'Status',
                  content: 'in progress',
                  backgroundColor: theme.colorScheme.primaryBrown50,
                  textColor: theme.colorScheme.primary600,
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
              WayaUtils.showModalSheet(
                context,
                child: BuyerDisputeAddEvidenceModal(),
              );
            },
          ),

          // Some space.
          const Gap(8),

          //? Escalate this to a mediator.
          WayaButton(
            text: 'Escalate to Mediator',
            color: theme.colorScheme.transparent,
            textColor: theme.colorScheme.customPrimary,
            border: Border.all(width: 1, color: theme.colorScheme.customPrimary),
            callback: () => WayaUtils.showNotice(
              context: context,
              buttonText: 'Yes, Escalate to Mediator',
              secondButtonText: 'Cancel',
              title: "Escalate to Mediator",
              message: "Please confirm whether you'd like to escalate this"
                  "dispute to a mediator. This cannot be undone when confirmed",
              onPress: () {},
              onCancel: () => WayaNav.goBack(),
              icon: WayaAssets.images.shop.mediator.image(),
            ),
          ),
        ],
      ),
    );
  }
}
