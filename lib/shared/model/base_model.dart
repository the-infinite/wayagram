abstract class BaseModel<T> {
  Map<String, dynamic> toMap();
}

class FilterCategoryModel {
  final String id;
  final String name;

  const FilterCategoryModel({required this.id, required this.name});
}

class BaseFilterModel {
  final bool? isPromoted;
  final String? search;
  final List<FilterCategoryModel>? categories;
  final DateTime? timeStart;
  final DateTime? timeEnd;
  final int? activityStart;
  final int? activityEnd;
  final double? priceStart;
  final double? priceEnd;

  // Construct.
  BaseFilterModel({
    required this.isPromoted,
    required this.categories,
    required this.timeStart,
    required this.timeEnd,
    required this.activityStart,
    required this.activityEnd,
    required this.priceStart,
    required this.priceEnd,
    required this.search,
  });
}
