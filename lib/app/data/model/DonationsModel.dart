import 'dart:convert';
/// id : "b7e961ca-4220-47ad-adbd-079e77ab6dd1"
/// ProfileId : "bc63e326-7619-45da-9aab-0876d5e96956"
/// PostId : "b55093c6-8a91-4510-bc3f-0c938742d440"
/// title : "School Fees"
/// orgName : "Cephas Arowolo"
/// description : "Help Me go to school"
/// ownerDescription : "Im good"
/// impact : "School momey"
/// amountJustification : "School "
/// estimatedAmount : 200000
/// currentAmount : 0
/// minimumAmount : 500
/// shareCount : "0"
/// imageUrl : null
/// isClosed : false
/// currentState : "activate"
/// isDeleted : false
/// displayTotalDonation : false
/// displayNumberOfDonors : false
/// donationExpiresAt : "1670029200000"
/// millisecCreatedAt : "1669304239718"
/// millisecUpdatedAt : "1669304239718"
/// _v : "RGBA"
/// isPrivate : false
/// createdAt : "2022-11-28T01:19:31.356Z"
/// updatedAt : "2022-11-28T01:19:35.511Z"
/// DonationImages : [{"id":"ddfc6c41-1938-431e-b67d-05666fe1295c","DonationId":"b7e961ca-4220-47ad-adbd-079e77ab6dd1","imageUrl":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1669598375199.png","_v":"RGBA","createdAt":"2022-11-28T01:19:35.512Z","updatedAt":"2022-11-28T01:19:35.512Z"}]
/// Donate : []
/// amountRaised : 0
/// totalDonors : 0
/// userDonated : false

DonationsModel donationsModelFromJson(String str) => DonationsModel.fromJson(json.decode(str));
String donationsModelToJson(DonationsModel data) => json.encode(data.toJson());
class DonationsModel {
  DonationsModel({
      String? id, 
      String? profileId, 
      String? postId, 
      String? title, 
      String? orgName, 
      String? description, 
      String? ownerDescription, 
      String? impact, 
      String? amountJustification, 
      num? estimatedAmount, 
      num? currentAmount, 
      num? minimumAmount, 
      String? shareCount, 
      dynamic imageUrl, 
      bool? isClosed, 
      String? currentState, 
      bool? isDeleted, 
      bool? displayTotalDonation, 
      bool? displayNumberOfDonors, 
      String? donationExpiresAt, 
      String? millisecCreatedAt, 
      String? millisecUpdatedAt, 
      String? v, 
      bool? isPrivate, 
      String? createdAt, 
      String? updatedAt, 
      List<DonationImages>? donationImages, 
      List<dynamic>? donate, 
      num? amountRaised, 
      num? totalDonors, 
      bool? userDonated,}){
    _id = id;
    _profileId = profileId;
    _postId = postId;
    _title = title;
    _orgName = orgName;
    _description = description;
    _ownerDescription = ownerDescription;
    _impact = impact;
    _amountJustification = amountJustification;
    _estimatedAmount = estimatedAmount;
    _currentAmount = currentAmount;
    _minimumAmount = minimumAmount;
    _shareCount = shareCount;
    _imageUrl = imageUrl;
    _isClosed = isClosed;
    _currentState = currentState;
    _isDeleted = isDeleted;
    _displayTotalDonation = displayTotalDonation;
    _displayNumberOfDonors = displayNumberOfDonors;
    _donationExpiresAt = donationExpiresAt;
    _millisecCreatedAt = millisecCreatedAt;
    _millisecUpdatedAt = millisecUpdatedAt;
    _v = v;
    _isPrivate = isPrivate;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _donationImages = donationImages;
    _donate = donate;
    _amountRaised = amountRaised;
    _totalDonors = totalDonors;
    _userDonated = userDonated;
}

