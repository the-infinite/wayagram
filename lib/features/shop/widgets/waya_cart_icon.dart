import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/utils/routes.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/cart/vm/cart_vm.dart';

class WayaCartIcon extends ConsumerWidget {
  const WayaCartIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

    final cartItemCount = ref.watch(cartVmProvider).totalItem ?? 0;
    return GestureDetector(
      onTap: () {
        WayaNav.toNamed(CartView.route);
      },
      child: Row(
        children: [
          Container(
            height: 35,
            padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.customPrimary,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(WayaAssets.icons.shopcarticon.path),
                  const Gap(5),
                  Text(
                    "$cartItemCount",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  )
                ],
              ),
            ),
          ),
          const Gap(15)
        ],
      ),
    );
  }
}
