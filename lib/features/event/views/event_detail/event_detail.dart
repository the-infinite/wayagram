import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class EventDetail extends ConsumerStatefulWidget {
  const EventDetail({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventDetailState();
}

class _EventDetailState extends ConsumerState<EventDetail> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Event",
      appBarTrailing: EventDetailAction(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20),
          WayaImage(
            imageUrl: "",
            height: context.height * 0.1,
            width: double.infinity,
            radius: BorderRadius.circular(10),
          ),
          const Gap(15),
          Row(
            children: [
              WayaTabButton(
                isSelected: _selectedIndex == 0,
                text: 'Event Details',
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              WayaTabButton(
                isSelected: _selectedIndex == 2,
                text: 'Attendees',
                onTap: () => setState(() => _selectedIndex = 2),
              ),
            ],
          ),
          const Gap(10),
          if (_selectedIndex == 0) Container(),
          if (_selectedIndex == 1) Container(),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: context.width * 0.45,
            child: WayaButton(
              callback: () {},
              border: Border.all(
                  width: 1, color: wayaTheme.colorScheme.customPrimary),
              centerWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.share,
                      size: 22, color: wayaTheme.colorScheme.customPrimary),
                  const Gap(4),
                  Text(
                    'Share Event',
                    style: wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                      fontWeight: FontWeight.w600,
                      color: wayaTheme.colorScheme.customPrimary,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: context.width * 0.45,
            child: WayaButton(
              callback: () {},
              text: 'Join Event',
            ),
          )
        ],
      ),
    );
  }
}

class EventDetailAction extends StatelessWidget {
  const EventDetailAction({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return PopupMenuButton(
        onSelected: (value) {},
        iconColor: wayaTheme.colorScheme.greyColor400,
        position: PopupMenuPosition.under,
        itemBuilder: (context) {
          return [
            PopupMenuItem<int>(
              value: 0,
              child: _buildActionNav(
                  context: context,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  asset: Icon(
                    Icons.share,
                    size: 22,
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                  text: "Share Event"),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: _buildActionNav(
                  context: context,
                  onTap: () {},
                  asset: Icon(
                    Icons.flag_outlined,
                    size: 22,
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                  text: "Report Event"),
            ),
            PopupMenuItem<int>(
              value: 2,
              child: _buildActionNav(
                  context: context,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  asset: Icon(
                    Icons.edit_note_sharp,
                    size: 22,
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                  text: "Edit Shop"),
            )
          ];
        });
  }

  InkWell _buildActionNav(
      {required BuildContext context,
      required VoidCallback onTap,
      required Widget asset,
      required String text}) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          asset,
          const Gap(4),
          Text(
            text,
            style: TextStyle().wayaCopyWith(
                color: wayaTheme.colorScheme.customBlack,
                fontWeight: FontWeight.w500,
                fontSize: 12),
          )
        ],
      ),
    );
  }
}
