import 'package:flutter/material.dart';
import 'package:wayagram/features/chat/model/message.dart';

class VoiceMessageWidget extends StatefulWidget {
  final MessageModel data;
  final Color textColor;

  // Construct.
  const VoiceMessageWidget({
    super.key,
    required this.data,
    required this.textColor,
  });

  @override
  State<VoiceMessageWidget> createState() => _VoiceMessageWidgetState();
}

class _VoiceMessageWidgetState extends State<VoiceMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