  DonationsModel.fromJson(dynamic json) {
    _id = json['id'];
    _profileId = json['ProfileId'];
    _postId = json['PostId'];
    _title = json['title'];
    _orgName = json['orgName'];
    _description = json['description'];
    _ownerDescription = json['ownerDescription'];
    _impact = json['impact'];
    _amountJustification = json['amountJustification'];
    _estimatedAmount = json['estimatedAmount'];
    _currentAmount = json['currentAmount'];
    _minimumAmount = json['minimumAmount'];
    _shareCount = json['shareCount'];
    _imageUrl = json['imageUrl'];
    _isClosed = json['isClosed'];
    _currentState = json['currentState'];
    _isDeleted = json['isDeleted'];
    _displayTotalDonation = json['displayTotalDonation'];
    _displayNumberOfDonors = json['displayNumberOfDonors'];
    _donationExpiresAt = json['donationExpiresAt'];
    _millisecCreatedAt = json['millisecCreatedAt'];
    _millisecUpdatedAt = json['millisecUpdatedAt'];
    _v = json['_v'];
    _isPrivate = json['isPrivate'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    if (json['DonationImages'] != null) {
      _donationImages = [];
      json['DonationImages'].forEach((v) {
        _donationImages?.add(DonationImages.fromJson(v));
      });
    }
    if (json['Donate'] != null) {
      _donate = [];
      json['Donate'].forEach((v) {
       // _donate?.add(Dynamic.fromJson(v));
      });
    }
    _amountRaised = json['amountRaised'];
    _totalDonors = json['totalDonors'];
    _userDonated = json['userDonated'];
  }
  String? _id;
  String? _profileId;
  String? _postId;
  String? _title;
  String? _orgName;
  String? _description;
  String? _ownerDescription;
  String? _impact;
  String? _amountJustification;
  num? _estimatedAmount;
  num? _currentAmount;
  num? _minimumAmount;
  String? _shareCount;
  dynamic _imageUrl;
  bool? _isClosed;
  String? _currentState;
  bool? _isDeleted;
  bool? _displayTotalDonation;
  bool? _displayNumberOfDonors;
  String? _donationExpiresAt;
  String? _millisecCreatedAt;
  String? _millisecUpdatedAt;
  String? _v;
  bool? _isPrivate;
  String? _createdAt;
  String? _updatedAt;
  List<DonationImages>? _donationImages;
  List<dynamic>? _donate;
  num? _amountRaised;
  num? _totalDonors;
  bool? _userDonated;
DonationsModel copyWith({  String? id,
  String? profileId,
  String? postId,
  String? title,
  String? orgName,
  String? description,
  String? ownerDescription,
  String? impact,
  String? amountJustification,
  num? estimatedAmount,
  num? currentAmount,
  num? minimumAmount,
  String? shareCount,
  dynamic imageUrl,
  bool? isClosed,
  String? currentState,
  bool? isDeleted,
  bool? displayTotalDonation,
  bool? displayNumberOfDonors,
  String? donationExpiresAt,
  String? millisecCreatedAt,
  String? millisecUpdatedAt,
  String? v,
  bool? isPrivate,
  String? createdAt,
  String? updatedAt,
  List<DonationImages>? donationImages,
  List<dynamic>? donate,
  num? amountRaised,
  num? totalDonors,
  bool? userDonated,
}) => DonationsModel(  id: id ?? _id,
  profileId: profileId ?? _profileId,
  postId: postId ?? _postId,
  title: title ?? _title,
  orgName: orgName ?? _orgName,
  description: description ?? _description,
  ownerDescription: ownerDescription ?? _ownerDescription,
  impact: impact ?? _impact,
  amountJustification: amountJustification ?? _amountJustification,
  estimatedAmount: estimatedAmount ?? _estimatedAmount,
  currentAmount: currentAmount ?? _currentAmount,
  minimumAmount: minimumAmount ?? _minimumAmount,
  shareCount: shareCount ?? _shareCount,
  imageUrl: imageUrl ?? _imageUrl,
  isClosed: isClosed ?? _isClosed,
  currentState: currentState ?? _currentState,
  isDeleted: isDeleted ?? _isDeleted,
  displayTotalDonation: displayTotalDonation ?? _displayTotalDonation,
  displayNumberOfDonors: displayNumberOfDonors ?? _displayNumberOfDonors,
  donationExpiresAt: donationExpiresAt ?? _donationExpiresAt,
  millisecCreatedAt: millisecCreatedAt ?? _millisecCreatedAt,
  millisecUpdatedAt: millisecUpdatedAt ?? _millisecUpdatedAt,
  v: v ?? _v,
  isPrivate: isPrivate ?? _isPrivate,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  donationImages: donationImages ?? _donationImages,
  donate: donate ?? _donate,
  amountRaised: amountRaised ?? _amountRaised,
  totalDonors: totalDonors ?? _totalDonors,
  userDonated: userDonated ?? _userDonated,
);
  String? get id => _id;
  String? get profileId => _profileId;
  String? get postId => _postId;
  String? get title => _title;
  String? get orgName => _orgName;
  String? get description => _description;
  String? get ownerDescription => _ownerDescription;
  String? get impact => _impact;
  String? get amountJustification => _amountJustification;
  num? get estimatedAmount => _estimatedAmount;
  num? get currentAmount => _currentAmount;
  num? get minimumAmount => _minimumAmount;
  String? get shareCount => _shareCount;
  dynamic get imageUrl => _imageUrl;
  bool? get isClosed => _isClosed;
  String? get currentState => _currentState;
  bool? get isDeleted => _isDeleted;
  bool? get displayTotalDonation => _displayTotalDonation;
  bool? get displayNumberOfDonors => _displayNumberOfDonors;
  String? get donationExpiresAt => _donationExpiresAt;
  String? get millisecCreatedAt => _millisecCreatedAt;
  String? get millisecUpdatedAt => _millisecUpdatedAt;
  String? get v => _v;
  bool? get isPrivate => _isPrivate;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<DonationImages>? get donationImages => _donationImages;
  List<dynamic>? get donate => _donate;
  num? get amountRaised => _amountRaised;
  num? get totalDonors => _totalDonors;
  bool? get userDonated => _userDonated;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['ProfileId'] = _profileId;
    map['PostId'] = _postId;
    map['title'] = _title;
    map['orgName'] = _orgName;
    map['description'] = _description;
    map['ownerDescription'] = _ownerDescription;
    map['impact'] = _impact;
    map['amountJustification'] = _amountJustification;
    map['estimatedAmount'] = _estimatedAmount;
    map['currentAmount'] = _currentAmount;
    map['minimumAmount'] = _minimumAmount;
    map['shareCount'] = _shareCount;
    map['imageUrl'] = _imageUrl;
    map['isClosed'] = _isClosed;
    map['currentState'] = _currentState;
    map['isDeleted'] = _isDeleted;
    map['displayTotalDonation'] = _displayTotalDonation;
    map['displayNumberOfDonors'] = _displayNumberOfDonors;
    map['donationExpiresAt'] = _donationExpiresAt;
    map['millisecCreatedAt'] = _millisecCreatedAt;
    map['millisecUpdatedAt'] = _millisecUpdatedAt;
    map['_v'] = _v;
    map['isPrivate'] = _isPrivate;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_donationImages != null) {
      map['DonationImages'] = _donationImages?.map((v) => v.toJson()).toList();
    }
    if (_donate != null) {
      map['Donate'] = _donate?.map((v) => v.toJson()).toList();
    }
    map['amountRaised'] = _amountRaised;
    map['totalDonors'] = _totalDonors;
    map['userDonated'] = _userDonated;
    return map;
  }

}

