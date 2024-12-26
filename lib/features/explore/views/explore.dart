import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/features/auth/interests/data/interest_data.dart';
import 'package:wayagram/features/explore/vm/explore_vm.dart';
import 'package:wayagram/features/explore/widgets/explore_header.dart';
import 'package:wayagram/features/explore/widgets/explore_our_services.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/quotation/widgets/quotation_card.dart';
import 'package:wayagram/features/shop/widget/product_card.dart';
import 'package:wayagram/features/ugt/widgets/ugt_card.dart';

class Explore extends ConsumerWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(exploreVmProvider.notifier);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return WayaScaffold(
        isLoading: false,
        appBar: AppBar(),
        isScrollable: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ExploreHeader(),
            const Gap(25),
            const ExploreOurServices(),
            const Gap(25),
            GroupedWidgetHeader(
                onTap: () {},
                subTitle: 'Have a buy request, just create a quote',
                title: 'Get Quotation'),
            const Gap(20),
            WayaButton(
              centerWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    size: 28,
                    color: wayaTheme.colorScheme.primary600,
                  ),
                  const Gap(8),
                  Text(
                    "Create a Quote",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.customPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ],
              ),
              callback: () {},
              color: wayaTheme.colorScheme.primar50,
            ),
            const Gap(25),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.quotations.length,
                itemBuilder: (context, index) {
                  return QuotationCard(quotation: viewModel.quotations[index]);
                }),
            const Gap(25),
            GroupedWidgetHeader(
                onTap: () {},
                subTitle: 'Explore Categories & Best Offers',
                title: 'Shop'),
            const Gap(25),
            SizedBox(
              height: 45,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: trendingData.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        const Gap(6),
                        WayaButton(
                          callback: () {
                            viewModel
                                .updateSelectedCategory(trendingData[index]);
                          },
                          border: Border.all(
                              color:
                                  selectedCategory.contains(trendingData[index])
                                      ? wayaTheme.colorScheme.customPrimary
                                      : wayaTheme.colorScheme.greyColor300),
                          horizontalPadding: 8,
                          color: selectedCategory.contains(trendingData[index])
                              ? wayaTheme.colorScheme.primaryBrown50
                              : wayaTheme.colorScheme.transparent,
                          radius: 10,
                          height: 45,
                          centerWidget: Text(trendingData[index],
                              style: WayaTextStyles.hintStyle),
                        ),
                        const Gap(6),
                      ],
                    );
                  }),
            ),
            const Gap(25),
            GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1,
                    childAspectRatio: 0.5,
                    crossAxisSpacing: 12),
                itemCount: viewModel.products.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: viewModel.products[index]);
                }),
                    const Gap(25),
                     GroupedWidgetHeader(
                onTap: () {},
                subTitle: 'Join Upcoming Activities',
                title: 'University Got Talent'),
                 const Gap(25),
                     ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.ugtList.length,
                itemBuilder: (context, index) {
                  return UgtCard(ugt: viewModel.ugtList[index]);
                }),

          ],
        ));
  }
}
