import 'dart:io';

import 'package:wayagram/shared/features/user/models/default.dart';

class CreateConversationGroupState {
  final List<UserDetailsModel> members;
  final String name;
  final String description;
  final File? image;

  // This is all.
  const CreateConversationGroupState({
    required this.members,
    required this.name,
    required this.description,
    required this.image,
  });

  //? Our initial value.
  static const initial = CreateConversationGroupState(
    members: [],
    name: '',
    description: '',
    image: null,
  );

  CreateConversationGroupState copyWith({
    List<UserDetailsModel>? members,
    String? name,
    String? description,
    File? image,
  }) {
    return CreateConversationGroupState(
      members: members ?? this.members,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }
}
