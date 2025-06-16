import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/general_settings/chat_settings/vm.dart';
import 'package:wayagram/features/general_settings/chat_settings/widget/scale_setting.dart';
import 'package:wayagram/features/general_settings/privacy_settings/widget/privacy_widget.dart';

class ChatSettingsPage extends StatefulWidget {
  const ChatSettingsPage({super.key});

  @override
  State<ChatSettingsPage> createState() => _ChatSettingsPageState();
}

class _ChatSettingsPageState extends State<ChatSettingsPage> {
  final darkModeNotifier = ValueNotifier(false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ChatSettingsNotifier.instance.reload();
        darkModeNotifier.value = ChatSettingsNotifier.instance.isDarkMode;
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    darkModeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? Get our building blocks.
    final theme = Theme.of(context);

    //? Return the widget.
    return WayaScaffold(
      title: "Chat Preferences",
      isScrollable: false,
      body: ValueListenableBuilder(
        valueListenable: ChatSettingsNotifier.instance,
        builder: (context, redraws, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //? Number one, for dark mode.
            PrivacyWidget(
              title: "Dark Mode",
              value: "Use darker colors in the chats for easier visibility in darker environments",
              showSwitch: true,
              onSwitchChanged: (value) => ChatSettingsNotifier.instance.setDarkMode(value),
              switchValue: darkModeNotifier,
            ),

            // Some space.
            SizedBox(height: 5.h),

            //? Number two, for the font size.
            WayaScaleSetting(
              title: "Font Size",
              description: "Change the scale of the text on all messages inside WayaGram",
              min: 0.75,
              max: 1.25,
              value: ChatSettingsNotifier.instance.textScale,
              onValueChanged: (value) => ChatSettingsNotifier.instance.setTextScale(value),
              getLabel: (value) => switch (value) {
                0.750 => "Very Small",
                0.875 => "Small",
                1.000 => "Normal",
                1.125 => "Large",
                1.250 => "Very Large",
                _ => "Unknown ($value)",
              },
            ),

            //? Finally, an example preview of how the text would look.
            Text(
              "Preview",
              style: WayaTextStyles.hintStyleBold.copyWith(
                color: theme.colorScheme.greyColor900,
              ),
            ),

            //? Second, the description.
            SizedBox(
              child: Text(
                "Whereas recognition of the inherent dignity",
                style: WayaTextStyles.hintStyleBold.copyWith(
                  color: theme.colorScheme.greyColor500,
                  fontSize: ChatSettingsNotifier.instance.textScale * 15.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
