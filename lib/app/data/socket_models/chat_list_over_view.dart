import 'dart:convert';
/// status : true
/// chatOverview : [{"id":"f19834e1-3932-4a11-8195-05903239a094","chatId":"79adbfb1-936c-4084-9918-135f6af8fdfa","loggedInProfileId":null,"senderUserId":null,"receiverUserId":null,"otherId":null,"blockerId":null,"senderIsBlocked":false,"receiverIsBlocked":false,"otherUserName":null,"senderUserName":"","otherDisplayName":null,"otherImageURL":null,"message":"","fileUrl":null,"messageType":null,"deleted":false,"deletedForReciever":false,"deletedForSender":false,"time":"1669852071661","chatIdentifier":null,"fromIdTyping":false,"forwardMessage":false,"toIdTyping":false,"senderArchived":false,"receiverArchived":false,"_v":"RGBA","unreadCount":0,"isGroup":true,"groupId":"31695fdd-809f-446a-81e6-36ec03bd3540","createdAt":"2022-11-30T23:47:51.661Z","updatedAt":"2022-12-01T00:05:15.130Z","members":[{"id":"03d42a32-6389-4f6b-9e6b-5ab062864ddc","groupMemberId":"3ffdc56e-f3a7-4e8c-9bbd-89d82ce9f431","userId":"eabd7795-654c-4a1b-86c4-b6af1a45792e","name":"Boss Sam","email":null,"imageUrl":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1647964704258.jpeg","removed":false,"exited":false,"isAdmin":false,"groupId":"31695fdd-809f-446a-81e6-36ec03bd3540","_v":"RGBA","createdAt":"2022-11-30T23:47:51.668Z","updatedAt":"2022-11-30T23:47:51.668Z"},{"id":"371223fa-1259-41b3-8d97-a6fa1f8716c7","groupMemberId":"7e4ebf53-86e8-41ff-b38d-ec9415db355a","userId":"34ce0ca4-1e39-4217-9bac-a267a8d30f59","name":"Abdurasheed Dada","email":null,"imageUrl":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1647514561334.jpeg","removed":false,"exited":false,"isAdmin":false,"groupId":"31695fdd-809f-446a-81e6-36ec03bd3540","_v":"RGBA","createdAt":"2022-11-30T23:47:51.672Z","updatedAt":"2022-11-30T23:47:51.672Z"},{"id":"217fba88-3332-4006-b575-f2bb1c673758","groupMemberId":"15861442-0947-4029-8a3e-cba9371f2167","userId":"bc63e326-7619-45da-9aab-0876d5e96956","name":"Cephas Waya","email":null,"imageUrl":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1668666554831.octet-stream","removed":false,"exited":false,"isAdmin":false,"groupId":"31695fdd-809f-446a-81e6-36ec03bd3540","_v":"RGBA","createdAt":"2022-11-30T23:47:51.675Z","updatedAt":"2022-11-30T23:47:51.675Z"},{"id":"b143fcb7-ed0b-461d-98b3-75c8e7c237bc","groupMemberId":"4c3f7593-d55b-4d44-a877-91566700e72a","userId":"98622e64-b997-4595-93b1-d516606eb20e","name":"Dare121","email":null,"imageUrl":null,"removed":false,"exited":false,"isAdmin":true,"groupId":"31695fdd-809f-446a-81e6-36ec03bd3540","_v":"RGBA","createdAt":"2022-11-30T23:47:51.678Z","updatedAt":"2022-11-30T23:47:51.678Z"}],"group":{"id":"31695fdd-809f-446a-81e6-36ec03bd3540","groupName":"Hi All","groupImageUrl":"","_v":"RGBA","createdAt":"2022-11-30T23:47:51.638Z","updatedAt":"2022-11-30T23:47:51.638Z"}}]

ChatListOverView chatListOverViewFromJson(String str) => ChatListOverView.fromJson(json.decode(str));
String chatListOverViewToJson(ChatListOverView data) => json.encode(data.toJson());
class ChatListOverView {
  ChatListOverView({
      bool? status,
      List<ChatOverview>? chatOverview,}){
    _status = status;
    _chatOverview = chatOverview;
}

