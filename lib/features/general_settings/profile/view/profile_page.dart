import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/user/resource/user_resource.dart';

import 'private_profile.dart';
import 'public_profile.dart';

class ProfilePage extends ConsumerStatefulWidget {
  static const route = '/p';
  final String id;
  final String? username;
  final String source;

  // Construct.
  const ProfilePage({
    super.key,
    required this.id,
    required this.username,
    required this.source,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  CachedUserDataTuple? _cachedUserData;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //? If this is by username, do the needful.
      if (widget.username != null) {
        _cachedUserData = await UserResource.getByUsername(widget.username!);
      }

      //? If this is for me, return this one.
      else if (widget.id == ConversationState.self.id ||
          widget.username == ConversationState.profile.username) {
        _cachedUserData = (ConversationState.self, ConversationState.profile);
      }

      //? Then fetch the user using the id.
      else {
        _cachedUserData = await UserResource.getUserDetails(widget.id);
      }

      //? If this is undefined...
      if (_cachedUserData == null) return;

      //? Force a UI update.
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //? Set this.
    final data = _cachedUserData;

    //? When this is undefined...
    if (data == null) return const SizedBox();

    //? If this user is the one currently logged in.
    if (data.$1.id == ConversationState.self.id) {
      return MyProfilePage(
        data: data,
        source: widget.source,
      );
    }

    //? Since this is another person.
    return UsersProfilePage(
      data: data,
      source: widget.source,
    );
  }
}
