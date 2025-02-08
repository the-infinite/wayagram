import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/repo/default.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

class ConversationVm extends StateNotifier<ConversationState> {
  final repo = ChatRepository();
  ConversationVm(super.state);

  /// Helper function used to set the filter text.
  void setFilter(String filter) {
    state = state.copyWith(searchFilter: filter.trim());
  }

  /// Helper function used to get all chats that are currently being transmitted
  /// from the server-side to the current user.
  Future<List<ChatModel>> getChats([bool reset = false]) async {
    final result = <ChatModel>[];

    //? Now, we are loading bro.
    state = state.copyWith(isLoading: true);

    //? This is fine.
    final response = await repo.getAllConversations(state.limit, state.page);

    //? This is fine.
    if (response.success) {
      //? If the previous page had a next page, offload them onto this place.
      if (!reset && state.hasNextPage) {
        result.addAll(state.conversations);
      }

      //? The data.
      final data = response.data['data'];

      //? Parse the conversations as they are in the response object...
      final docs = (data['docs'] as List).map((doc) => ChatModel.fromJson(doc)).toList();

      //? First, we check each of the members in each conversation...
      for (var c = 0; c < docs.length; c++) {
        final conversation = docs[c];

        //? Do the needful.
        for (var i = 0; i < conversation.chatMembers.length; i++) {
          //? Look this bro up.
          final member = conversation.chatMembers[i];

          //? If this is not found...
          final details = member.userId == ConversationState.self.id
              ? (ConversationState.self, ConversationState.profile)
              : await UserResource.getUserDetails(member.userId);

          //? If this is null...
          if (details == null) continue;

          //? The user and his or her profile.
          final user = details.$1;
          final profile = details.$2;

          //? Since we are in the clear...
          conversation.chatMembers[i] = member.copyWith(user, profile);
        }

        //? Then replace what is there.
        docs[c] = conversation;
      }

      //? This is fine.
      result.addAll(docs);

      //? Update state.
      state = state.copyWith(
        conversations: result,
        totalCount: data['totalDocs'],
        totalPages: data['totalPages'],
        hasNextPage: data['hasNextPage'],
        page: int.tryParse(data['nextPage'].toString()) ?? 1,
        isLoading: false,
      );
    }

    //? Since it failed.
    else {
      state = state.copyWith(isLoading: false);
    }

    //? Return this collated result.
    return result;
  }

  /// Helper function used to start a chat with a list of users.
  Future<ChatModel?> startChat(ChatType type, List<String> users) async {
    //? This is fine.
    final response = await repo.startConversation(type, users);

    //? If this was fine...
    if (!response.success) {
      return null;
    }

    //? Try getting all chats.
    getChats();

    //? Now, return this.
    return getChatDetails(response.data['data']['id']);
  }

  /// Helper function used to retrieve all of the details of just one conversation.
  Future<ChatModel?> getChatDetails(String id, [bool replace = true]) async {
    //? This is fine.
    final response = await repo.getConversation(id);

    //? This is fine.
    if (response.success) {
      final result = ChatModel.fromJson(response.data['data']);
      final pos = state.conversations.indexWhere((chat) => chat.id == id);

      //? First, clean up the chat members details.
      for (var i = 0; i < result.chatMembers.length; i++) {
        //? Look this bro up.
        final member = result.chatMembers[i];

        //? If this is not found...
        final details = member.userId == ConversationState.self.id
            ? (ConversationState.self, ConversationState.profile)
            : await UserResource.getUserDetails(member.userId);

        //? If this is null...
        if (details == null) continue;

        //? The user and his or her profile.
        final user = details.$1;
        final profile = details.$2;

        //? Since we are in the clear...
        result.chatMembers[i] = member.copyWith(user, profile);
      }

      //? If this is to replace the chat inside of the list of chats and it is
      //? possible to replace it.
      if (replace && pos != -1) {
        final chats = state.conversations;
        chats[pos] = result;
        state = state.copyWith(conversations: chats);
      }

      //* Return this as the case may be.
      return result;
    }

    //? Return this collated result.
    return null;
  }

  /// Helper function used to block or unblock a user as the case may be.
  Future<bool> blockOrUnblockUser(String id) async {
    final response = await repo.blockOrUnblockUser(id);

    //? Return whether or not this is true.
    return response.success;
  }

  /// Helper function used to archive or unarchive a chat as the case may be.
  Future<bool> archiveOrUnarchiveChat(String id) async {
    //? This is fine.
    final response = await repo.archiveOrUnarchiveChat(id);

    //? If this went well.
    if (response.success) getChatDetails(id);

    //? Return whether or not this is true.
    return response.success;
  }

  /// Helper function used to pin or unpin a chat as the case may be.
  Future<bool> pinOrUnpinChat(String id) async {
    //? This is fine.
    final response = await repo.pinOrUnpinChat(id);

    //? If this went well.
    if (response.success) getChatDetails(id);

    //? Return whether or not this is true.
    return response.success;
  }

  /// Helper function used to delete a given chat.
  Future<bool> deleteChat(String id) async {
    //? This is fine.
    final response = await repo.deleteConversation(id);

    //? If this went well, remove it from the list of chats.
    if (response.success) {
      final chats = state.conversations;
      chats.removeWhere((chat) => chat.id == id);
      state = state.copyWith(conversations: chats);
    }

    //? Return whether or not this is true.
    return response.success;
  }

  /// Helper function used to get the list of all chats that have been archived
  /// by the current user.
  Future<List<ChatModel>> getArchivedChats([bool reset = false]) async {
    final result = <ChatModel>[];

    //? Now, we are loading bro.
    state = state.copyWith(isLoading: true);

    //? This is fine.
    final response = await repo.getArchivedChats(state.limit, state.archivedPage);

    //? This is fine.
    if (response.success) {
      //? If the previous page had a next page, offload them onto this place.
      if (!reset && state.archivedHasNextPage) {
        result.addAll(state.archived);
      }

      //? OUr data.
      final data = response.data['data'];

      //? Parse the conversations as they are in the response object...
      final docs = (data['docs'] as List).map((doc) => ChatModel.fromJson(doc));

      //? This is fine.
      result.addAll(docs);

      //? Update state.
      state = state.copyWith(
        archived: result,
        archivedTotalCount: data['totalDocs'],
        archivedTotalPages: data['totalPages'],
        archivedHasNextPage: data['hasNextPage'],
        archivedPage: int.tryParse(data['nextPage'].toString()) ?? 1,
        isLoading: false,
      );
    }

    //? Since it failed.
    else {
      state = state.copyWith(isLoading: false);
    }

    //? Return this collated result.
    return result;
  }
}

/// The state provider for conversations.
final conversationProvider = StateNotifierProvider<ConversationVm, ConversationState>((ref) {
  return ConversationVm(ConversationState.initial);
});
