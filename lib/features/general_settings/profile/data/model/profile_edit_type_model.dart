import 'dart:ui';

class ProfileEditOperationModel {
  String title;
  String hintText;
  String label;
  String? description;
  VoidCallback? onSave;

  ProfileEditOperationModel(
      {required this.title, required this.label, required this.hintText, this.description, this.onSave});
}

enum ProfileEditType { name, bio, username, location, dob }
