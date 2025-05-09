import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/general_settings/notifications/controller/default.dart';
import 'package:wayagram/features/general_settings/notifications/dto/default.dart';
import 'package:wayagram/features/general_settings/notifications/vm/default.dart';

class NotificationSwitchButton extends StatefulWidget {
  final String name;
  final String description;
  final bool value;
  final String uid;
  final NotificationSettingsVm notifier;
  final NotificationSettingsController controller;

  // Construct.
  const NotificationSwitchButton({
    super.key,
    required this.name,
    required this.description,
    required this.value,
    required this.uid,
    required this.notifier,
    required this.controller,
  });

  @override
  State<NotificationSwitchButton> createState() => _NotificationSwitchButtonState();
}

class _NotificationSwitchButtonState extends State<NotificationSwitchButton> {
  late bool _isActive = widget.value;

  /// Helper function used to update the state of these buttons.
  void _toggleValue() async {
    final value = !_isActive;

    //? Update this and then do what we need it to.
    widget.controller.updateSetting(widget.uid, value);

    //? Do the needful.
    widget.notifier.updateSettings(widget.controller);

    //? Now, update this.
    setState(() {
      _isActive = value;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        widget.controller.addSetting(
          widget.uid,
          NotificationSetting(
            category: widget.name,
            notificationType: NotificationType.fromString(widget.uid),
            enabled: widget.value,
          ),
        );
      },
    );
    super.initState();
  }

  // This is fine.
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? First, the button.
        Material(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: _toggleValue,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //? First, the title and subtitle..
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First, the title.
                        Text(
                          widget.name,
                          style: WayaTextStyles.titleMedium.copyWith(
                            fontSize: 15.sp,
                          ),
                        ),

                        // Second, the subtitle.
                        Text(
                          widget.description,
                          style: WayaTextStyles.mediumDescriptionStyle.copyWith(
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Boundless space.
                  const Gap(15),

                  //? Finally, the toggling checkbox.
                  CupertinoSwitch(
                    activeTrackColor: WayaColors.primary,
                    value: _isActive,
                    onChanged: (value) => _toggleValue(),
                  ),
                ],
              ),
            ),
          ),
        ),

        //? Then its space.
        const Gap(10),
      ],
    );
  }
}
