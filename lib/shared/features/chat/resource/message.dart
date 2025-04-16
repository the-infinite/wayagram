import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/data/database.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/model/message.dart';

class MessageResource {
  static final instance = MessageResource._();
  MessageResource._();

  /// A helper function used to synchronize a single message in the database. It
  /// is worth noting that this function updates not only the message, but all
  /// records associated with it.
  Future<bool> syncSingle(MessageModel message) async {
    try {
      //? The time when all of this was done.
      final now = DateTime.now();

      //? First, the media entities.
      final statusEntities = message.status
              ?.map(
                (status) => MessageStatus.withId(
                  status.id,
                  status.messageId,
                  status.userId,
                  status.status.name,
                  status.createdAt,
                  now,
                  WayagramDatabaseSyncStatus.synced.name,
                ),
              )
              .toList() ??
          [];

      //? Second, the media entities.
      final mediaEntities = message.media
              ?.map(
                (media) => MessageMedia.withId(
                  media.id,
                  media.messageId,
                  media.mediaType.value,
                  media.mediaUrl,
                  media.createdAt,
                  media.updatedAt,
                  now,
                  WayagramDatabaseSyncStatus.synced.name,
                ),
              )
              .toList() ??
          [];

      //? Third, the message reactions.
      final reactionEntities = message.messageReaction
              ?.map(
                (reaction) => MessageReaction.withId(
                  reaction.id,
                  reaction.messageId,
                  reaction.userId,
                  reaction.reaction,
                  now,
                  WayagramDatabaseSyncStatus.synced.name,
                ),
              )
              .toList() ??
          [];

      //? This is fine.
      final messageEntity = Message.withId(
        message.id,
        message.chatId,
        message.senderId,
        message.content,
        message.mediaUrl,
        message.messageType.value,
        message.edited,
        message.originalMessageId,
        message.forwardedFrom,
        message.isReply,
        message.createdAt,
        message.updatedAt,
        message.momentId,
        message.isDeleted,
        message.isDeletedBySender,
        now,
        WayagramDatabaseSyncStatus.synced.name,
      );

      //? Now, for each status update...
      for (final status in statusEntities) {
        await status.upsert();
      }

      //? Now, for each media update...
      for (final media in mediaEntities) {
        await media.upsert();
      }

      //? Now, for each reaction update.
      for (final reaction in reactionEntities) {
        await reaction.upsert();
      }

      //? Now try to upsert the message itself.
      await messageEntity.upsert();

      //? Now, let us try to update or insert the latest goal for the message
      //? status
      await ChatSync.withFields(message.chatId, now, WayagramDatabaseSyncStatus.synced.name).upsert();

      //? This went well.
      return true;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.chats,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? This went very badly.
    return false;
  }

  /// Our helper function used to add all new messages to the list of messages
  /// that we have here on this device locally. It is helpful when trying to
  /// populate the chat database with meaningful data.
  Future<bool> syncMessages(List<MessageModel> messages) async {
    try {
      //? Update the messages available
      for (final message in messages) {
        final result = await syncSingle(message);

        //? If this failed....
        if (!result) {
          return false;
        }
      }

      //? This went well.
      return true;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.chats,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Do the needful.
    return false;
  }

  /// Our helper function used to delete a message from the database. It is worth
  /// noting that this doesn't delete only the messages in the database, but also
  /// all media, status, and reactions associated with them.
  Future<bool> deleteMessage(String id, String chatId) async {
    try {
      //? The time when all of this was done.
      final now = DateTime.now();

      //? Now, for each status update...
      await MessageStatus().select().messageId.equals(id).delete();

      //? Now, for each media update...
      await MessageMedia().select().messageId.equals(id).delete();

      //? Now, for each reaction update.
      await MessageReaction().select().messageId.equals(id).delete();

      //? Now try to delete the message itself.
      await Message().select().id.equals(id).delete();

      //? Now, let us try to update or insert the latest goal for the message
      //? status
      await ChatSync().select().id.equals(chatId).update({
        "synced_at": now,
      });

      //? This went well.
      return true;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.chats,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? This went very badly.
    return false;
  }

  /// Our helper function used to build the absolute list of all all messages
  /// that match a given conversation relying only on data from the server side.
  Future<List<MessageModel>> getMessages(String chatId, [int page = 1, int limit = 50]) async {
    final results = await Message().select().chatId.equals(chatId).page(page, limit).toList();
    final pure = <Map<String, dynamic>>[];

    //? Now, for each item herein.
    for (final message in results) {
      final serializable = message.toMap(forJson: true);
      serializable['status'] = (await MessageStatus().select().messageId.equals(message.id).toList())
          .map((status) => status.toMap(forJson: true))
          .toList();
      serializable['media'] = (await MessageMedia().select().messageId.equals(message.id).toList())
          .map((media) => media.toMap(forJson: true))
          .toList();
      serializable['messageReaction'] = (await MessageReaction().select().messageId.equals(message.id).toList())
          .map((reaction) => reaction.toMap(forJson: true));
      pure.add(serializable);
    }

    //? Then we multiplex back.
    return pure.map((message) => MessageModel.fromJson(message)).toList();
  }
}