/// id : "ddfc6c41-1938-431e-b67d-05666fe1295c"
/// DonationId : "b7e961ca-4220-47ad-adbd-079e77ab6dd1"
/// imageUrl : "https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1669598375199.png"
/// _v : "RGBA"
/// createdAt : "2022-11-28T01:19:35.512Z"
/// updatedAt : "2022-11-28T01:19:35.512Z"

DonationImages donationImagesFromJson(String str) => DonationImages.fromJson(json.decode(str));
String donationImagesToJson(DonationImages data) => json.encode(data.toJson());
class DonationImages {
  DonationImages({
      String? id, 
      String? donationId, 
      String? imageUrl, 
      String? v, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _donationId = donationId;
    _imageUrl = imageUrl;
    _v = v;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  DonationImages.fromJson(dynamic json) {
    _id = json['id'];
    _donationId = json['DonationId'];
    _imageUrl = json['imageUrl'];
    _v = json['_v'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _donationId;
  String? _imageUrl;
  String? _v;
  String? _createdAt;
  String? _updatedAt;
DonationImages copyWith({  String? id,
  String? donationId,
  String? imageUrl,
  String? v,
  String? createdAt,
  String? updatedAt,
}) => DonationImages(  id: id ?? _id,
  donationId: donationId ?? _donationId,
  imageUrl: imageUrl ?? _imageUrl,
  v: v ?? _v,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get donationId => _donationId;
  String? get imageUrl => _imageUrl;
  String? get v => _v;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['DonationId'] = _donationId;
    map['imageUrl'] = _imageUrl;
    map['_v'] = _v;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}