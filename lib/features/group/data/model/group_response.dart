class GroupResponse {
  final String id;
  final String name;
  final String description;
  final String coverImage;
  final String profileImage;

  GroupResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.coverImage,
    required this.profileImage,
  });

  factory GroupResponse.fromJson(Map<String, dynamic> json) {
    return GroupResponse(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      coverImage: json['coverImage'],
      profileImage: json['profileImage'],
    );
  }
}
