import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/event/widgets/about_event.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/widgets/inventory_widget.dart';

class EventDetailWidget extends ConsumerStatefulWidget {
  const EventDetailWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EventDetailWidgetState();
}

class _EventDetailWidgetState extends ConsumerState<EventDetailWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Expanded(
     
        child: ListView(
      //crossAxisAlignment: CrossAxisAlignment.start,
     
      children: [
        const Gap(15),
        GridView(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 0,
              childAspectRatio: 1.8,
              crossAxisSpacing: 8),
          children: [
            InventoryWidget(
                metrics: "0",
                color: Color(0xffE7F6EC),
                title: "Total Attendees"),
            InventoryWidget(
                metrics: "0", color: Color(0xffFEF6E7), title: "Total Revenue")
          ],
        ),
        const Gap(15),
        AboutEvent(title: 'Title of Event', content: "Monshoot Techchabal"),
        const Gap(15),
        AboutEvent(title: 'Organizer Name', content: "CNT"),
        const Gap(15),
        AboutEvent(title: "Event Description", content: "Description"),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutEvent(title: 'Event Location', content: "Physical"),
            ),
            Expanded(
              child:
                  AboutEvent(title: 'Event Address', content: "Ikeja, Lagos"),
            ),
          ],
        ),
        const Gap(30),
        Text(
          "Event Date & Time",
          style: wayaTheme.textTheme.hintStyle,
        ),
        const Gap(30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child:
                  AboutEvent(title: 'Start Date', content: "22nd October 2024"),
            ),
            Expanded(
              child: AboutEvent(title: 'Start Time', content: "08:00AM"),
            ),
          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child:
                  AboutEvent(title: 'EnsdDate', content: "22nd October 2024"),
            ),
            Expanded(
              child: AboutEvent(title: 'End Time', content: "08:00AM"),
            ),
          ],
        ),
        const Gap(30),
        Text(
          "Configure Ticket",
          style: wayaTheme.textTheme.hintStyle,
        ),
        const Gap(30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutEvent(title: 'Event Type', content: "Paid"),
            ),
            Expanded(
              child: AboutEvent(title: 'Event Fee', content: "N5,000"),
            ),
          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child:
                  AboutEvent(title: 'Maximum Capacity', content: "Unlimited"),
            ),
            Expanded(
              child: AboutEvent(title: 'Privacy Settings', content: "Public"),
            ),
          ],
        ),
       Gap(context.height * 0.5)
      ],
    ));
  }
}
