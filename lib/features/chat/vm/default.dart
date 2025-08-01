import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:wayagram/core/components/waya_select_field.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/controller/socket.dart';
import 'package:wayagram/features/chat/dto/default.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/member.dart';
import 'package:wayagram/features/chat/repo/default.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/cache/chat.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';
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
      final docs = (data['docs'] as List)
          .map((doc) => ChatModel.fromJson(doc))
          .where((chat) =>
              (chat.latestMessageId != null && chat.chatType != ChatType.group) || chat.chatType == ChatType.group)
          .toList();

      //? First, we check each of the members in each conversation...
      for (var c = 0; c < docs.length; c++) {
        //? Now, it is time to sort the chat members in the order that they should show up on the front-end.
        final members = <ChatMember>[];
        final example = docs[c].self;

        //? First one, is the one where the user is me.
        if (example != null) {
          members.add(example);
        }

        //? Second, add all group admins.
        members.addAll(docs[c].allOthers.where((member) => member.role != ChatMemberRole.member));

        //? Third, add all regular users.
        members.addAll(docs[c].allOthers.where((member) => member.role == ChatMemberRole.member));

        //? Finally, replace the conversation with what we have here.
        final conversation = docs[c].copyWith(chatMembers: members);

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
      wayaChatsCache.cacheAll(docs);

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
    File? image,
  ]) async {
    final imageUrl =
        image == null ? null : await WayaFileRepository.instance.uploadFile(image, _getGroupProfilePhoto(image));

    //? This is fine.
    final response = await repo.startConversation(type, users, name, description, imageUrl);

    //? If this was fine...
    if (!response.success) {
      return null;
    }

    //? Try getting all chats.
    getChats();

    //? Get this chat.
    final chat = await getChatDetails(response.data['data']['id']);

    //? If this is not null.
    if (chat != null) {
      WayaSocketController.instance.emit(WayaChatSocketArgs.join(chat.id));
    }

    //? Now, return this.
    return chat;
  }

  /// Helper function used to retrieve all of the details of just one conversation.
  Future<ChatModel?> getChatDetails(String id, [bool replace = true]) async {
    //? This is fine.
    final response = await repo.getConversation(id);

    //? This is fine.
    if (response.success) {
      //? Fetch this.
      var result = ChatModel.fromJson(response.data['data']);

      //? Now, it is time to sort the chat members in the order that they should show up on the front-end.
      final members = <ChatMember>[];

      //? First one, is the one where the user is me.
      if (result.self != null) {
        members.add(result.self!);
      }

      //? Second, add all group admins.
      members.addAll(result.allOthers.where((member) => member.role != ChatMemberRole.member));

      //? Third, add all regular users.
      members.addAll(result.allOthers.where((member) => member.role == ChatMemberRole.member));

      //? Finally, replace the conversation with what we have here.
      result = result.copyWith(chatMembers: members);

      //? Look for this in our lists.
      final pos = state.conversations.indexWhere((chat) => chat.id == id);
      final archivedPos = state.archived.indexWhere((chat) => chat.id == id);

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

      //? If this is to replace the chat inside of the list of chats and it is
      //? possible to
      if (replace && archivedPos != -1) {
        final chats = state.archived;
        final previous = chats[archivedPos];

        //? Fix the bug where the latest message is not always guaranteed to be
        //? showing up here.
        chats[archivedPos] = result.copyWith(
          lastMessage: result.lastMessage ?? previous.lastMessage,
          latestMessageId: result.latestMessageId ?? previous.latestMessageId,
        );

        //? Then update this.
        state = state.copyWith(archived: chats);
      }

      //* Return this as the case may be.
      wayaChatsCache.cache(id, result);
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

  /// Helper function used to retrieve the list of muted users.
  Future<bool> getMutedUsers() async {
    final response = await repo.getMutedUsers();

    if (response.success) {}

    return response.success;
  }

  /// Helper function used to mute or unmute a user as the case may be.
  Future<bool> muteOrUnmuteUserEndpoint(String id, String? time) async {
    final response = await repo.muteOrUnmuteUser(id);

    //? This is fine.
    if (response.success) {
      await getChats();
      await getMutedUsers();
    }

    //? Return whether or not this is true.
    return response.success;
  }

  /// Helper function used to report a user as the case may be.
  Future<bool> reportUser(String id, String reason, [String? comment]) async {
    final response = await repo.reportUser(id, reason, comment);

    //? Return whether or not this is true.
    return response.success;
  }

  /// Helper function used to update user chat settings
  Future<bool> updateChatSettings(PrivacySettingsDto dto) async {
    final response = await repo.updateChatSettings(dto);

    //? Return whether or not this is true.
    return response.success;
  }

  /// Helper function used to retrieve all of the details of just one conversation.
  Future<PrivacySettingsDto?> getChatSettings() async {
    //? This is fine.- getting from server with userId
    final response = await repo.getChatSettings(ConversationState.self.id);

    //? This is fine.
    if (response.success) {
      return PrivacySettingsDto.fromJson(response.data['data']);
    }

    //? Return null if empty
    return null;
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
      wayaChatsCache.deleteItem(id);
    }

    //? Return whether or not this is true.
    return response.success;
  }

  /// Helper function used to mute/unmute a user.
  Future<bool> muteOrUnmuteUser(BuildContext context, WidgetRef ref, String id) async {
    //? the provider
    final viewModel = ref.watch(wayaSelectFieldViewModelProvider(Uuid().v4()));

    //? a drop down to mute or unmute a user
    viewModel.selectValue(
        context,
        "Mute User",
        subTitle: "You won't receive notifications from this user based on the time you set",
        contextHeight: context.height * 0.45,
        [
          Select(label: "Unmute", value: "0"),
          Select(label: "1 hour", value: "1"),
          Select(label: "8 hours", value: "2"),
          Select(label: "24 hours", value: "3"),
          Select(label: "1 week", value: "4"),
          Select(label: "Always", value: "5"),
        ], (value) {
      if (value.first.label == "Unmute") {
        //? This is fine.
        return muteOrUnmuteUserEndpoint(id, null);
      }
      return muteOrUnmuteUserEndpoint(id, dateConversion(value.first.label));
    }, false);
    return false;
  }

  /// Helper function used to clear all the messages in a chat.
  Future<bool> clearChat(String id) async {
    //? This is fine.
    final response = await repo.deleteMessages(id);

    //? If this went well, remove it from the list of chats.
    if (response.success) {
      await getChatDetails(id);
    }

    //? Return whether or not this is true.
    return response.success;
  }

  /// Helper function used to select what date corresponds with a give.
  String dateConversion(String pickedDuration) {
    DateTime baseTime = DateTime.now().toUtc();

    // Add durations

    switch (pickedDuration) {
      case "1 hour":
        DateTime plus1Hour = baseTime.add(Duration(hours: 1));
        return plus1Hour.toIso8601String();

      case "8 hours":
        DateTime plus8Hours = baseTime.add(Duration(hours: 8));
        return plus8Hours.toIso8601String();

      case "24 hours":
        DateTime plus24Hours = baseTime.add(Duration(hours: 24));
        return plus24Hours.toIso8601String();

      case "1 week":
        DateTime plus1Week = baseTime.add(Duration(days: 7));
        return plus1Week.toIso8601String();

      case "Always":
        // Add 5 years manually
        DateTime plus10Years = DateTime(
          baseTime.year + 10,
          baseTime.month,
          baseTime.day,
          baseTime.hour,
          baseTime.minute,
          baseTime.second,
          baseTime.millisecond,
          baseTime.microsecond,
        ).toUtc(); // keep everything in UTC
        return plus10Years.toIso8601String();

      default:
        return "";
    }
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
      final docs = (data['docs'] as List)
          .map((doc) => ChatModel.fromJson(doc))
          .where((chat) => chat.latestMessageId != null)
          .toList();

      //? First, we check each of the members in each conversation...
      for (var c = 0; c < docs.length; c++) {
        //? Now, it is time to sort the chat members in the order that they should show up on the front-end.
        final members = <ChatMember>[];
        final example = docs[c].self;

        //? First one, is the one where the user is me.
        if (example != null) {
          members.add(example);
        }

        //? Second, add all group admins.
        members.addAll(docs[c].allOthers.where((member) => member.role != ChatMemberRole.member));

        //? Third, add all regular users.
        members.addAll(docs[c].allOthers.where((member) => member.role == ChatMemberRole.member));

        //? Finally, replace the conversation with what we have here.
        final conversation = docs[c].copyWith(chatMembers: members);

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
      wayaChatsCache.cacheAll(docs);

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

  //*********************** The section for groups *****************************

  /// Helper function used to change the profile picture of a group chat.
  Future<bool> changeGroupProfilePicture(String id, File file) async {
    try {
      //? First, upload the new profile image.
      final imageUrl = await WayaFileRepository.instance.uploadFile(file, _getGroupProfilePhoto(file));

      //? If this was not fine... stop.
      if (imageUrl == null) {
        return false;
      }

      //? Now, use it.
      final response = await repo.updateGroupImage(id, imageUrl);

      //? If this was true.
      if (response.success) {
        await getChatDetails(id);
      }

      //? Return whether this was true or not.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.chats,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
    return false;
  }

  /// Helper function used to mute or unmute a group chat so that we no longer
  /// wish to receive any notifications from.
  Future<bool> muteOrUnmuteGroup(String id, DateTime? mutedUntil) async {
    try {
      //? Now, use it.
      final response = await repo.muteOrUnmuteGroup(id, mutedUntil);

      //? If this was true.
      if (response.success) {
        await getChatDetails(id);
      }

      //? Return whether this was true or not.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.chats,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
    return false;
  }

  /// Helper function used to make a report about a group chat that is annoying
  /// you.
  Future<bool> reportGroup(String id, String reason) async {
    try {
      //? Now, use it.
      final response = await repo.reportChatGroup(id, reason);

      //? If this was true.
      if (response.success) {
        await getChatDetails(id);
      }

      //? Return whether this was true or not.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.chats,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
    return false;
  }

  /// Helper function used to remove a user from the group.
  Future<bool> removeUserFromGroup(String id, String userId) async {
    try {
      //? Now, use it.
      final response = await repo.removeUserFromGroup(id, userId);

      //? If this was true.
      if (response.success) {
        await getChatDetails(id);
      }

      //? Return whether this was true or not.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.chats,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
    return false;
  }

  /// Helper function used to remove a user from the group.
  Future<bool> addUserToGroup(String id, String userId) async {
    try {
      //? Now, use it.
      final response = await repo.addUserToGroup(id, userId);

      //? If this was true.
      if (response.success) {
        await getChatDetails(id);
      }

      //? Return whether this was true or not.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.chats,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
    return false;
  }

  /// Helper function used to remove a user from the group.
  Future<bool> makeUserAdmin(String id, String userId) async {
    try {
      //? Now, use it.
      final response = await repo.makeUserAdmin(id, userId);

      //? If this was true.
      if (response.success) {
        await getChatDetails(id);
      }

      //? Return whether this was true or not.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.chats,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
    return false;
  }

  /// Helper function used to leave a group chat when you don tire to dey the
  /// group.
  Future<bool> leaveGroup(String id) async {
    try {
      //? Now, use it.
      final response = await repo.leaveGroup(id);

      //? If this was successful.
      if (response.success) {
        await getChatDetails(id);
      }

      //? Return whether this was true or not.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.chats,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
    return false;
  }

  /// Helper function used to edit the name (and probably description) of a group
  /// conversation.
  Future<bool> updateGroupInfo(String id, String name, [String? description]) async {
    try {
      //? Now, use it.
      final response = await repo.updateGroupInfo(id, name, description);

      //? If this was successful.
      if (response.success) {
        await getChatDetails(id);
      }

      //? Return whether this was true or not.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.chats,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
    return false;
  }

  /// Helper function used to generate the filename of a group chat.
  String _getGroupProfilePhoto(File file) {
    return "group-${WayaValueHelper.createUid()}.${WayaFileHelper.getFileExtension(file.path)}";
  }

  /// Helper function used to get a single chat from our lists of chats.
  ChatModel? getChat(String id) {
    return state.conversations.where((chat) => chat.id == id).firstOrNull ??
        state.archived.where((chat) => chat.id == id).firstOrNull;
  }
}

/// The state provider for conversations.
final conversationProvider = StateNotifierProvider<ConversationVm, ConversationState>((ref) {
  return ConversationVm(ConversationState.initial);
});
