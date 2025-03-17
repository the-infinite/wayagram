import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/shop/model/default.dart';
import 'package:wayagram/shared/features/shop/resource/default.dart';

class ChooseShopModal extends StatefulWidget {
  const ChooseShopModal({super.key});

  @override
  State<ChooseShopModal> createState() => _ChooseShopModalState();
}

class _ChooseShopModalState extends State<ChooseShopModal> {
  final shopNotifier = ValueNotifier<String?>(null);
  List<ShopModel> shops = <ShopModel>[];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final result = await ShopResource.getShopsForVendor(ConversationState.self.id);

        //? If this user has only one shop.
        if (result.length == 1) {
          shopNotifier.value = result.first.id;
        }

        //? Then set the state of the entire component, a different way.
        setState(() {
          shops = result;
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    shopNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    debugPrint(shops.toString());

    //? Construct the widget.
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: ValueListenableBuilder(
        valueListenable: shopNotifier,
        builder: (context, selectedShop, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //? Our title.
            Text(
              "Choose shop",
              style: wayaTheme.textTheme.titleLarge,
            ),

            // Some space.
            SizedBox(height: 3.h),

            //? The subtitle.
            Text(
              "Please choose the shop you wish to start bidding as",
              style: wayaTheme.textTheme.bodyMedium!.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: wayaTheme.colorScheme.greyColor500,
              ),
            ),

            // Some more space.
            const Gap(20),

            //? Now, show a drop down featuring the user's shops.
            WayaSelectField<String>(
              height: 0.3,
              label: "Bidding Shop",
              uniqueKey: 'bidding_shop',
              hintText: 'Choose a shop',
              items: shops.map((shop) => Select(label: shop.name, value: shop.id)).toList(),
              value: selectedShop,
              onSelected: (value) {
                shopNotifier.value = value.first.value;
              },
            ),

            // Some more space.
            const Gap(20),

            //? Now, we are fine.
            WayaButton(
              callback: () => WayaNav.goBack(result: selectedShop!),
              isDisabled: selectedShop == null,
              text: 'Confirm',
            )
          ],
        ),
      ),
    );
  }
}
