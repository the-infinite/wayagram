import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/chat.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier(super.state);

  Future<List<MessageModel>> getMessages([bool restart = false]) async {
    final result = <MessageModel>[];

    //? If we are not starting from the top, add what needs to be added.
    if (!restart) result.addAll(state.messages);

    // TODO: Do not forget to reverse this contents of the array of chats that
    // todo| would be retrieved over network.

    // Now, use the values you have retrieved to update state.
    state = state.copyWith(
      messages: result,
      cursor: result.lastOrNull?.id,
    );

    // Next, we set the rest.
    return result;
  }

  void setChat(String chat) {}
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ChatState.initial);
});
