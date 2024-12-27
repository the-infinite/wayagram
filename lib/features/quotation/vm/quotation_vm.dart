class Quotation {
  final String name;
  final String description;
  final String category;
  final String timeLeft;
  final bool isActive;
  final List<String> images;

  Quotation(
      {required this.category,
      required this.images,
      required this.description,
      required this.name,
      required this.isActive,
      required this.timeLeft});
}
