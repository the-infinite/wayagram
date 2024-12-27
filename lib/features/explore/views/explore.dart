import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/explore/vm/explore_vm.dart';
import 'package:wayagram/features/explore/widgets/explore_header.dart';
import 'package:wayagram/features/explore/widgets/explore_our_services.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/quotation/widgets/quotation_card.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';
import 'package:wayagram/features/ugt/widgets/ugt_card.dart';

class Explore extends ConsumerWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(exploreVmProvider.notifier);
 
    return WayaScaffold(
        isLoading: false,
        color: wayaTheme.colorScheme.scaffoldColor,
        appBar: AppBar(
          backgroundColor: wayaTheme.colorScheme.white,
          title: ExploreHeader() ,
          actions: [Container(
            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {},
              child: Icon(Icons.notifications,
                  size: 30, color: wayaTheme.colorScheme.greyColor500),
            ),
            const Gap(15),
            Image.asset('assets/images/avatars.png'),
          ],
        ),
          )],
          leading:        Container(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child:  Image.asset('assets/images/wayalogo_unlabelled.png', ),
          )
        ),
        isScrollable: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const ExploreHeader(),
             const Gap(20),
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
            const Gap(10),
           CategoriesFilterWidget<Product>(allItems: []),
            const Gap(25),
            GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: products[index]);
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
