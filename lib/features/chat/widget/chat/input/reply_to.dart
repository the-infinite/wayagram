import 'package:flutter/material.dart';
import 'package:wayagram/features/chat/model/message.dart';

class _MyReplyToWidget extends StatelessWidget {
  final MessageModel message;

  //? This is fine.
  const _MyReplyToWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _UserReplyToWidget extends StatelessWidget {
  final MessageModel message;

  //? This is fine.
  const _UserReplyToWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ChatReplyToWidget extends StatelessWidget {
  final MessageModel message;

  // Construct.
  const ChatReplyToWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
