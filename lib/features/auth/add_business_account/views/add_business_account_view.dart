import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:gap/gap.dart';

class AddBusinessAccountView extends ConsumerStatefulWidget {
  const AddBusinessAccountView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddBusinessAccountViewState();
}

class _AddBusinessAccountViewState
    extends ConsumerState<AddBusinessAccountView> {
  @override
  Widget build(BuildContext context) {
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Add Business Account", style: WayaTextStyles.titleLarge),
            const Gap(5),
            Text(
                "Provide us with informations for your business \n account to get you started",
                style: WayaTextStyles.hintStyle),
            const Gap(30),
          ],
        ));
  }
}
