// Manually Serialized Response Model for Flutter

class InterestsResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final List<InterestCategory> data;

  InterestsResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory InterestsResponseModel.fromJson(Map<String, dynamic> json) {
    return InterestsResponseModel(
        message: json['message'],
        status: json['status'],
        statusCode: json['statusCode'],
        data: (json['data'] as List)
            .map((item) => InterestCategory.fromJson(item))
            .toList());
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'status': status,
        'statusCode': statusCode,
        'data': data.map((item) => item.toJson()).toList(),
      };
}

// Model for the Data Item
class InterestCategory {
  final String id;
  final String name;
  final String? parentId;
  final String category;
  final int score;
  final DateTime createdAt;
  final DateTime updatedAt;

  InterestCategory({
    required this.id,
    required this.name,
    this.parentId,
    required this.category,
    required this.score,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InterestCategory.fromJson(Map<String, dynamic> json) =>
      InterestCategory(
        id: json['id'],
        name: json['name'],
        parentId: json['parentId'],
        category: json['category'],
        score: json['score'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'parentId': parentId,
        'category': category,
        'score': score,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class RestructuredCategory {
  final String category;
  final String? id;
  final List<InterestCategory> subcategory;

  RestructuredCategory({
    required this.category,
    this.id,
    required this.subcategory,
  });

  Map<String, dynamic> toJson() => {
        'category': category,
        'id': id,
        'subcategory': subcategory.map((e) => e.toJson()).toList(),
      };
}

List<RestructuredCategory> restructureCategoriesRefined(
    List<InterestCategory> categories) {
  final Map<String, List<InterestCategory>> categorized = {"Others": []};

  for (var category in categories) {
    if (category.parentId == null) {
      categorized["Others"]!.add(category);
    } else {
      categorized.putIfAbsent(category.parentId!, () => []);
      categorized[category.parentId!]!.add(category);
    }
  }

  return categorized.entries.map((entry) {
    return RestructuredCategory(
      category: entry.key == "Others"
          ? "Others"
          : categories.firstWhere((cat) => cat.id == entry.key).category,
      id: entry.key == "Others" ? null : entry.key,
      subcategory: entry.value,
    );
  }).toList();
}
