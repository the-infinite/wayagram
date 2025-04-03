import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/group.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class CreateConversationGroupNotifier extends StateNotifier<CreateConversationGroupState> {
  CreateConversationGroupNotifier() : super(CreateConversationGroupState.initial);

  void saveUsers(List<UserDetailsModel> users) {
    state = state.copyWith(members: users);
  }

  void saveData(String name, String description) {
    state = state.copyWith(
      name: name,
      description: description,
    );
  }

  void selectImage() async {
    final profileImage = await WayaUtils.pickAndCropImage();

    //? Leave if nothing was chosen.
    if (profileImage == null) return;

    //? Select this one.
    state = state.copyWith(image: profileImage);
  }

  void reset() {
    state = CreateConversationGroupState.initial;
  }
}

final createChatGroupProvider = StateNotifierProvider<CreateConversationGroupNotifier, CreateConversationGroupState>(
  (ref) => CreateConversationGroupNotifier(),
);
