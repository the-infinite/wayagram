import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class JoinEvent extends ConsumerStatefulWidget {
  const JoinEvent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JoinEventState();
}

class _JoinEventState extends ConsumerState<JoinEvent> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Join Event ", style: wayaTheme.textTheme.titleLarge),
          const Gap(5),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text:
                    "Are you sure you want to join this event, this would cost",
                style: wayaTheme.textTheme.hintStyle),
            TextSpan(
                text: "N500",
                style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                    color: wayaTheme.colorScheme.customPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 15))
          ])),
          const Gap(30),
          Container(
            padding: EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.primar50,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Available Balance",
                  style: Theme.of(context).textTheme.bodyMedium?.wayaCopyWith(
                        fontSize: 14,
                        color: wayaTheme.colorScheme.greyColor900,
                      ),
                ),
                const Gap(6),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Wallet Balance",
                          style: wayaTheme.textTheme.hintStyle),
                      const Gap(3),
                      WayaAmountFormatter(
                        color: wayaTheme.colorScheme.customBlack,
                        balanceColor: wayaTheme.colorScheme.customBlack,
                        koboValueColor: wayaTheme.colorScheme.greyColor600,
                        amount: double.parse("0"),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
          WayaButton(
              callback: () {
                // Navigator.of(context).pop(selectedStatus);
              },
              text: "Yes, Join Event"),
          const Gap(10),
          WayaButton(
              callback: () {
                Navigator.of(context).pop();
              },
              textColor: wayaTheme.colorScheme.greyColor300,
              color: wayaTheme.colorScheme.transparent,
              border: Border.all(
                  color: wayaTheme.colorScheme.greyColor500, width: 1),
              text: 'Go Back')
        ],
      ),
    );
  }
}
