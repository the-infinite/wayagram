import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/data/model/add_event_state.dart';
import 'package:wayagram/features/event/bottom_sheets/report_event.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/views/event_detail/event_attendees.dart';
import 'package:wayagram/features/event/views/event_detail/event_detail_widget.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';

class EventDetail extends ConsumerStatefulWidget {
  static const route = "/event-detail";
  const EventDetail({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventDetailState();
}

class _EventDetailState extends ConsumerState<EventDetail> {
  int _selectedIndex = 0;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final EventDoc event =
          ModalRoute.of(context)!.settings.arguments as EventDoc;
      ref.read(eventVmProvider.notifier).getSingleEvent(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final viewModel = ref.watch(eventVmProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        isLoading: false,
        isScrollable: false,
        title: "Event",
        appBarTrailing: EventDetailAction(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            WayaImage(
              imageUrl: viewModel.singleEvent?.image ?? '',
              height: context.height * 0.2,
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
                  isSelected: _selectedIndex == 1,
                  text: 'Attendees',
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
              ],
            ),
            const Gap(10),
            if (_selectedIndex == 0) EventDetailWidget(),
            if (_selectedIndex == 1) EventAttendees(), //EventAttendees()
          ],
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(10, 4, 10, 10),
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.white,
          ),
          child: viewModel.isUserEvent ?Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: context.width * 0.45,
                child: WayaButton(
                  callback: () {},
                  color: wayaTheme.colorScheme.transparent,
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
              //  Gap(context.width * 0.04),
              SizedBox(
                width: context.width * 0.45,
                child: WayaButton(
                  callback: () {},
                  text: 'Edit Event Detail',
                ),
              )
            ],
          ) : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: context.width * 0.45,
                child: WayaButton(
                  callback: () {},
                  color: wayaTheme.colorScheme.transparent,
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
              //  Gap(context.width * 0.04),
              SizedBox(
                width: context.width * 0.45,
                child: WayaButton(
                  callback: () {},
                  text: 'Join Event',
                ),
              )
            ],
          ),
        ));
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
                  onTap: () async {
                    Navigator.pop(context);
                    await WayaUtils.showModalSheet(context,
                        child: ReportEvent(
                            statuses: eventReport, currentStatus: ""));
                    /**
                       *
                       *  show success modal 
                       * 
                       *  */
                  },
                  asset: Icon(
                    Icons.flag_outlined,
                    size: 22,
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                  text: "Report Event"),
            ),
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
