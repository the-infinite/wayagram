import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/general_settings/profile/data/model/profile_edit_type_model.dart';
import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';

mixin ProfileMixin {
  ProfileEditOperationModel getEditOperation({
    required ProfileEditType editType,
    required WidgetRef ref,
    required String value,
  }) {
    switch (editType) {
      case ProfileEditType.dob:
        return ProfileEditOperationModel(
            hintText: 'Aug 10 2021', title: 'Edit Date of Birth', label: 'Date of Birth', onSave: () async {});

    case ProfileEditType.email:
        return ProfileEditOperationModel(
            hintText: 'user@example.com', title: 'Edit Email', label: 'Email', onSave: () async {});
             case ProfileEditType.phone:
        return ProfileEditOperationModel(
            hintText: '7136789012', title: 'Edit Phone', label: 'Phone Number', onSave: () async {});

      case ProfileEditType.bio:
        return ProfileEditOperationModel(
            hintText:
                '🌟 Passionate traveler | Coffee enthusiast ☕ | Tech geek 💻 | Sharing my adventures and insights on life! 🌍✨',
            title: 'Edit Bio',
            label: 'Bio',
            onSave: () {
              ref.read(profileVmProvider.notifier).updateProfile(bio: value);
            });

      case ProfileEditType.location:
        return ProfileEditOperationModel(
            hintText: 'Lagos, Nigeria',
            title: 'Edit Location',
            label: 'Location',
            onSave: () {
              ref.read(profileVmProvider.notifier).updateAccount(address: value);
            });
      case ProfileEditType.name:
        return ProfileEditOperationModel(
            description: 'your name can only be changed once every 7 days',
            hintText: 'Rufai Maleek',
            title: 'Edit Name',
            label: 'Name',
            onSave: () {
              ref.read(profileVmProvider.notifier).updateProfile(displayName: value);
            });

      case ProfileEditType.username:
        return ProfileEditOperationModel(
            description:
                "Usernames can contain only letters, numbers, underscores, and periods. Changing your username will also change your profile link.\n\nYou can change your username once every 30 days.",
            hintText: '@Maleek2024',
            title: 'Edit Username',
            label: 'Username',
            onSave: () {
              ref.read(profileVmProvider.notifier).updateProfile(username: value);
            });
    }
  }
}
