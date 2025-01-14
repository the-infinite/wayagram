import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/quotation/widgets/single_shop_widget.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/widgets/inventory_widget.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/widgets/quick_action_widget.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';
import 'package:wayagram/features/shop/widgets/single_order_widget.dart';

class ManageShopQuotation extends ConsumerWidget {
  const ManageShopQuotation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final viewModel = ref.watch(manageShopVmProvider);
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Manage Shop", style: wayaTheme.textTheme.titleLarge),
        const Gap(3),
        Text(
          'Manage your shop activities here',
          style: wayaTheme.textTheme.hintStyle,
        ),
        const Gap(30),

        Text("My Shop",
            style: TextStyle().wayaCopyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: wayaTheme.colorScheme.customBlack)),
        const Gap(10),
        ListView.builder(
            itemCount: 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return SingleShopWidget(
                isSeller: true,
                onTap: (){
                  print('TESTING mkn');
                  popUpMenu(context);
                },
              );
            }),

        const Gap(30),

        Text("Shared Shop",
            style: TextStyle().wayaCopyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: wayaTheme.colorScheme.customBlack)),
        const Gap(10),
        ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return SingleShopWidget(
                isSeller: true,
                onTap: () => popUpMenu(context),
              );
            })
      ],
    );
  }

  Future<void> popUpMenu(BuildContext context)  async{
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
          //onTap: () => MainClass.open(context, const SavingsReport()),
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
          //onTap: () => MainClass.open(context, const SavingsSettings()),
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
    ).then((value){

    });
  }
}
