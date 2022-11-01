import 'package:wayagram/generated/json/base/json_field.dart';
import 'package:wayagram/generated/json/all_events_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class AllEventsEntity {

	List<AllEventsData>? data;
	AllEventsMetadata? metadata;
  
  AllEventsEntity();

  factory AllEventsEntity.fromJson(Map<String, dynamic> json) => $AllEventsEntityFromJson(json);

  Map<String, dynamic> toJson() => $AllEventsEntityToJson(this);

	static List<AllEventsEntity> getService(List<dynamic> val) {
		return val.map((e) => AllEventsEntity.fromJson(e)).toList();
	}

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllEventsData {

	String? id;
	@JSONField(name: "ProfileId")
	String? profileId;
	String? eventName;
	String? eventOrganizer;
	String? location;
	String? details;
	String? eventPoster;
	dynamic eventUrl;
	String? eventStart;
	String? eventEnd;
	String? eventTicketEnd;
	@JSONField(name: "no_of_ticket_allowed")
	int? noOfTicketAllowed;
	@JSONField(name: "no_of_ticket_bought")
	int? noOfTicketBought;
	String? millisecCreatedAt;
	String? millisecUpdatedAt;
	bool? isPrivate;
	bool? isPromoted;
	bool? virtual;
	bool? isPaid;
	int? amount;
	String? shareCount;
	bool? isDeleted;
	String? currentState;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
	@JSONField(name: "EventParticipants")
	List<AllEventsDataEventParticipants>? eventParticipants;
	@JSONField(name: "EventLikes")
	List<AllEventsDataEventLikes>? eventLikes;
	@JSONField(name: "max_capacity_reached")
	bool? maxCapacityReached;
	bool? userInterested;
	@JSONField(name: "Engagement")
	AllEventsDataEngagement? engagement;
	@JSONField(name: "Profile")
	AllEventsDataProfile? profile;
  
  AllEventsData();

  factory AllEventsData.fromJson(Map<String, dynamic> json) => $AllEventsDataFromJson(json);

  Map<String, dynamic> toJson() => $AllEventsDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllEventsDataEventParticipants {

	String? id;
	@JSONField(name: "ProfileId")
	String? profileId;
	@JSONField(name: "EventId")
	String? eventId;
	String? going;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
  
  AllEventsDataEventParticipants();

  factory AllEventsDataEventParticipants.fromJson(Map<String, dynamic> json) => $AllEventsDataEventParticipantsFromJson(json);

  Map<String, dynamic> toJson() => $AllEventsDataEventParticipantsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllEventsDataEventLikes {

	String? id;
	@JSONField(name: "ProfileId")
	String? profileId;
	@JSONField(name: "EventId")
	String? eventId;
	bool? like;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
  
  AllEventsDataEventLikes();

  factory AllEventsDataEventLikes.fromJson(Map<String, dynamic> json) => $AllEventsDataEventLikesFromJson(json);

  Map<String, dynamic> toJson() => $AllEventsDataEventLikesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllEventsDataEngagement {

	int? likeCount;
	int? bookmarkCount;
  
  AllEventsDataEngagement();

  factory AllEventsDataEngagement.fromJson(Map<String, dynamic> json) => $AllEventsDataEngagementFromJson(json);

  Map<String, dynamic> toJson() => $AllEventsDataEngagementToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllEventsDataProfile {

	String? id;
	@JSONField(name: "UserId")
	String? userId;
	String? avatar;
	String? coverImage;
	String? bio;
	int? notificationCount;
	int? posts;
	int? groupCount;
	int? pageCount;
	int? followings;
	int? followers;
	String? username;
	String? displayName;
	bool? notPublic;
	bool? deleted;
	bool? simulatedUser;
	bool? isMuted;
	bool? isBan;
	bool? isDisabled;
	bool? isDeactivate;
	String? theme;
	String? fontSize;
	String? phone;
	String? email;
	String? style;
	@JSONField(name: "stream_key")
	String? streamKey;
	dynamic roleId;
	@JSONField(name: "_v")
	String? sV;
	String? createdAt;
	String? updatedAt;
	AllEventsDataProfileConnection? connection;
  
  AllEventsDataProfile();

  factory AllEventsDataProfile.fromJson(Map<String, dynamic> json) => $AllEventsDataProfileFromJson(json);

  Map<String, dynamic> toJson() => $AllEventsDataProfileToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllEventsDataProfileConnection {

	bool? connected;
	bool? isAccepted;
	bool? isPending;
	bool? isDeclined;
	bool? muted;
	bool? blocked;
	bool? following;
	bool? followsYou;
  
  AllEventsDataProfileConnection();

  factory AllEventsDataProfileConnection.fromJson(Map<String, dynamic> json) => $AllEventsDataProfileConnectionFromJson(json);

  Map<String, dynamic> toJson() => $AllEventsDataProfileConnectionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AllEventsMetadata {

	dynamic previousPage;
	int? currentPage;
	dynamic nextPage;
	int? total;
	int? limit;
  
  AllEventsMetadata();

  factory AllEventsMetadata.fromJson(Map<String, dynamic> json) => $AllEventsMetadataFromJson(json);

  Map<String, dynamic> toJson() => $AllEventsMetadataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}