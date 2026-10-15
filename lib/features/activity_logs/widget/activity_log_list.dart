import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/widget/activity_log_item.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';

class ActivityLogList<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T) getDescription;
  final String Function(T) getCreatedAt;
  final String Function(String) formatDate;
  final String emptyStateText;
  final String? Function(T)? getImage;
  final bool showImages;

  const ActivityLogList({
    super.key,
    required this.items,
    required this.getDescription,
    required this.getCreatedAt,
    required this.formatDate,
    required this.emptyStateText,
    this.getImage,
    this.showImages = false,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return ActivityLogsEmptyState(text: emptyStateText);
    }

    // Build the list as a column of widgets without nested scrolling
    List<Widget> children = [];
    
    // Add first date header if items exist
    if (items.isNotEmpty) {
      children.add(
        Padding(
          padding: EdgeInsets.only(top: 30.h),
          child: Text(
            WayaDateHelper.getDailyTimestamp(
              DateTime.parse(getCreatedAt(items.first)),
            ),
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: WayaConstants.fontFamily,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      );
    }

    // Add items with date separators
    for (int index = 0; index < items.length; index++) {
      final item = items[index];
      
      // Add date separator if needed (not for last item)
      if (index < items.length - 1) {
        final current = items[index];
        final next = items[index + 1];
        final currentDate = DateTime.parse(getCreatedAt(current));
        final nextDate = DateTime.parse(getCreatedAt(next));

        if (!WayaDateHelper.isSameDay(currentDate, nextDate)) {
          children.add(ActivityLogItem.fromData(
            description: getDescription(item),
            createdAt: getCreatedAt(item),
            formatDate: formatDate,
            image: getImage?.call(item),
            showImage: showImages,
          ));
          
          children.add(
            Padding(
              padding: EdgeInsets.only(top: 30.h),
              child: Text(
                WayaDateHelper.getDailyTimestamp(nextDate),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: WayaConstants.fontFamily,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          );
          continue;
        }
      }
      
      // Add the item
      children.add(ActivityLogItem.fromData(
        description: getDescription(item),
        createdAt: getCreatedAt(item),
        formatDate: formatDate,
        image: getImage?.call(item),
        showImage: showImages,
      ));
    }

    // Add bottom padding
    children.add(SizedBox(height: 20.h));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}