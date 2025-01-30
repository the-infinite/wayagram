import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';

class ReportEvent extends ConsumerStatefulWidget {
  const ReportEvent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportEventState();
}

class _ReportEventState extends ConsumerState<ReportEvent> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
     final wayaTheme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text("Report ", style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text("Help us improve the platform by letting us know you are reporting this event",
            style: wayaTheme.textTheme.hintStyle),
        const Gap(30),
      ],
    );
  }
}
