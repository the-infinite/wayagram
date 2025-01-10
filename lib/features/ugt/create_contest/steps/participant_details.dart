import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';

import '../../../../core/components/waya_buttons.dart';
import '../../../../core/components/waya_select_field.dart';
import '../../../../core/components/waya_text_form_field.dart';
import '../../../../core/utils/waya_navigation.dart';
import '../../../shop/widgets/upload_image.dart';
import 'create_ultimate.dart';

class ParticipantDetails extends ConsumerStatefulWidget {
  final Function goToNextTab;
  const ParticipantDetails( {super.key, required this.goToNextTab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ParticipantDetailsState();
}
final _formKey = GlobalKey<FormState>();

class _ParticipantDetailsState extends ConsumerState<ParticipantDetails> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Participation Details",
            style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text(
            "Bring your talent contest vision to life. Customize details,\n set stages, and make it unforgettable",
            style: wayaTheme.textTheme.hintStyle),
        const Gap(30),
        WayaTextFormField(
          controller: TextEditingController(),
          hintText: "Enter Contest Description",
          label: "How It Works",
          line: 6,
        ),
        const Gap(15),
        WayaSelectField(
          height: 0.3,
          label: "Entry Type",
          hintText: 'Choose entry type',
          items: [],
          onSelected: (value) {},
          uniqueKey: 'contest-state',
        ),
        const Gap(15),
       Row(
         children: [
           WayaSelectField(
             height: 0.3,
             label: "Duration Type",
             hintText: 'Select Duration Type',
             items: [],
             onSelected: (value) {},
             uniqueKey: 'contest-state',
           ),

           WayaTextFormField(
             controller: TextEditingController(),
             hintText: "e.g., 3",
             label: "Number of Duration",
           ),
         ],
       ),
        const Gap(15),
        WayaTextFormField(
          controller: TextEditingController(),
          hintText: "Enter Contest Description",
          label: "Contest Description",
          line: 6,
        ),

        const Gap(60),
        WayaButton(
          callback: () {

          },
          text: "Submit",
        ),
        const Gap(8),
        WayaButton(
            text: 'Go Back',
            color: wayaTheme.colorScheme.transparent,
            textColor: wayaTheme.colorScheme.customBlack,
            border:
            Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
            callback: () {
              WayaNav.toNamed("/ugt-home");
            })
      ],
    );
  }
}
