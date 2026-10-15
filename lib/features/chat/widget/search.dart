import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';

class SearchConversationWidget extends StatefulWidget {
  final FutureOr<void> Function(String) onTextChange;
  final bool isArchived;

  // This is fine.
  const SearchConversationWidget({
    super.key,
    required this.onTextChange,
    this.isArchived = false,
  });

  @override
  State<SearchConversationWidget> createState() =>
      _SearchConversationWidgetState();
}

class _SearchConversationWidgetState extends State<SearchConversationWidget> {
  @override
  Widget build(BuildContext context) {
    // This is fine too.
    final size = MediaQuery.sizeOf(context);

    // This is fine.
    return SizedBox(
      height: 50,
      width: size.width,
      child: WayaTextFormField(
        padding: const EdgeInsets.only(left: 1, right: 10),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: WayaAssets.icons.actionSearch.svg(),
        ),
        onChanged: widget.onTextChange,
        hintText: "Search chats",
      ),
    );
  }
}