  ChatListOverView.fromJson(dynamic json) {
    _status = json['status'];
    if (json['chatOverview'] != null) {
      _chatOverview = [];
      json['chatOverview'].forEach((v) {
        _chatOverview?.add(ChatOverview.fromJson(v));
      });
    }
  }
  bool? _status;
  List<ChatOverview>? _chatOverview;
ChatListOverView copyWith({  bool? status,
  List<ChatOverview>? chatOverview,
}) => ChatListOverView(  status: status ?? _status,
  chatOverview: chatOverview ?? _chatOverview,
);
  bool? get status => _status;
  List<ChatOverview>? get chatOverview => _chatOverview;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_chatOverview != null) {
      map['chatOverview'] = _chatOverview?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "f19834e1-3932-4a11-8195-05903239a094"
/// chatId : "79adbfb1-936c-4084-9918-135f6af8fdfa"
/// loggedInProfileId : null
/// senderUserId : null
/// receiverUserId : null
/// otherId : null
/// blockerId : null
/// senderIsBlocked : false
/// receiverIsBlocked : false
/// otherUserName : null
/// senderUserName : ""
/// otherDisplayName : null
/// otherImageURL : null
/// message : ""
/// fileUrl : null
/// messageType : null
/// deleted : false
/// deletedForReciever : false
/// deletedForSender : false
/// time : "1669852071661"
/// chatIdentifier : null
/// fromIdTyping : false
/// forwardMessage : false
/// toIdTyping : false
/// senderArchived : false
/// receiverArchived : false
/// _v : "RGBA"
/// unreadCount : 0
/// isGroup : true
/// groupId : "31695fdd-809f-446a-81e6-36ec03bd3540"
/// createdAt : "2022-11-30T23:47:51.661Z"
/// updatedAt : "2022-12-01T00:05:15.130Z"
/// members : [{"id":"03d42a32-6389-4f6b-9e6b-5ab062864ddc","groupMemberId":"3ffdc56e-f3a7-4e8c-9bbd-89d82ce9f431","userId":"eabd7795-654c-4a1b-86c4-b6af1a45792e","name":"Boss Sam","email":null,"imageUrl":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1647964704258.jpeg","removed":false,"exited":false,"isAdmin":false,"groupId":"31695fdd-809f-446a-81e6-36ec03bd3540","_v":"RGBA","createdAt":"2022-11-30T23:47:51.668Z","updatedAt":"2022-11-30T23:47:51.668Z"},{"id":"371223fa-1259-41b3-8d97-a6fa1f8716c7","groupMemberId":"7e4ebf53-86e8-41ff-b38d-ec9415db355a","userId":"34ce0ca4-1e39-4217-9bac-a267a8d30f59","name":"Abdurasheed Dada","email":null,"imageUrl":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1647514561334.jpeg","removed":false,"exited":false,"isAdmin":false,"groupId":"31695fdd-809f-446a-81e6-36ec03bd3540","_v":"RGBA","createdAt":"2022-11-30T23:47:51.672Z","updatedAt":"2022-11-30T23:47:51.672Z"},{"id":"217fba88-3332-4006-b575-f2bb1c673758","groupMemberId":"15861442-0947-4029-8a3e-cba9371f2167","userId":"bc63e326-7619-45da-9aab-0876d5e96956","name":"Cephas Waya","email":null,"imageUrl":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1668666554831.octet-stream","removed":false,"exited":false,"isAdmin":false,"groupId":"31695fdd-809f-446a-81e6-36ec03bd3540","_v":"RGBA","createdAt":"2022-11-30T23:47:51.675Z","updatedAt":"2022-11-30T23:47:51.675Z"},{"id":"b143fcb7-ed0b-461d-98b3-75c8e7c237bc","groupMemberId":"4c3f7593-d55b-4d44-a877-91566700e72a","userId":"98622e64-b997-4595-93b1-d516606eb20e","name":"Dare121","email":null,"imageUrl":null,"removed":false,"exited":false,"isAdmin":true,"groupId":"31695fdd-809f-446a-81e6-36ec03bd3540","_v":"RGBA","createdAt":"2022-11-30T23:47:51.678Z","updatedAt":"2022-11-30T23:47:51.678Z"}]
/// group : {"id":"31695fdd-809f-446a-81e6-36ec03bd3540","groupName":"Hi All","groupImageUrl":"","_v":"RGBA","createdAt":"2022-11-30T23:47:51.638Z","updatedAt":"2022-11-30T23:47:51.638Z"}

ChatOverview chatOverviewFromJson(String str) => ChatOverview.fromJson(json.decode(str));
String chatOverviewToJson(ChatOverview data) => json.encode(data.toJson());
class ChatOverview {
  ChatOverview({
      String? id, 
      String? chatId, 
      dynamic loggedInProfileId, 
      dynamic senderUserId, 
      dynamic receiverUserId, 
      dynamic otherId, 
      dynamic blockerId, 
      bool? senderIsBlocked, 
      bool? receiverIsBlocked, 
      dynamic otherUserName, 
      String? senderUserName, 
      dynamic otherDisplayName, 
      dynamic otherImageURL, 
      String? message, 
      dynamic fileUrl, 
      dynamic messageType, 
      bool? deleted, 
      bool? deletedForReciever, 
      bool? deletedForSender, 
      String? time, 
      dynamic chatIdentifier, 
      bool? fromIdTyping, 
      bool? forwardMessage, 
      bool? toIdTyping, 
      bool? senderArchived, 
      bool? receiverArchived, 
      String? v, 
      num? unreadCount, 
      bool? isGroup, 
      String? groupId, 
      String? createdAt, 
      String? updatedAt, 
      List<Members>? members, 
      Group? group,}){
    _id = id;
    _chatId = chatId;
    _loggedInProfileId = loggedInProfileId;
    _senderUserId = senderUserId;
    _receiverUserId = receiverUserId;
    _otherId = otherId;
    _blockerId = blockerId;
    _senderIsBlocked = senderIsBlocked;
    _receiverIsBlocked = receiverIsBlocked;
    _otherUserName = otherUserName;
    _senderUserName = senderUserName;
    _otherDisplayName = otherDisplayName;
    _otherImageURL = otherImageURL;
    _message = message;
    _fileUrl = fileUrl;
    _messageType = messageType;
    _deleted = deleted;
    _deletedForReciever = deletedForReciever;
    _deletedForSender = deletedForSender;
    _time = time;
    _chatIdentifier = chatIdentifier;
    _fromIdTyping = fromIdTyping;
    _forwardMessage = forwardMessage;
    _toIdTyping = toIdTyping;
    _senderArchived = senderArchived;
    _receiverArchived = receiverArchived;
    _v = v;
    _unreadCount = unreadCount;
    _isGroup = isGroup;
    _groupId = groupId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _members = members;
    _group = group;
}

  ChatOverview.fromJson(dynamic json) {
    _id = json['id'];
    _chatId = json['chatId'];
    _loggedInProfileId = json['loggedInProfileId'];
    _senderUserId = json['senderUserId'];
    _receiverUserId = json['receiverUserId'];
    _otherId = json['otherId'];
    _blockerId = json['blockerId'];
    _senderIsBlocked = json['senderIsBlocked'];
    _receiverIsBlocked = json['receiverIsBlocked'];
    _otherUserName = json['otherUserName'];
    _senderUserName = json['senderUserName'];
    _otherDisplayName = json['otherDisplayName'];
    _otherImageURL = json['otherImageURL'];
    _message = json['message'];
    _fileUrl = json['fileUrl'];
    _messageType = json['messageType'];
    _deleted = json['deleted'];
    _deletedForReciever = json['deletedForReciever'];
    _deletedForSender = json['deletedForSender'];
    _time = json['time'];
    _chatIdentifier = json['chatIdentifier'];
    _fromIdTyping = json['fromIdTyping'];
    _forwardMessage = json['forwardMessage'];
    _toIdTyping = json['toIdTyping'];
    _senderArchived = json['senderArchived'];
    _receiverArchived = json['receiverArchived'];
    _v = json['_v'];
    _unreadCount = json['unreadCount'];
    _isGroup = json['isGroup'];
    _groupId = json['groupId'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    if (json['members'] != null) {
      _members = [];
      json['members'].forEach((v) {
        _members?.add(Members.fromJson(v));
      });
    }
    _group = json['group'] != null ? Group.fromJson(json['group']) : null;
  }
  String? _id;
  String? _chatId;
  dynamic _loggedInProfileId;
  dynamic _senderUserId;
  dynamic _receiverUserId;
  dynamic _otherId;
  dynamic _blockerId;
  bool? _senderIsBlocked;
  bool? _receiverIsBlocked;
  dynamic _otherUserName;
  String? _senderUserName;
  dynamic _otherDisplayName;
  dynamic _otherImageURL;
  String? _message;
  dynamic _fileUrl;
  dynamic _messageType;
  bool? _deleted;
  bool? _deletedForReciever;
  bool? _deletedForSender;
  String? _time;
  dynamic _chatIdentifier;
  bool? _fromIdTyping;
  bool? _forwardMessage;
  bool? _toIdTyping;
  bool? _senderArchived;
  bool? _receiverArchived;
  String? _v;
  num? _unreadCount;
  bool? _isGroup;
  String? _groupId;
  String? _createdAt;
  String? _updatedAt;
  List<Members>? _members;
  Group? _group;
ChatOverview copyWith({  String? id,
  String? chatId,
  dynamic loggedInProfileId,
  dynamic senderUserId,
  dynamic receiverUserId,
  dynamic otherId,
  dynamic blockerId,
  bool? senderIsBlocked,
  bool? receiverIsBlocked,
  dynamic otherUserName,
  String? senderUserName,
  dynamic otherDisplayName,
  dynamic otherImageURL,
  String? message,
  dynamic fileUrl,
  dynamic messageType,
  bool? deleted,
  bool? deletedForReciever,
  bool? deletedForSender,
  String? time,
  dynamic chatIdentifier,
  bool? fromIdTyping,
  bool? forwardMessage,
  bool? toIdTyping,
  bool? senderArchived,
  bool? receiverArchived,
  String? v,
  num? unreadCount,
  bool? isGroup,
  String? groupId,
  String? createdAt,
  String? updatedAt,
  List<Members>? members,
  Group? group,
}) => ChatOverview(  id: id ?? _id,
  chatId: chatId ?? _chatId,
  loggedInProfileId: loggedInProfileId ?? _loggedInProfileId,
  senderUserId: senderUserId ?? _senderUserId,
  receiverUserId: receiverUserId ?? _receiverUserId,
  otherId: otherId ?? _otherId,
  blockerId: blockerId ?? _blockerId,
  senderIsBlocked: senderIsBlocked ?? _senderIsBlocked,
  receiverIsBlocked: receiverIsBlocked ?? _receiverIsBlocked,
  otherUserName: otherUserName ?? _otherUserName,
  senderUserName: senderUserName ?? _senderUserName,
  otherDisplayName: otherDisplayName ?? _otherDisplayName,
  otherImageURL: otherImageURL ?? _otherImageURL,
  message: message ?? _message,
  fileUrl: fileUrl ?? _fileUrl,
  messageType: messageType ?? _messageType,
  deleted: deleted ?? _deleted,
  deletedForReciever: deletedForReciever ?? _deletedForReciever,
  deletedForSender: deletedForSender ?? _deletedForSender,
  time: time ?? _time,
  chatIdentifier: chatIdentifier ?? _chatIdentifier,
  fromIdTyping: fromIdTyping ?? _fromIdTyping,
  forwardMessage: forwardMessage ?? _forwardMessage,
  toIdTyping: toIdTyping ?? _toIdTyping,
  senderArchived: senderArchived ?? _senderArchived,
  receiverArchived: receiverArchived ?? _receiverArchived,
  v: v ?? _v,
  unreadCount: unreadCount ?? _unreadCount,
  isGroup: isGroup ?? _isGroup,
  groupId: groupId ?? _groupId,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  members: members ?? _members,
  group: group ?? _group,
);
  String? get id => _id;
  String? get chatId => _chatId;
  dynamic get loggedInProfileId => _loggedInProfileId;
  dynamic get senderUserId => _senderUserId;
  dynamic get receiverUserId => _receiverUserId;
  dynamic get otherId => _otherId;
  dynamic get blockerId => _blockerId;
  bool? get senderIsBlocked => _senderIsBlocked;
  bool? get receiverIsBlocked => _receiverIsBlocked;
  dynamic get otherUserName => _otherUserName;
  String? get senderUserName => _senderUserName;
  dynamic get otherDisplayName => _otherDisplayName;
  dynamic get otherImageURL => _otherImageURL;
  String? get message => _message;
  dynamic get fileUrl => _fileUrl;
  dynamic get messageType => _messageType;
  bool? get deleted => _deleted;
  bool? get deletedForReciever => _deletedForReciever;
  bool? get deletedForSender => _deletedForSender;
  String? get time => _time;
  dynamic get chatIdentifier => _chatIdentifier;
  bool? get fromIdTyping => _fromIdTyping;
  bool? get forwardMessage => _forwardMessage;
  bool? get toIdTyping => _toIdTyping;
  bool? get senderArchived => _senderArchived;
  bool? get receiverArchived => _receiverArchived;
  String? get v => _v;
  num? get unreadCount => _unreadCount;
  bool? get isGroup => _isGroup;
  String? get groupId => _groupId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<Members>? get members => _members;
  Group? get group => _group;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['chatId'] = _chatId;
    map['loggedInProfileId'] = _loggedInProfileId;
    map['senderUserId'] = _senderUserId;
    map['receiverUserId'] = _receiverUserId;
    map['otherId'] = _otherId;
    map['blockerId'] = _blockerId;
    map['senderIsBlocked'] = _senderIsBlocked;
    map['receiverIsBlocked'] = _receiverIsBlocked;
    map['otherUserName'] = _otherUserName;
    map['senderUserName'] = _senderUserName;
    map['otherDisplayName'] = _otherDisplayName;
    map['otherImageURL'] = _otherImageURL;
    map['message'] = _message;
    map['fileUrl'] = _fileUrl;
    map['messageType'] = _messageType;
    map['deleted'] = _deleted;
    map['deletedForReciever'] = _deletedForReciever;
    map['deletedForSender'] = _deletedForSender;
    map['time'] = _time;
    map['chatIdentifier'] = _chatIdentifier;
    map['fromIdTyping'] = _fromIdTyping;
    map['forwardMessage'] = _forwardMessage;
    map['toIdTyping'] = _toIdTyping;
    map['senderArchived'] = _senderArchived;
    map['receiverArchived'] = _receiverArchived;
    map['_v'] = _v;
    map['unreadCount'] = _unreadCount;
    map['isGroup'] = _isGroup;
    map['groupId'] = _groupId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_members != null) {
      map['members'] = _members?.map((v) => v.toJson()).toList();
    }
    if (_group != null) {
      map['group'] = _group?.toJson();
    }
    return map;
  }

}

