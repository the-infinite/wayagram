enum ServiceType {
  product,
  events,
  ugt,
  chats,
  posts
}

class EngagementData {
  int timeSpent;
  int pointsEarned;
  final Map<String, int> productCategories;
  final Map<String, int> eventLocationType;
  final Map<String, int> eventType;
  final Map<String, int> postHashTags;
  final Map<String, int> postCategory;

  EngagementData(
      {this.timeSpent = 0,
      this.pointsEarned = 0,
      Map<String, int>? productCategories,
      Map<String, int>? eventType,
      Map<String, int>? postHashTags,
      Map<String, int>? postCategory,
      Map<String, int>? eventLocationType})
      : productCategories = productCategories ?? {},
        eventType = eventType ?? {},
        postHashTags = postHashTags ?? {},
        postCategory = postCategory ?? {},
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

   void addHashtag(String loc, int points) {
    postHashTags[loc] = (postHashTags[loc] ?? 0) + points;
    addPoints(points);
  }

  void addPostCategory(String cat, int points) {
    postCategory[cat] = (postCategory[cat] ?? 0) + points;
    addPoints(points);
  }

  // summations
    Map<String, int> getAllPosttags() => postHashTags;
  Map<String, int> getAllPostCategories() => postCategory;
  Map<String, int> getAllEventLocation() => eventLocationType;
  Map<String, int> getAllEventTypee() => eventType;
  Map<String, int> getAllProductCategories() => productCategories;
}
