import 'package:wayagram/features/chat/model/message.dart';

class AttachmentResult {
  final MessageType type;
  final List<String>? files;
  final String? location;
  final List<String>? contacts;

  //? If this is fine though...
  AttachmentResult({
    required this.type,
    required this.files,
    required this.location,
    required this.contacts,
  });

  factory AttachmentResult.file(List<String> files) {
    return AttachmentResult(
      type: MessageType.file,
      files: files,
      location: null,
      contacts: null,
    );
  }

  factory AttachmentResult.images(List<String> files) {
    return AttachmentResult(
      type: MessageType.image,
      files: files,
      location: null,
      contacts: null,
    );
  }

  factory AttachmentResult.video(List<String> files) {
    return AttachmentResult(
      type: MessageType.video,
      files: files,
      location: null,
      contacts: null,
    );
  }
}
