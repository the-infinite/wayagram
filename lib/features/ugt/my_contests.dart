import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';

import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

class MyContests extends ConsumerWidget {
  const MyContests({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc:
            "You don’t have any active contest here. Create a \n contest and have different participant",
        title: "No Contest Created",
        buttonText: "Host a Contest",
        onTap: () {
          WayaNav.toNamed("/create-contest");
        });
  }
}
