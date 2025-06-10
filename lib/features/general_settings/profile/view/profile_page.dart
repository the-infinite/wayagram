// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

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
  @override
  Widget build(BuildContext context) {
    return WayaFutureSubscriber(
      future: widget.username != null
          ? UserResource.getByUsername(widget.username!)
          : UserResource.getUserDetails(widget.id, true),
      builder: (context, data) {
        //? When this is undefined...
        if (data == null) return const SizedBox();

        //? If this user is the one currently logged in.
        if (widget.id == ConversationState.self.id) {
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
      },
    );
  }
}
