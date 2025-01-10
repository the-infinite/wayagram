import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/shop/widgets/upload_image.dart';

import '../../../../core/utils/waya_navigation.dart';

class CreateUltimate extends ConsumerStatefulWidget {
  final Function goToNextTab;
  const CreateUltimate({super.key, required this.goToNextTab});

  @override
  ConsumerState<CreateUltimate> createState() => _CreateUltimateState();
}

class _CreateUltimateState extends ConsumerState<CreateUltimate> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Create Your Ultimate Talent \n Contest!",
            style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text(
            "Bring your talent contest vision to life. Customize \n details, set stages, and make it unforgettable",
            style: wayaTheme.textTheme.hintStyle),
        const Gap(30),
        WayaTextFormField(
          helperText:
              "This name will be displayed as the official contest title. You can update it if needed",
          controller: TextEditingController(),
          hintText: "Enter Contest Title",
          label: "Contest Title",
        ),
        const Gap(15),
        WayaSelectField(
          height: 0.3,
          label: "Contest Category",
          hintText: 'Select Contest Category',
          items: [],
          onSelected: (value) {},
          uniqueKey: 'contest-category',
        ),
        const Gap(15),
        WayaSelectField(
          height: 0.3,
          label: "Contest State",
          hintText: 'Select Contest State',
          items: [],
          onSelected: (value) {},
          uniqueKey: 'contest-state',
        ),
        const Gap(15),
        WayaTextFormField(
          controller: TextEditingController(),
          hintText: "Enter Contest Description",
          label: "Contest Description",
          line: 6,
        ),
        const Gap(15),
        WayaTextFormField(
          keyboardType: TextInputType.number,
          controller: TextEditingController(),
          hintText: "Enter Vote Counts to Qualify",
          label: "Vote Counts to Qualify",
        ),
        const Gap(15),
        WayaTextFormField(
          controller: TextEditingController(),
          hintText: "Enter Winner's Award",
          label: "Winner's Award",
        ),
        const Gap(15),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioSelect(
                title: Container(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Private", style: wayaTheme.textTheme.titleMedium),
                        const Gap(6),
                        Text(
                          "Make contest private",
                          style: wayaTheme.textTheme.hintStyle,
                        )
                      ],
                    )),
                value: "Private"),
            RadioSelect(
                title: Container(
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Private", style: wayaTheme.textTheme.titleMedium),
                      const Gap(6),
                      Text(
                        "Make contest public",
                        style: wayaTheme.textTheme.hintStyle,
                      )
                    ],
                  ),
                ),
                value: "Public"),
          ],
        ),
           const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Show Overall Result",
                    style: wayaTheme.textTheme.titleMedium),
                const Gap(6),
                Text(
                  "Hide Overall Result",
                  style: wayaTheme.textTheme.hintStyle,
                )
              ],
            ),
            Switch(value: false, onChanged: (value) => {}),
          ],
        ),
        const Gap(15),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioSelect(
                title: Container(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Free", style: wayaTheme.textTheme.titleMedium),
                        const Gap(6),
                        Text(
                          "Select if contest free",
                          style: wayaTheme.textTheme.hintStyle,
                        )
                      ],
                    )),
                value: "Free"),
            RadioSelect(
                title: Container(
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Paid", style: wayaTheme.textTheme.titleMedium),
                      const Gap(6),
                      Text(
                        "Select if contest paid",
                        style: wayaTheme.textTheme.hintStyle,
                      )
                    ],
                  ),
                ),
                value: "Paid"),
          ],
        ),
     
        const Gap(15),
        WayaTextFormField(
          keyboardType: TextInputType.number,
          controller: TextEditingController(),
          hintText: "Enter Amount per Vote",
          label: "Amount per Vote",
        ),
        const Gap(15),
        WayaTextFormField(
          keyboardType: TextInputType.number,
          controller: TextEditingController(),
          hintText: "Enter Number of Weeks",
          label: "Number of Weeks",
        ),
        const Gap(20),
        UploadImage(onUpload: () {}),
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

class RadioSelect extends StatelessWidget {
  final Widget title;
  final String value;
  const RadioSelect({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          titleAlignment: ListTileTitleAlignment.top,
          contentPadding: EdgeInsets.all(0),
          title: title,
          leading: Transform.scale(
            scale: 1.4,
            child: Radio<String>(
              value: value,
              groupValue: value,
              onChanged: (value) {},
            ),
          ),
          minLeadingWidth: 0,
          minVerticalPadding: 0,
        ),
        const Gap(4),
      ],
    );
  }
}
