import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/quotation/widgets/single_shop_widget.dart';

class ManageShopQuotation extends ConsumerWidget {
  const ManageShopQuotation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final viewModel = ref.watch(manageShopVmProvider);
    final wayaTheme = Theme.of(context);

    //? The widget itself.
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Manage Shop",
          style: wayaTheme.textTheme.titleLarge,
        ),

        // Some space.
        const Gap(3),

        //? This is the text that tells the user what to do.
        Text(
          'Manage your shop activities here',
          style: wayaTheme.textTheme.hintStyle,
        ),

        // Some space.
        const Gap(30),

        Text(
          "My Shop",
          style: TextStyle().wayaCopyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: wayaTheme.colorScheme.customBlack,
          ),
        ),

        // Some space.
        const Gap(10),

        //? This is the list of shops that the user has.
        ListView.builder(
          itemCount: 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return SingleShopWidget(
              isSeller: true,
              onTap: () {
                popUpMenu(context);
              },
            );
          },
        ),

        // Some space.
        const Gap(30),

        //? This is the list of shops that the user has shared.
        Text(
          "Shared Shop",
          style: TextStyle().wayaCopyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: wayaTheme.colorScheme.customBlack,
          ),
        ),

        // Some space.
        const Gap(10),

        //? This is the list of shops that the user has shared.
        ListView.builder(
          itemCount: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return SingleShopWidget(
              isSeller: true,
              onTap: () => popUpMenu(context),
            );
          },
        )
      ],
    );
  }

  Future<void> popUpMenu(BuildContext context) async {
    await showMenu(
      context: context,
      elevation: 4,
      color: Colors.red,
      surfaceTintColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      position: const RelativeRect.fromLTRB(100, 0, 0, 100),
      items: [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              SvgPicture.asset('assets/extras/report.svg'),
              const Gap(10),
              Text(
                "Shop Dashboard",
                style: TextStyle().wayaCopyWith(
                  //color: wayaTheme.colorScheme.customBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              SvgPicture.asset('assets/extras/settings.svg'),
              const Gap(10),
              Text(
                "Quotation Dashboard",
                style: TextStyle().wayaCopyWith(
                  //color: wayaTheme.colorScheme.customBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {});
  }
}
