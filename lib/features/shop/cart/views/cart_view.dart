import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/cart/vm/cart_vm.dart';
import 'package:wayagram/features/shop/cart/widgets/cart_card.dart';
import 'package:gap/gap.dart';

class CartView extends ConsumerStatefulWidget {
  static const route = '/cart';
  const CartView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartViewState();
}

class _CartViewState extends ConsumerState<CartView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(cartVmProvider.notifier).loadCart();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final restructuredCart = ref.watch(cartVmProvider);

    if (restructuredCart.isLoading) {
      return buildSellerShopSkeleton(context: context);
    }
    if (restructuredCart.cart == null) {
      return EmptyState();
    }
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        onRefresh: () => ref.read(cartVmProvider.notifier).loadCart(),
        title: "Cart",
        body: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: restructuredCart.cart == null
                ? 0
                : restructuredCart.cart!.items.length,
            itemBuilder: (context, index) {
              return CartCard(cartItem: restructuredCart.cart!.items[index]);
            }));
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Gap(40),
        SvgPicture.asset('assets/icons/empty-state.svg'),
        const Gap(30),
        Text(
          "No Item in the Cart",
          textAlign: TextAlign.center,
          style: wayaTheme.textTheme.titleLarge,
        ),
        const Gap(25),
        const Gap(25),
        WayaButton(
          callback: () {
            WayaNav.goBack();
          },
          centerWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/button-icon.svg'),
              const Gap(6),
              Text(
                "Start Shopping",
                style: TextStyle().wayaCopyWith(
                    color: wayaTheme.colorScheme.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        )
      ],
    );
  }
}

Widget buildSellerShopSkeleton({required BuildContext context}) {
  final wayaTheme = Theme.of(context);
  return Container(
    height: 300,
    width: double.infinity,
    decoration: BoxDecoration(
        color: wayaTheme.colorScheme.scaffoldColor,
        borderRadius: BorderRadius.circular(12)),
  );
}
