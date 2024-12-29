import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/shop/data/model/model.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/widgets/single_order_widget.dart';


  final List<Product> orders = [
   Product(
    id: "1",
      category: 'TECHNOLOGY',
      name: 'Jikuke Flash Drive 28GB',
      images: [
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374175/product1_owvv1d.png',
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374122/Frame_1984078250_timcfp.png',
      ],
      price: 20000,
      discountPrice: 19000,
       quantity: 5,
      seller: "Maleek"),
  Product(
    id: "2",
      category: 'TECHNOLOGY',
      name: 'Jikuke Flash Drive 28GB',
      images: [
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374172/product2_na4de1.png',
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374117/Frame_1984078250_khms9k.png',
      ],
       price: 20000,
      discountPrice: 19000,
       quantity: 3,
      seller: "Emeka"),
  Product(
    id: "3",
      category: 'TECHNOLOGY',
      name: 'Jikuke Flash Drive 28GB',
      images: [
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374117/Frame_1984078250_khms9k.png',
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374172/product2_na4de1.png',
      ],
   price: 20000,
      discountPrice: 19000,
      quantity: 3,
      seller: "Maleek"),
  Product(
    id: "4",
      category: 'TECHNOLOGY',
      name: 'Jikuke Flash Drive 28GB',
      images: [
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374122/Frame_1984078250_timcfp.png',
        'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374117/Frame_1984078250_khms9k.png',
      ],
       price: 20000,
      discountPrice: 19000,
       quantity: 3,
      seller: "Emeka"),
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
