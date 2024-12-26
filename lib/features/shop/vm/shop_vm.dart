class Product {
  final List<String> images;
  final String name;
  final String category;
  final String price;
  final String discountPrice;

  Product(
      {required this.category,
      required this.name,
      required this.images,
      required this.discountPrice,
      required this.price});
}

  final List<Product> products = [
    Product(
        category: 'TECHNOLOGY',
        name: 'Jikuke Flash Drive 28GB',
        images: [
          'assets/images/explore/product1.png',
          'assets/images/explore/product2.png',
        ],
        price: 'N 200,032',
        discountPrice: 'N 20,000'),
    Product(
        category: 'TECHNOLOGY',
        name: 'Jikuke Flash Drive 28GB',
        images: [
          'assets/images/explore/product2.png',
          'assets/images/explore/product1.png',
        ],
        price: 'N 200,032',
        discountPrice: 'N 20,000'),
  ];