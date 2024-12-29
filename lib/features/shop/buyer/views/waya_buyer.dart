import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shop/buyer/views/all_orders.dart';
import 'package:wayagram/features/shop/buyer/views/all_products.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';

class WayaBuyer extends ConsumerStatefulWidget {
  const WayaBuyer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WayaBuyerState();
}

class _WayaBuyerState extends ConsumerState<WayaBuyer>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);

    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: 'Shop',
        appBarTrailing: WayaCartIcon(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
              Row(
              children: [
                WayaBuyerTabButton(
                  isSelected: _selectedIndex == 0,
                  text: 'All Products',
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                WayaBuyerTabButton(
                  isSelected: _selectedIndex == 1,
                  text: 'Orders',
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
              ],
            ),
          
            const Gap(25),
            // AllProducts() 
            _selectedIndex == 0 ? AllProducts() : AllOrders()
          ],
        ));
  }
}

class WayaBuyerTabButton extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback onTap;

  const WayaBuyerTabButton({
    super.key,
    required this.isSelected,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.greyColor300,
                width: isSelected ? 2 : 0.9,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.greyColor500,
            ),
          ),
        ),
      ),
    );
  }
}
