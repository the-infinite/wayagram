import 'dart:io';

import 'package:wayagram/core/helpers/files.dart';
import 'package:wayagram/features/chat/model/message.dart';

/// Returns a list of files that are attached to a message.
///
/// Takes a [MessageModel] as input and extracts any file attachments
/// associated with that message, returning them as a [List<File>].
/// If no attachments are found, returns an empty list.
///
/// Inspects all files in the chat directory and returns whatever matches the
/// message files spec for spec.
///
/// [message] The message model to extract attachments from.
///
/// Returns a [List<File>] containing all file attachments from the message.
Future<List<File>> getMessageFileAttachments(MessageModel message) async {
  final result = <File>[];

  //? Let's see what the file extension ends with.
  for (final file in (message.media ?? <MessageMedia>[])) {
    final uri = Uri.parse(file.mediaUrl);
    final filename = uri.pathSegments.last;
    final extensionIndex = filename.lastIndexOf(".");
    final extension = extensionIndex > -1 ? filename.substring(extensionIndex + 1) : '';
    var directory = await WayaFileHelper.getDocumentsDirectory();

    //? Now, we check what kind of extension this is.
    if ([...WayaFileExtensions.images, WayaFileExtensions.videos].contains(extension)) {
      directory = await WayaFileHelper.getMediaDirectory();
    }

    //? If this is an audio file.
    if (WayaFileExtensions.audio.contains(extension)) {
      directory = await WayaFileHelper.getAudioDirectory();
    }

    //? Now, we try looking for the rest here.
    final path = "${WayaFileHelper.getFileSubdirectory(directory, message)}/${message.id}.$extension";

    //? This is fine.
    result.add(File(path));
  }

  //? Return the result.
  return result;
}

/// Returns the file associated with a voice message from the provided [message].
///
/// Takes a [MessageModel] as input and locates the corresponding voice message file
/// in the file system. This method assumes the voice message exists and is accessible.
///
/// Example:
/// ```dart
/// final messageFile = getVoiceMessageFile(someMessage);
/// ```
///
/// Throws [FileSystemException] if the file cannot be accessed or does not exist.
Future<File> getVoiceMessageFile(MessageModel message) async {
  final file = message.media!.first;
  final uri = Uri.parse(file.mediaUrl);
  final filename = uri.pathSegments.last;
  final extensionIndex = filename.lastIndexOf(".");
  final extension = extensionIndex > -1 ? filename.substring(extensionIndex + 1) : '';
  final directory = await WayaFileHelper.getVoiceMessagesDirectory();
  final path = "${WayaFileHelper.getFileSubdirectory(directory, message)}/${message.id}.$extension";

  //? This is fine.
  return File(path).absolute;
}
