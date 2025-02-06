enum ServiceType {
  product,
  events,
  ugt,
  polls,
  chats,
}

class EngagementData {
  int timeSpent;
  int pointsEarned;
  final Map<String, int> productCategories;


  EngagementData({
    this.timeSpent = 0,
    this.pointsEarned = 0,
    Map<String, int>? productCategories,
  }) : productCategories = productCategories ?? {};

  void addTime(int seconds) {
    timeSpent += seconds;
  }

  void addPoints(int points) {
    pointsEarned += points;
  }

  void addProductCategory(String category, int points) {
    productCategories[category] = (productCategories[category] ?? 0) + points;
    addPoints(points);
  }


  Map<String, int> getAllProductCategories() => productCategories;

}
