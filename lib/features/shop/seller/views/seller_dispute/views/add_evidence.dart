import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';
import 'package:wayagram/features/shop/widgets/upload_image.dart';

class AddEvidence extends ConsumerStatefulWidget {
  static const route = '/add-evidence';
  const AddEvidence({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddEvidenceState();
}

class _AddEvidenceState extends ConsumerState<AddEvidence> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Evidence",
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              "Add Evidence to support your dispute",
              textAlign: TextAlign.start,
              style: wayaTheme.textTheme.descriptionStyle,
            ),
            const Gap(25),
            const Gap(15),
            AboutProduct(
                title: 'Reason for Dispute', content: 'Item not as described'),
            const Gap(15),
            AboutProduct(
                title: 'Dispute Description',
                content:
                    'I recently purchased Dr Teal’s Ultra Moisturizing Body Wash, expecting a luxurious experience based on the product description. However, upon using it, I found that it did not deliver the hydration and revitalization promised. The scent was less citrusy than advertised, and I did not notice any uplifting effects on my mood. Additionally, the texture felt different from what I anticipated, lacking the creamy consistency that was highlighted. Overall, this product did not meet my expectations based on its description.'),
            const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AboutProduct(
                      title: 'Date Submitted', content: 'Aug 11, 12:35PM'),
                ),
                Expanded(
                  child: AboutProduct(title: 'Status', content: 'pending'),
                )
              ],
            ),
            const Gap(30),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: wayaTheme.colorScheme.greyColor200,
                    thickness: 1,
                  ),
                ),
                Gap(10),
                Text(
                  "Upload Evidence",
                  style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                    color: wayaTheme.colorScheme.greyColor600,
                  ),
                ),
                Gap(10),
                Expanded(
                  child: Divider(
                    color: wayaTheme.colorScheme.greyColor200,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            const Gap(30),
            UploadImage(onUpload: () {}),
            const Gap(30),
            WayaButton(callback: () {}, text: "Submit Evidence"),
          ],
        ));
  }
}
