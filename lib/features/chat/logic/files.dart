import 'dart:io';

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
List<File> getMessageFileAttachments(MessageModel message) {
  final result = <File>[];

  //? For now, I just do this magic.
  result.addAll(message.media?.map((file) => File(file)) ?? []);

  //? Return the result.
  return result;
}
