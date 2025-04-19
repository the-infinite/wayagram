import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditChatGroupScreen extends ConsumerStatefulWidget {
  static const route = "/conversation/chat/profile/group/edit";
  final String groupId;
  final String chatId;

  // Construct.
  const EditChatGroupScreen({
    super.key,
    required this.groupId,
    required this.chatId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends ConsumerState<EditChatGroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
