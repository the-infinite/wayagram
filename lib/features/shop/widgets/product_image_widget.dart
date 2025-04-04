import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shop/widgets/widgets_vm/product_image_widget_vm.dart';

class ProductImageWidget extends ConsumerWidget {
  final List<String> images;
  const ProductImageWidget({super.key, required this.images});
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(productImageWidgetVmProvider.notifier);
    final currPage = ref.watch(productImageWidgetVmProvider).currentPage;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.white,
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: wayaTheme.colorScheme.greyColor300, width: 1),
          ),
          child: PageView.builder(
              controller: viewModel.pageController,
              itemCount: images.length,
              onPageChanged: (value) => viewModel.changePage(value),
              itemBuilder: (context, index) {
                return WayaImage(
                  imageUrl: images[index],
                  height: 280,
                  fit: BoxFit.contain,
                );
              }),
        ),
        const Gap(6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          const Gap(2),
            WayaCustomIndicator(
              currentPage: currPage,
              pageCount: images.length,
              width: 30,
              height: 6,
              currentWidth: 30,
            ),
            Container(
              width: 40,
              padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
              decoration: BoxDecoration(
                  color: wayaTheme.colorScheme.primary50,
                  borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: Text("${currPage + 1}/${images.length}",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.customPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp)),
              ),
            ),
          ],
        ),
        const Gap(4),
      ],
    );
  }
}
