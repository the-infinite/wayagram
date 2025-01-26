class Product {
  final List<String> images;
  final String name;
  final String category;
  final int price;
  final int discountPrice;
  final String seller;
  final int quantity;
  final String id;

  Product(
      {required this.category,
      required this.name,
      required this.images,
      required this.discountPrice,
      required this.seller,
      required this.id,
      required this.quantity,
      required this.price});
}

class Category {
  final int id;
  final String category;

  Category({required this.id, required this.category});
}



class Review {
  final String id;
  final String comments;
  final String customerName;
  final String customerImage;
  final int rating;

  Review(
      {required this.comments,
      required this.rating,
      required this.customerImage,
      required this.customerName,
      required this.id});
}

// class Order {
//   final String id;
//   final String status;
//   final String price;
//   final String createdDate;

//   Order(
//       {required this.createdDate,
//       required this.id,
//       required this.price,
//       required this.status});
// }

List<Category> categories = [
  Category(id: 1, category: 'All Categories'),
  Category(id: 2, category: 'Fashion'),
  Category(id: 3, category: 'Gaming'),
  Category(id: 4, category: 'Gadgets'),
  Category(id: 5, category: 'Electronics'),
  Category(id: 6, category: 'Jwelleries'),
  Category(id: 7, category: 'Food'),
];

List<Review> reviews = [
  Review(
      comments:
          "I've been using this moisturizer for a month, and I can already see a difference in my skin! It's so hydrating without being greasy. My dry patches are gone, and my skin feels so soft. Highly recommend!",
      customerImage: 'assets/images/avatars.png',
      customerName: 'Adebayo Faleti',
      rating: 3,
      id: '3r23f2f3q2f3'),
  Review(
      comments:
          "I've been using this moisturizer for a month, and I can already see a difference in my skin! It's so hydrating without being greasy. My dry patches are gone, and my skin feels so soft. Highly recommend!",
      customerImage: 'assets/images/avatars.png',
      customerName: 'Adebayo Faleti',
      rating: 2,
      id: '3r23f2f3q2f3'),
  Review(
      comments:
          "I've been using this moisturizer for a month, and I can already see a difference in my skin! It's so hydrating without being greasy. My dry patches are gone, and my skin feels so soft. Highly recommend!",
      customerImage: 'assets/images/avatars.png',
      customerName: 'Adebayo Faleti',
      rating: 4,
      id: '3r23f2f3q2f3'),
];
