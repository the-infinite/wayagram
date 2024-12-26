import 'package:wayagram/features/shop/vm/shop_vm.dart';

class Cart<T extends Product> {
  T product;
  final int count;

  Cart({required this.count, required this.product});
}

  final List<Cart> cart = [
    Cart(count: 2, product: Product(
        category: 'TECHNOLOGY',
        name: 'Jikuke Flash Drive 28GB',
        images: [
          'assets/images/explore/product1.png',
          'assets/images/explore/product2.png',
        ],
        price: 'N 200,032',
        discountPrice: 'N 20,000'),),
   Cart(count: 3, product:  Product(
        category: 'TECHNOLOGY',
        name: 'Jikuke Flash Drive 28GB',
        images: [
          'assets/images/explore/product2.png',
          'assets/images/explore/product1.png',
        ],
        price: 'N 200,032',
        discountPrice: 'N 20,000'),),
           Cart(count: 1, product:  Product(
        category: 'TECHNOLOGY',
        name: 'Jikuke Flash Drive 28GB',
        images: [
          'assets/images/explore/product2.png',
          'assets/images/explore/product1.png',
        ],
        price: 'N 20,032',
        discountPrice: 'N 20,000'),)
  ];