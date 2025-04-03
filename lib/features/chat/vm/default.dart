import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/member.dart';
import 'package:wayagram/features/chat/repo/default.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

class ConversationVm extends StateNotifier<ConversationState> {
  final repo = ChatRepository();
  OverlayEntry? _entry;
  ConversationVm(super.state);

  /// A utility used to keep track of the current overlay showing on the
  /// conversation screen.
  void setOverlay(OverlayEntry entry) {
    try {
      _entry?.remove();
    } catch (_) {}
    _entry = entry;
  }

  /// A utility function used to close focus on the current overlay.
  void dismissOverlay() {
    try {
      _entry?.remove();
      _entry?.dispose();
    } catch (_) {}
  }

  /// Helper function used to set the filter text.
  void setFilter(String filter) {
    state = state.copyWith(searchFilter: filter.trim());
  }

  /// Enter archived chats activity.
  void setArchived(bool value) {
    state = state.copyWith(inArchived: value);
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
        hasLoaded: true,
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
  Future<ChatModel?> startChat(
    ChatType type,
    List<String> users, [
    String? name,
    String? description,
  ]) async {
    //? This is fine.
    final response = await repo.startConversation(type, users, name, description);

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
        final previous = chats[pos];

        //? Fix the bug where the latest message is not always guaranteed to be
        //? showing up here.
        chats[pos] = result.copyWith(
          lastMessage: result.lastMessage ?? previous.lastMessage,
          latestMessageId: result.latestMessageId ?? previous.latestMessageId,
        );

        //? Then update this.
        state = state.copyWith(conversations: chats);
      }

      //* Return this as the case may be.
      return result;
    }

    //? Return this collated result.
    return null;
  }

  /// Helper function used to retrieve the list of all users blocked by the
  /// current user.
  Future<List<ChatUser>> getBlockedUsers() async {
    final result = <ChatUser>[];

    //? First, we try to get blocked users.
    try {
      final response = await repo.getBlockedUsers();

      //? This is fine.
      if (response.success) {
        //? The data.
        final data = (response.data['data'] as List);
        result.addAll(data.map((user) => ChatUser.fromJson(user)));

        //? Update state.
        state = state.copyWith(
          blocked: result,
          isLoading: false,
        );
      }

      //? Since it failed.
      else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.chats,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //* Return the result.
    return result;
  }

  /// Helper function used to block or unblock a user as the case may be.
  Future<bool> blockOrUnblockUser(String id) async {
    final response = await repo.blockOrUnblockUser(id);

    //? This is fine.
    if (response.success) await getBlockedUsers();

    //? Return whether or not this is true.
    return response.success;
  }

  /// Helper function used to archive or unarchive a chat as the case may be.
  Future<bool> archiveOrUnarchiveChat(String id) async {
    //? This is fine.
    final response = await repo.archiveOrUnarchiveChat(id);

    //? If this went well.
    if (response.success) {
      getChats(true);
      getArchivedChats(true);
    }

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
      state = state.copyWith(conversations: [...chats]);
    }

    //? Return whether or not this is true.
    return response.success;
  }

  /// Helper function used to report a user.
  Future<bool> reportUser(String id) async {
    await WayaNavigationHelper.showComingSoonModal(true);
    return false;
  }

  /// Helper function used to mute/unmute a user.
  Future<bool> muteOrUnmuteUser(String id) async {
    await WayaNavigationHelper.showComingSoonModal(true);
    return false;
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
        archived: result,
        hasLoadedArchived: true,
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
