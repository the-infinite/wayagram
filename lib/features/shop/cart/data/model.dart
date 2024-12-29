import 'package:wayagram/features/shop/data/model/model.dart';

class Cart {
  final List<String> images;
  final String name;
  final String category;
  final int price;
  final int discountPrice;
  final String seller;
  final int count;
  final int quantity;
  final String id;

  Cart(
      {required this.category,
      required this.discountPrice,
      required this.images,
      required this.name,
      required this.price,
      required this.id,
      required this.count,
      required this.quantity,
      required this.seller});

  Cart copyWith(int count, int quantity) {
    return Cart(
      id: id,
      name: name,
      price: price,
      discountPrice: discountPrice,
      category: category,
      seller: seller,
      images: images,
      quantity: quantity,
      count: count,
    );
  }

  factory Cart.fromProduct(Product product, int count) {
    return Cart(
      id: product.id,
      name: product.name,
      price: product.price,
      discountPrice: product.discountPrice,
      category: product.category,
      seller: product.seller,
      images: product.images,
      quantity: product.quantity - count,
      count: count,
    );
  }
}

class RestructuredCart {
  final String seller;
  final List<Cart> cart;

  RestructuredCart({required this.cart, required this.seller});
}

List<RestructuredCart> restructureCartBySeller(List<Cart> cart) {
  // Group by seller
  final Map<String, List<Cart>> groupedBySeller = {};

  for (final item in cart) {
    if (!groupedBySeller.containsKey(item.seller)) {
      groupedBySeller[item.seller] = [];
    }
    groupedBySeller[item.seller]!.add(item);
  }

  return groupedBySeller.entries
      .map((entry) => RestructuredCart(
            seller: entry.key,
            cart: entry.value,
          ))
      .toList();
}
