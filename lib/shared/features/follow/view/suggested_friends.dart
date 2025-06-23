import 'package:flutter/material.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/shared/features/follow/widget/default.dart';

class SuggestedFriendsScreen extends StatefulWidget {
  const SuggestedFriendsScreen({super.key});

  @override
  State<SuggestedFriendsScreen> createState() => _SuggestedFriendsScreenState();
}

class _SuggestedFriendsScreenState extends State<SuggestedFriendsScreen> {
  final handler = WayaObservableScrollController();

  @override
  Widget build(BuildContext context) {
    return WayaScaffold(
      isScrollable: false,
      isLoading: false,
      title: "Suggested Friends",
      backgroundColor: WayaColors.scaffoldColor,
      resizeToAvoidBottomInset: true,
      body: SharedSuggestedFriendsWidget(
        isExpanded: true,
        handler: handler,
      ),
    );
  }
}
