class SpecialProfileModel {
  final String id;
  final String name;
  final int vote;
  final String bio;
  final String details;
  final String profileImage;
  final String videoLink;

  SpecialProfileModel({
    required this.id,
    required this.name,
    required this.vote,
    required this.bio,
    required this.details,
    required this.profileImage,
    required this.videoLink,
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'vote': vote,
      'bio': bio,
      'details': details,
      'profileImage': profileImage,
      'videoLink': videoLink,
    };
  }

  // Create object from JSON
  factory SpecialProfileModel.fromJson(Map<String, dynamic> json) {
    return SpecialProfileModel(
      id: json['id'],
      name: json['name'],
      vote: json['vote'],
      bio: json['bio'],
      details: json['details'],
      profileImage: json['profileImage'],
      videoLink: json['videoLink'],
    );
  }
}
