import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/features/activity_logs/widget/activity_card_widget.dart';
import 'package:wayagram/features/activity_logs/widget/activity_image_widget.dart';

class ActivityLogItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? image;
  final bool showImage;

  const ActivityLogItem({
    super.key,
    required this.title,
    required this.subtitle,
    this.image,
    this.showImage = false,
  });

  factory ActivityLogItem.fromData({
    required String description,
    required String createdAt,
    required String Function(String) formatDate,
    String? image,
    bool showImage = false,
  }) {
    final dateTimeString = createdAt;
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final formattedDate = formatDate(createdAt);
    final formattedTime = DateFormat.jm().format(dateTime);
    
    return ActivityLogItem(
      title: description,
      subtitle: '$formattedDate, $formattedTime',
      image: image,
      showImage: showImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showImage && image != null) {
      return ActivityImageWidget(
        title: title,
        subTitle: subtitle,
        image: image!,
      );
    }
    
    return ActivityCardWidget(
      title: title,
      subTitle: subtitle,
    );
  }
}