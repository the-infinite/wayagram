// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/forgot_password/vm/credential_input_vm.dart';
import 'package:wayagram/features/event/bottom_sheets/join_event.dart';
import 'package:wayagram/features/event/data/model/add_event_state.dart';
import 'package:wayagram/features/event/bottom_sheets/report_event.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/data/model/payout/payout.dart';
import 'package:wayagram/features/event/views/event_detail/awaiting_approval.dart';
import 'package:wayagram/features/event/views/event_detail/event_attendees.dart';
import 'package:wayagram/features/event/views/event_detail/event_detail_widget.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/features/event/views/add_event/add_event.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';
import 'package:wayagram/features/polls_and_voting/views/payout_verification.dart';
import 'package:wayagram/features/promotion/data/models/promotion_service_type.dart';
import 'package:wayagram/features/promotion/views/promote.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';
import 'package:wayagram/shared/engagement/provider/event_engagement_monitor.dart';

class EventDetail extends ConsumerStatefulWidget {
  static const route = "/event-detail";
  final String id;

  // Construct.
  const EventDetail({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventDetailState();
}

class _EventDetailState extends ConsumerState<EventDetail> {
  late final notifier = ref.read(eventVmProvider.notifier);
  int _selectedIndex = 0;
  List<Payout> payoutList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        ref.read(walletVmProvider.notifier).getPayoutMethod();
        try {
          notifier.getAttendees(page: 1, id: widget.id);
        } catch (_) {}
        final event = await notifier.getSingleEvent(widget.id);

        final payout = await ref
            .read(eventVmProvider.notifier)
            .getEventPayouts(eventId: widget.id);
        if (payout != null) {
          setState(() {
            payoutList = payout;
          });
        }

        final provider = ref.read(eventEngagementProvider.notifier);

        //? If this is fine.
        if (event != null) {
          provider.startViewingEvent();
          provider.addLocation(event.location, EventPoint.viewEvent.value);
          provider.addEventType(event.eventType, EventPoint.viewEvent.value);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(eventVmProvider);
    final wayaTheme = Theme.of(context);
    final event = viewModel.singleEvent;
    final size = MediaQuery.sizeOf(context);
    final walletViewModel = ref.watch(walletVmProvider);

    //? If this one sef dey.
    if (event == null) {
      return Container(
        height: size.height,
        width: size.width,
        color: wayaTheme.colorScheme.white,
      );
    }

    bool isTicketSalesActive(EventDoc? event) {
      if (event?.ticketSalesStartDate == null ||
          event?.ticketSalesEndDate == null) {
        return false;
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final start = DateTime(
        event!.ticketSalesStartDate!.year,
        event.ticketSalesStartDate!.month,
        event.ticketSalesStartDate!.day,
      );

      final end = DateTime(
        event.ticketSalesEndDate!.year,
        event.ticketSalesEndDate!.month,
        event.ticketSalesEndDate!.day,
      );

      return (today.isAtSameMomentAs(start) || today.isAfter(start)) &&
          (today.isAtSameMomentAs(end) || today.isBefore(end));
    }

    bool cannotJoin(EventDoc? event) {
      bool maxAttendeehasJoined =
          (event?.maxCapacity != null && event!.maxCapacity != 0) &&
              (event.maxCapacity! - event.noOfAttendees) == 0;
      bool cannotStartTicketSales =
          event?.ticketSalesEndDate != null && !isTicketSalesActive(event);

      return (maxAttendeehasJoined) || cannotStartTicketSales;
    }

    //? Returns true if today is a day after ticketSalesEndDate
    //? or the day after the event ended
    bool isDayAfterTicketOrEventEnd(EventDoc? event) {
      if (event == null) return false;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      //? Check ticket sales end date
      // if (event.ticketSalesEndDate != null) {
      //   final ticketEnd = DateTime(
      //     event.ticketSalesEndDate!.year,
      //     event.ticketSalesEndDate!.month,
      //     event.ticketSalesEndDate!.day,
      //   );
      //   if (today.isAtSameMomentAs(ticketEnd.add(const Duration(days: 1))) ||
      //       today.isAfter(ticketEnd.add(const Duration(days: 1)))) {
      //     return true;
      //   }
      // }
      //? Check event end date
      final eventEnd = DateTime(
        event.endDate.year,
        event.endDate.month,
        event.endDate.day,
      );
      if (today.isAtSameMomentAs(eventEnd.add(const Duration(days: 1))) ||
          today.isAfter(eventEnd.add(const Duration(days: 1)))) {
        return true;
      }
      return false;
    }

    return PopScope(
      onPopInvokedWithResult: (isPopping, _) {
        if (!isPopping) return;
        notifier.clearSingle();
      },
      child: WayaScaffold(
        isLoading: false,
        isScrollable: false,
        title: "Event",
        appBarTrailing: EventDetailAction(
          event: event,
          isUser: viewModel.isUserEvent,
          notifier: notifier,
        ),
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
                WayaTabButton(
                  isSelected: _selectedIndex == 2,
                  text: 'Awaitng Approval',
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
              ],
            ),
            const Gap(10),
            if (_selectedIndex == 0) EventDetailWidget(event: event),
            if (_selectedIndex == 1) EventAttendees(eventId: event.id),
            if (_selectedIndex == 2) AwaitingApproval(eventId: event.id),
          ],
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(10, 4, 10, 25),
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.white,
          ),
          child: viewModel.isUserEvent
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: context.width * 0.45,
                      child: WayaButton(
                        callback: isDayAfterTicketOrEventEnd(event)
                            ? () {
                                //?check if user have payout method added
                                if (walletViewModel.payoutMethod.isEmpty) {
                                  WayaUtils.showModalSheet(
                                    context,
                                    child: AddPayoutModal(),
                                  );
                                  return;
                                }
                                if (payoutList.isEmpty) {
                                  if (event.noOfAttendees < 1 &&
                                      event.eventType == 'paid') {
                                    WayaSnackBar.showToast(
                                        "No attendee has paid for the event");
                                    return;
                                  }

                                  ref
                                      .read(credentialInputProvider.notifier)
                                      .onSubmitPayoutPin(() => WayaNav.toNamed(
                                              '/payoutVerification',
                                              arguments: {
                                                "id": event.id,
                                                "Module": PayoutModule.event,
                                              }));
                                } else {
                                  WayaNav.toNamed(
                                      WayaAppRoutes.getSingleEventDashboard(
                                          event.id));
                                }
                              }
                            : null,
                        color: wayaTheme.colorScheme.transparent,
                        border: Border.all(
                            width: 1,
                            color: wayaTheme.colorScheme.customPrimary),
                        centerWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.list,
                                size: 22,
                                color: wayaTheme.colorScheme.customPrimary),
                            const Gap(4),
                            Text(
                              payoutList.isEmpty
                                  ? "Request Payout"
                                  : "Event Dashboard",
                              style:
                                  wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                                fontWeight: FontWeight.w600,
                                color: wayaTheme.colorScheme.customPrimary,
                              ),
                            )
                          ],
                        ),
                      ),

                      //WayaButton(
                      //   callback: () {
                      //     WayaNav.toNamed(WayaAppRoutes.getEventInviteScreen(
                      //         viewModel.singleEvent?.id ?? '',
                      //         viewModel.singleEvent?.title ?? ''));
                      //     /**
                      //      Share.share(
                      //     subject: "Share event",
                      //     WayaValueHelper.getShareableUrl(
                      //         WayaAppRoutes.getEventDetailsScreen(widget.id)),
                      //   )
                      //      */
                      //   },
                      //   color: wayaTheme.colorScheme.transparent,
                      //   border: Border.all(
                      //       width: 1,
                      //       color: wayaTheme.colorScheme.customPrimary),
                      //   centerWidget: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Icon(Icons.share,
                      //           size: 22,
                      //           color: wayaTheme.colorScheme.customPrimary),
                      //       const Gap(4),
                      //       Text(
                      //         'Share Invite',
                      //         style:
                      //             wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                      //           fontWeight: FontWeight.w600,
                      //           color: wayaTheme.colorScheme.customPrimary,
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ),
                    //  Gap(context.width * 0.04),
                    SizedBox(
                      width: context.width * 0.45,
                      child: WayaButton(
                        callback: () {
                          WayaNav.toNamed(AddEvent.route,
                              arguments: viewModel.singleEvent);
                        },
                        text: 'Edit Event Detail',
                      ),
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 15.w,
                  children: [
                    Expanded(
                      child: WayaButton(
                        callback: () {
                          SharePlus.instance.share(ShareParams(
                            subject: "Share event",
                            text: WayaValueHelper.getShareableUrl(
                                WayaAppRoutes.getEventDetailsScreen(event.id)),
                          ));
                        },
                        color: wayaTheme.colorScheme.transparent,
                        border: Border.all(
                            width: 1,
                            color: wayaTheme.colorScheme.customPrimary),
                        centerWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.share,
                                size: 22,
                                color: wayaTheme.colorScheme.customPrimary),
                            const Gap(4),
                            Text(
                              "Share Event",
                              style:
                                  wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                                fontWeight: FontWeight.w600,
                                color: wayaTheme.colorScheme.customPrimary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    //? If this user has already joined this event...
                    if (!viewModel.isLoadingAttendees &&
                        !viewModel.isAttending(viewModel.singleEvent!.id))
                      Expanded(
                        child: WayaButton(
                          callback: cannotJoin(viewModel.singleEvent)
                              ? null
                              : () async {
                                  await WayaUtils.showModalSheet(
                                    context,
                                    child: JoinEvent(
                                        event: viewModel.singleEvent!),
                                  );
                                },
                          text: 'Join Event',
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

class EventDetailAction extends StatelessWidget {
  final EventDoc event;
  final bool isUser;
  final EventVm notifier;

  // Construct.
  const EventDetailAction({
    super.key,
    required this.event,
    required this.isUser,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return PopupMenuButton(
      onSelected: (value) {},
      iconColor: wayaTheme.colorScheme.greyColor400,
      position: PopupMenuPosition.under,
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
            value: 0,
            onTap: () {
              SharePlus.instance.share(ShareParams(
                subject: "Share event",
                text: WayaValueHelper.getShareableUrl(
                    WayaAppRoutes.getEventDetailsScreen(event.id)),
              ));
            },
            child: WayaActionNav(
                context: context,
                color: wayaTheme.colorScheme.customBlack,
                asset: Icon(
                  Icons.share,
                  size: 22,
                  color: wayaTheme.colorScheme.customBlack,
                ),
                text: "Share Event"),
          ),
          if (isUser)
            PopupMenuItem<int>(
              value: 0,
              onTap: () {
                WayaNav.toNamed(
                    WayaAppRoutes.getEventInviteScreen(event.id, event.title));
              },
              child: WayaActionNav(
                  context: context,
                  color: wayaTheme.colorScheme.customBlack,
                  asset: Icon(
                    Icons.share,
                    size: 22,
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                  text: "Invite Users"),
            ),

          //? The destructive CTA.
          if (!isUser)
            // PopupMenuItem<int>(
            //   value: 1,
            //   onTap: () => WayaUtils.showNotice(
            //     context: context,
            //     title: "Cancel event",
            //     message: "Are you sure you wish to cancel this event?",
            //     icon: WayaAssets.icons.erWarning.svg(
            //       height: 32.h,
            //       width: 32.h,
            //       color: wayaTheme.colorScheme.pending,
            //     ),
            //     buttonText: "Yes",
            //     secondButtonText: "Go Back",
            //     onCancel: () => WayaNav.goBack(),
            //     onPress: () async {
            //
            //     },
            //   ),
            //   child: WayaActionNav(
            //     context: context,
            //     color: wayaTheme.colorScheme.error,
            //     asset: Icon(
            //       Icons.delete_forever,
            //       size: 22,
            //       color: wayaTheme.colorScheme.error,
            //     ),
            //     text: "Cancel Event",
            //   ),
            // )
            // else
            if (!isUser)
              PopupMenuItem<int>(
                value: 1,
                onTap: () => WayaUtils.showModalSheet(
                  context,
                  child: ReportEvent(
                    statuses: eventReport,
                    currentStatus: "",
                    eventId: event.id,
                  ),
                ),
                child: WayaActionNav(
                  context: context,
                  color: wayaTheme.colorScheme.customBlack,
                  asset: Icon(
                    Icons.flag_outlined,
                    size: 22,
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                  text: "Report Event",
                ),
              ),
          if (isUser)
            PopupMenuItem<int>(
              value: 2,
              onTap: () async {
                WayaNav.toNamed(Promote.route, arguments: {
                  "contentId": event.id,
                  "contentType": PromotionServiceType.event.name,
                  "data": event
                });
              },
              child: WayaActionNav(
                context: context,
                color: wayaTheme.colorScheme.customBlack,
                asset: SvgPicture.asset(
                  WayaAssets.icons.mFire.path,
                  colorFilter: ColorFilter.mode(
                    wayaTheme.colorScheme.customBlack,
                    BlendMode.srcIn,
                  ),
                ),
                text: "Promote Event",
              ),
            ),
        ];
      },
    );
  }
}
