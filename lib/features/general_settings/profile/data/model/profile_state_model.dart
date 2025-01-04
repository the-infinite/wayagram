import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_profile_model.dart';

class ProfileState {
  bool isLoading;
  dynamic data;
  UserAccountModel? userAccountModel;
  UserProfileModel? userProfileModel;

  // Constructor
  ProfileState({this.isLoading = false, this.data, this.userAccountModel, this.userProfileModel});

  // From JSON
  factory ProfileState.fromJson(Map<String, dynamic> json) {
    return ProfileState(
      isLoading: json['isLoading'] ?? false,
      data: json['data'], // data can be any type
      userAccountModel: json['userAccountModel'] != null ? UserAccountModel.fromJson(json['userAccountModel']) : null,
      userProfileModel: json['userProfileModel'] != null ? UserProfileModel.fromJson(json['userProfileModel']) : null,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'isLoading': isLoading,
      'data': data,
      'userAccountModel': userAccountModel?.toJson(),
      'userProfileModel': userProfileModel?.toJson(),
    };
  }

  // CopyWith method
  ProfileState copyWith({
    bool? isLoading,
    dynamic data,
    UserAccountModel? userAccountModel,
    UserProfileModel? userProfileModel,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      userAccountModel: userAccountModel ?? this.userAccountModel,
      userProfileModel: userProfileModel ?? this.userProfileModel,
    );
  }
}
