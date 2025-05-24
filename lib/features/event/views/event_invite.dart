import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/features/event/widgets/search_event_invitee.dart';
import 'package:wayagram/shared/features/user/widget/social.dart';

class EventInvite extends ConsumerStatefulWidget {
  static const route = "/event-invite";
  const EventInvite({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventInviteState();
}

class _EventInviteState extends ConsumerState<EventInvite> {
  late final notifier = ref.read(eventVmProvider.notifier);

  void searhUsers(BuildContext context) async {
    final result = await WayaUtils.showModalSheet(
      context,
      child: SearchEventInvitee(),
    );

    //? Do nothing.
    if (result == null) return;
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(eventVmProvider);
    // TODO: implement build
    return PopScope(
        onPopInvokedWithResult: (isPopping, _) {
          if (!isPopping) return;
          notifier.clearSelectedInvitee();
        },
        child: WayaScaffold(
            title: "Invite User",
            isScrollable: false,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6,
                    children: [
                      InkWell(
                        splashFactory: NoSplash.splashFactory,
                        onTap: () {
                          searhUsers(context);
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(WayaAssets.icons.mAddMoment.path),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              "Add Invitee",
                              style: TextStyle(
                                  color: wayaTheme.colorScheme.customPrimary,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      ...List.generate(
                        state.invitees.length,
                        (index) => SocialUserSelectionWidget(
                          user: state.invitees[index],
                          isSelected: true,
                          onSelect: (p0) =>
                              notifier.updateSelectedInvitee(invitee: p0),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: WayaButton(
                      callback: () {
                        WayaNav.goBack();
                      },
                      text: "Invite",
                    ),
                  ),
                )
              ],
            )));
  }
}
