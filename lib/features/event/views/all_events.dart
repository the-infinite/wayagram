import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/views/add_event/add_event.dart';
import 'package:wayagram/features/event/widgets/event_widget.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';

class AllEvents extends ConsumerStatefulWidget {
  const AllEvents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllEventsState();
}

class _AllEventsState extends ConsumerState<AllEvents> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WayaButton(
          callback: () {
            WayaNav.toNamed(AddEvent.route);
          },
          color: wayaTheme.colorScheme.primar50,
          centerWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                WayaAssets.icons.addEventIcon.path,
                colorFilter: ColorFilter.mode(
                    wayaTheme.colorScheme.customPrimary, BlendMode.srcIn),
              ),
              const Gap(6),
              Text(
                "Creat an Event",
                style: TextStyle().wayaCopyWith(
                    color: wayaTheme.colorScheme.customPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        const Gap(10),
        FilterWidget(
          search: TextEditingController(),
          hintText: 'Search Event',
        ),
        const Gap(10),
        GroupedWidgetHeader(
            onTap: () {},
            subTitle: 'See upcoming event here',
            title: 'Upcoming Events'),
        const Gap(25),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 6,
            itemBuilder: (context, index) {
              return EventWidget();
            }),
        const Gap(25),
      ],
    );
  }
}
