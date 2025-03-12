import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatProfilePage extends ConsumerStatefulWidget {
  static const route = "/conversation/chat/profile";
  final String chatId;

  // Construct.
  const ChatProfilePage({
    super.key,
    required this.chatId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatProfilePageState();
}

class _ChatProfilePageState extends ConsumerState<ChatProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
