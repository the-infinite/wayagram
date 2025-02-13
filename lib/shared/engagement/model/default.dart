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
  final Map<String, int> eventLocationType;
  final Map<String, int> eventType;

  EngagementData(
      {this.timeSpent = 0,
      this.pointsEarned = 0,
      Map<String, int>? productCategories,
      Map<String, int>? eventType,
      Map<String, int>? eventLocationType})
      : productCategories = productCategories ?? {},
        eventType = eventType ?? {},
        eventLocationType = eventLocationType ?? {};

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

  void addEventLocation(String loc, int points) {
    eventLocationType[loc] = (eventLocationType[loc] ?? 0) + points;
    addPoints(points);
  }

  void addEventType(String type, int points) {
    eventType[type] = (eventType[type] ?? 0) + points;
    addPoints(points);
  }
Map<String, int> getAllEventLocation() => eventLocationType;
Map<String, int> getAllEventTypee() => eventType;
  Map<String, int> getAllProductCategories() => productCategories;
}