/// id : "31695fdd-809f-446a-81e6-36ec03bd3540"
/// groupName : "Hi All"
/// groupImageUrl : ""
/// _v : "RGBA"
/// createdAt : "2022-11-30T23:47:51.638Z"
/// updatedAt : "2022-11-30T23:47:51.638Z"

Group groupFromJson(String str) => Group.fromJson(json.decode(str));
String groupToJson(Group data) => json.encode(data.toJson());
class Group {
  Group({
      String? id, 
      String? groupName, 
      String? groupImageUrl, 
      String? v, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _groupName = groupName;
    _groupImageUrl = groupImageUrl;
    _v = v;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Group.fromJson(dynamic json) {
    _id = json['id'];
    _groupName = json['groupName'];
    _groupImageUrl = json['groupImageUrl'];
    _v = json['_v'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _groupName;
  String? _groupImageUrl;
  String? _v;
  String? _createdAt;
  String? _updatedAt;
Group copyWith({  String? id,
  String? groupName,
  String? groupImageUrl,
  String? v,
  String? createdAt,
  String? updatedAt,
}) => Group(  id: id ?? _id,
  groupName: groupName ?? _groupName,
  groupImageUrl: groupImageUrl ?? _groupImageUrl,
  v: v ?? _v,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get groupName => _groupName;
  String? get groupImageUrl => _groupImageUrl;
  String? get v => _v;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['groupName'] = _groupName;
    map['groupImageUrl'] = _groupImageUrl;
    map['_v'] = _v;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}

/// id : "03d42a32-6389-4f6b-9e6b-5ab062864ddc"
/// groupMemberId : "3ffdc56e-f3a7-4e8c-9bbd-89d82ce9f431"
/// userId : "eabd7795-654c-4a1b-86c4-b6af1a45792e"
/// name : "Boss Sam"
/// email : null
/// imageUrl : "https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1647964704258.jpeg"
/// removed : false
/// exited : false
/// isAdmin : false
/// groupId : "31695fdd-809f-446a-81e6-36ec03bd3540"
/// _v : "RGBA"
/// createdAt : "2022-11-30T23:47:51.668Z"
/// updatedAt : "2022-11-30T23:47:51.668Z"

Members membersFromJson(String str) => Members.fromJson(json.decode(str));
String membersToJson(Members data) => json.encode(data.toJson());
class Members {
  Members({
      String? id, 
      String? groupMemberId, 
      String? userId, 
      String? name, 
      dynamic email, 
      String? imageUrl, 
      bool? removed, 
      bool? exited, 
      bool? isAdmin, 
      String? groupId, 
      String? v, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _groupMemberId = groupMemberId;
    _userId = userId;
    _name = name;
    _email = email;
    _imageUrl = imageUrl;
    _removed = removed;
    _exited = exited;
    _isAdmin = isAdmin;
    _groupId = groupId;
    _v = v;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Members.fromJson(dynamic json) {
    _id = json['id'];
    _groupMemberId = json['groupMemberId'];
    _userId = json['userId'];
    _name = json['name'];
    _email = json['email'];
    _imageUrl = json['imageUrl'];
    _removed = json['removed'];
    _exited = json['exited'];
    _isAdmin = json['isAdmin'];
    _groupId = json['groupId'];
    _v = json['_v'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _groupMemberId;
  String? _userId;
  String? _name;
  dynamic _email;
  String? _imageUrl;
  bool? _removed;
  bool? _exited;
  bool? _isAdmin;
  String? _groupId;
  String? _v;
  String? _createdAt;
  String? _updatedAt;
Members copyWith({  String? id,
  String? groupMemberId,
  String? userId,
  String? name,
  dynamic email,
  String? imageUrl,
  bool? removed,
  bool? exited,
  bool? isAdmin,
  String? groupId,
  String? v,
  String? createdAt,
  String? updatedAt,
}) => Members(  id: id ?? _id,
  groupMemberId: groupMemberId ?? _groupMemberId,
  userId: userId ?? _userId,
  name: name ?? _name,
  email: email ?? _email,
  imageUrl: imageUrl ?? _imageUrl,
  removed: removed ?? _removed,
  exited: exited ?? _exited,
  isAdmin: isAdmin ?? _isAdmin,
  groupId: groupId ?? _groupId,
  v: v ?? _v,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get groupMemberId => _groupMemberId;
  String? get userId => _userId;
  String? get name => _name;
  dynamic get email => _email;
  String? get imageUrl => _imageUrl;
  bool? get removed => _removed;
  bool? get exited => _exited;
  bool? get isAdmin => _isAdmin;
  String? get groupId => _groupId;
  String? get v => _v;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['groupMemberId'] = _groupMemberId;
    map['userId'] = _userId;
    map['name'] = _name;
    map['email'] = _email;
    map['imageUrl'] = _imageUrl;
    map['removed'] = _removed;
    map['exited'] = _exited;
    map['isAdmin'] = _isAdmin;
    map['groupId'] = _groupId;
    map['_v'] = _v;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}