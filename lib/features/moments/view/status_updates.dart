import 'package:flutter/material.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import 'package:wayagram/features/moments/model/default.dart';

class _StatusUpdateWidget extends StatelessWidget {
  final double width;
  final StatusUpdateModel update;

  // This is fine.
  const _StatusUpdateWidget(this.update, this.width);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class StatusUpdatesWidget extends StatelessWidget {
  final UserDetailsModel? profile;
  final List<StatusUpdateModel> updates;
  final double width;

  // Construct.
  const StatusUpdatesWidget({
    super.key,
    required this.updates,
    required this.profile,
    required this.width,
  });

  /// A helper function used to sort user status updates in the expected order
  /// and precedence.
  void _sortUpdates() {
    if (profile == null) return;

    // This is fine.
    final mine = updates.indexWhere((update) => update.userId == profile!.id || update.user?.id == profile!.id);

    // If there is no such thing...
    if (mine == -1) return;

    // Since it is all good and fine.
    final found = updates[mine];

    // Then remove the old one.
    updates.removeAt(mine);

    // Push this to the front.
    updates.insert(0, found.bindUser(user: profile));
  }

  @override
  Widget build(BuildContext context) {
    // Before doing anything, sort the status updates.
    _sortUpdates();

    // This is fine.
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: updates.length,
      itemBuilder: (context, index) {
        final update = updates[index];

        // Then, do the needful.
        return _StatusUpdateWidget(update, width);
      },
    );
  }
}
