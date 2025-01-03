class ProfileState {
  bool isLoading;
  dynamic data;

  // Constructor
  ProfileState({this.isLoading = false, this.data});

  // From JSON
  factory ProfileState.fromJson(Map<String, dynamic> json) {
    return ProfileState(
      isLoading: json['isLoading'] ?? false,
      data: json['data'], // data can be any type
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'isLoading': isLoading,
      'data': data,
    };
  }

  // CopyWith method
  ProfileState copyWith({bool? isLoading, dynamic data}) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
    );
  }
}
