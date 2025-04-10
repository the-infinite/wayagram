import 'package:json_annotation/json_annotation.dart';

enum PromotionServiceType {
  @JsonValue('post')
  post,

  @JsonValue('event')
  event,

  @JsonValue('contest')
  contest,

  @JsonValue('product')
  product,

  @JsonValue('moment')
  moment,

  @JsonValue('page')
  page,

  @JsonValue('group')
  group,

  @JsonValue('donation')
  donation,

  @JsonValue('poll & vote')
  pollAndVote,
}
