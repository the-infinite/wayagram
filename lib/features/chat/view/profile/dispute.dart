import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/chat/model/default.dart';

class DisputeChatProfilePage extends StatelessWidget {
  final ChatModel chat;
  final WidgetRef ref;

  // Construct.
  const DisputeChatProfilePage({
    super.key,
    required this.chat,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      padding: EdgeInsets.all(15.dg),
      resizeToAvoidBottomInset: true,
      body: Column(),
    );
  }
}
