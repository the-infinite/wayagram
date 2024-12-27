import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/shop/data_model/data_model.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/widgets/single_order_widget.dart';


  final List<Product> orders = [
    Product(
        category: 'TECHNOLOGY',
        name: 'Jikuke Flash Drive 28GB',
        images: [
          'assets/images/explore/product1.png',
          'assets/images/explore/product2.png',
        ],
        price: 'N 200,032',
        discountPrice: 'N 20,000', seller: "Maleek"),
Product(
        category: 'TECHNOLOGY',
        name: 'Jikuke Flash Drive 28GB',
        images: [
          'assets/images/explore/product2.png',
          'assets/images/explore/product1.png',
        ],
        price: 'N 200,032',
        discountPrice: 'N 20,000',  seller: "Maleek"),
          Product(
        category: 'TECHNOLOGY',
        name: 'Jikuke Flash Drive 28GB',
        images: [
          'assets/images/explore/product2.png',
          'assets/images/explore/product1.png',
        ],
        price: 'N 20,032',
        discountPrice: 'N 20,000',  seller: "Maleek"),
  ];

class AllOrders extends ConsumerWidget {
  const AllOrders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GroupedWidgetHeader(
            onTap: () {},
            subTitle: 'View and manage your orders',
            title: 'Orders'),
        const Gap(25),
        FilterWidget<Order>(allItems: []),
        const Gap(25),
       ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return SingleOrderWidget();
                })
      ],
    );
  }
}
