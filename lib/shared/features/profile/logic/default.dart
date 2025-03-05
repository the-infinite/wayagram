import 'package:wayagram/features/post/model/post_reponse_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wayagram/shared/engagement/provider/post_engagement_monitor.dart';

String removeHashtags(String text) {
  return text.replaceAll(RegExp(r'#\w+'), '').trim();
}

String formatTimeAgo(String dateString) {
  DateTime dateTime = DateTime.parse(dateString); // Convert string to DateTime
  return timeago.format(dateTime); // Convert to "time ago" format
}

void postEngagement(PostEngagementMonitor provider, Post post, int point) {
  //add tag point
  // if (post.hashtags.isNotEmpty) {
  //   for (String tag in post.hashtags) {
  //     provider.addTag(tag, point);
  //   }
  // }

  // add cat point
  if (post.categories != null && post.categories!.isNotEmpty) {
    for (String cat in post.categories!) {
      provider.addCategory(cat, point);
    }
  }
}
