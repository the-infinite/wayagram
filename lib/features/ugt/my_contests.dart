import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';

import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class MyContests extends ConsumerWidget {
  const MyContests({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc:  ConversationState.self.accountType == UserAccountType.business
            ? "You don’t have any active contest here. Create a \n contest and have different participant"
            : "You don’t have any active contest here. Create a \n Business account to access more features",
        title: "No Contest Created",
        buttonText: "Host a Contest",
        hideButton:
            ConversationState.self.accountType == UserAccountType.business ? true : false,
        onTap: () {
          invalidateUGTVm(ref);
          WayaNav.toNamed("/create-contest");
        });
  }
}
