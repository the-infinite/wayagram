import 'dart:convert';
/// status : true
/// previousChat : [{"id":"a4634ef9-06ba-4d38-8159-53598d4c9da1","replyMessageId":"0ba66f86-6b7b-413a-8511-7382bd4e3765","frontEndId":"639_1669937738443","senderId":"bc63e326-7619-45da-9aab-0876d5e96956","senderUserId":"639","receiverId":"492bbb2c-4fc2-4ef4-9c65-ca449575e2b7","receiverUserId":"419","senderUserName":"Arowolo","receiverUserName":"Ogoo","senderImageURl":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1668666554831.octet-stream","receiverImageURL":"https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1651932201670.jpeg","chatIdentifier":"639:419","message":"Hmmm","messageType":"textMessage","fileUrl":"null","forwardMessage":false,"deleted":false,"deletedForSender":false,"deletedForReciever":false,"time":"1669937739812","read":false,"_v":"RGBA","isGroup":false,"groupId":"","createdAt":"2022-12-01T23:35:39.812Z","updatedAt":"2022-12-01T23:35:39.812Z"}]

PreviousChatModel previousChatModelFromJson(String str) => PreviousChatModel.fromJson(json.decode(str));
String previousChatModelToJson(PreviousChatModel data) => json.encode(data.toJson());
class PreviousChatModel {
  PreviousChatModel({
      bool? status, 
      List<PreviousChat>? previousChat,}){
    _status = status;
    _previousChat = previousChat;
}

  PreviousChatModel.fromJson(dynamic json) {
    _status = json['status'];
    if (json['previousChat'] != null) {
      _previousChat = [];
      json['previousChat'].forEach((v) {
        _previousChat?.add(PreviousChat.fromJson(v));
      });
    }
  }
  bool? _status;
  List<PreviousChat>? _previousChat;
PreviousChatModel copyWith({  bool? status,
  List<PreviousChat>? previousChat,
}) => PreviousChatModel(  status: status ?? _status,
  previousChat: previousChat ?? _previousChat,
);
  bool? get status => _status;
  List<PreviousChat>? get previousChat => _previousChat;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_previousChat != null) {
      map['previousChat'] = _previousChat?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "a4634ef9-06ba-4d38-8159-53598d4c9da1"
/// replyMessageId : "0ba66f86-6b7b-413a-8511-7382bd4e3765"
/// frontEndId : "639_1669937738443"
/// senderId : "bc63e326-7619-45da-9aab-0876d5e96956"
/// senderUserId : "639"
/// receiverId : "492bbb2c-4fc2-4ef4-9c65-ca449575e2b7"
/// receiverUserId : "419"
/// senderUserName : "Arowolo"
/// receiverUserName : "Ogoo"
/// senderImageURl : "https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1668666554831.octet-stream"
/// receiverImageURL : "https://social-waya-bucket.s3.eu-west-1.amazonaws.com/bts-1651932201670.jpeg"
/// chatIdentifier : "639:419"
/// message : "Hmmm"
/// messageType : "textMessage"
/// fileUrl : "null"
/// forwardMessage : false
/// deleted : false
/// deletedForSender : false
/// deletedForReciever : false
/// time : "1669937739812"
/// read : false
/// _v : "RGBA"
/// isGroup : false
/// groupId : ""
/// createdAt : "2022-12-01T23:35:39.812Z"
/// updatedAt : "2022-12-01T23:35:39.812Z"

PreviousChat previousChatFromJson(String str) => PreviousChat.fromJson(json.decode(str));
String previousChatToJson(PreviousChat data) => json.encode(data.toJson());
class PreviousChat {
  PreviousChat({
      String? id,
      String? replyMessageId, 
      String? frontEndId, 
      String? senderId, 
      String? senderUserId, 
      String? receiverId, 
      String? receiverUserId, 
      String? senderUserName, 
      String? receiverUserName, 
      String? senderImageURl, 
      String? receiverImageURL, 
      String? chatIdentifier, 
      String? message, 
      String? messageType, 
      String? fileUrl, 
      bool? forwardMessage, 
      bool? deleted, 
      bool? deletedForSender, 
      bool? deletedForReciever, 
      String? time, 
      bool? read, 
      String? v, 
      bool? isGroup, 
      String? groupId, 
      String? createdAt, 
      String? updatedAt,
      this.sending = false,
  }){
    _id = id;
    _replyMessageId = replyMessageId;
    _frontEndId = frontEndId;
    _senderId = senderId;
    _senderUserId = senderUserId;
    _receiverId = receiverId;
    _receiverUserId = receiverUserId;
    _senderUserName = senderUserName;
    _receiverUserName = receiverUserName;
    _senderImageURl = senderImageURl;
    _receiverImageURL = receiverImageURL;
    _chatIdentifier = chatIdentifier;
    _message = message;
    _messageType = messageType;
    _fileUrl = fileUrl;
    _forwardMessage = forwardMessage;
    _deleted = deleted;
    _deletedForSender = deletedForSender;
    _deletedForReciever = deletedForReciever;
    _time = time;
    _read = read;
    _v = v;
    _isGroup = isGroup;
    _groupId = groupId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  PreviousChat.fromJson(dynamic json) {
    _id = json['id'];
    _replyMessageId = json['replyMessageId'];
    _frontEndId = json['frontEndId'];
    _senderId = json['senderId'];
    _senderUserId = json['senderUserId'];
    _receiverId = json['receiverId'];
    _receiverUserId = json['receiverUserId'];
    _senderUserName = json['senderUserName'];
    _receiverUserName = json['receiverUserName'];
    _senderImageURl = json['senderImageURl'];
    _receiverImageURL = json['receiverImageURL'];
    _chatIdentifier = json['chatIdentifier'];
    _message = json['message'];
    _messageType = json['messageType'];
    _fileUrl = json['fileUrl'];
    _forwardMessage = json['forwardMessage'];
    _deleted = json['deleted'];
    _deletedForSender = json['deletedForSender'];
    _deletedForReciever = json['deletedForReciever'];
    _time = json['time'];
    _read = json['read'];
    _v = json['_v'];
    _isGroup = json['isGroup'];
    _groupId = json['groupId'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    sending = false;
  }

  bool? sending;
  String? _id;
  String? _replyMessageId;
  String? _frontEndId;
  String? _senderId;
  String? _senderUserId;
  String? _receiverId;
  String? _receiverUserId;
  String? _senderUserName;
  String? _receiverUserName;
  String? _senderImageURl;
  String? _receiverImageURL;
  String? _chatIdentifier;
  String? _message;
  String? _messageType;
  String? _fileUrl;
  bool? _forwardMessage;
  bool? _deleted;
  bool? _deletedForSender;
  bool? _deletedForReciever;
  String? _time;
  bool? _read;
  String? _v;
  bool? _isGroup;
  String? _groupId;
  String? _createdAt;
  String? _updatedAt;
PreviousChat copyWith({  String? id,
  String? replyMessageId,
  String? frontEndId,
  String? senderId,
  String? senderUserId,
  String? receiverId,
  String? receiverUserId,
  String? senderUserName,
  String? receiverUserName,
  String? senderImageURl,
  String? receiverImageURL,
  String? chatIdentifier,
  String? message,
  String? messageType,
  String? fileUrl,
  bool? forwardMessage,
  bool? deleted,
  bool? deletedForSender,
  bool? deletedForReciever,
  String? time,
  bool? read,
  String? v,
  bool? isGroup,
  String? groupId,
  String? createdAt,
  String? updatedAt,
  bool? sending
}) => PreviousChat(  id: id ?? _id,
  replyMessageId: replyMessageId ?? _replyMessageId,
  frontEndId: frontEndId ?? _frontEndId,
  senderId: senderId ?? _senderId,
  senderUserId: senderUserId ?? _senderUserId,
  receiverId: receiverId ?? _receiverId,
  receiverUserId: receiverUserId ?? _receiverUserId,
  senderUserName: senderUserName ?? _senderUserName,
  receiverUserName: receiverUserName ?? _receiverUserName,
  senderImageURl: senderImageURl ?? _senderImageURl,
  receiverImageURL: receiverImageURL ?? _receiverImageURL,
  chatIdentifier: chatIdentifier ?? _chatIdentifier,
  message: message ?? _message,
  messageType: messageType ?? _messageType,
  fileUrl: fileUrl ?? _fileUrl,
  forwardMessage: forwardMessage ?? _forwardMessage,
  deleted: deleted ?? _deleted,
  deletedForSender: deletedForSender ?? _deletedForSender,
  deletedForReciever: deletedForReciever ?? _deletedForReciever,
  time: time ?? _time,
  read: read ?? _read,
  v: v ?? _v,
  isGroup: isGroup ?? _isGroup,
  groupId: groupId ?? _groupId,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  sending: sending
);
  String? get id => _id;
  String? get replyMessageId => _replyMessageId;
  String? get frontEndId => _frontEndId;
  String? get senderId => _senderId;
  String? get senderUserId => _senderUserId;
  String? get receiverId => _receiverId;
  String? get receiverUserId => _receiverUserId;
  String? get senderUserName => _senderUserName;
  String? get receiverUserName => _receiverUserName;
  String? get senderImageURl => _senderImageURl;
  String? get receiverImageURL => _receiverImageURL;
  String? get chatIdentifier => _chatIdentifier;
  String? get message => _message;
  String? get messageType => _messageType;
  String? get fileUrl => _fileUrl;
  bool? get forwardMessage => _forwardMessage;
  bool? get deleted => _deleted;
  bool? get deletedForSender => _deletedForSender;
  bool? get deletedForReciever => _deletedForReciever;
  String? get time => _time;
  bool? get read => _read;
  String? get v => _v;
  bool? get isGroup => _isGroup;
  String? get groupId => _groupId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['replyMessageId'] = _replyMessageId;
    map['frontEndId'] = _frontEndId;
    map['senderId'] = _senderId;
    map['senderUserId'] = _senderUserId;
    map['receiverId'] = _receiverId;
    map['receiverUserId'] = _receiverUserId;
    map['senderUserName'] = _senderUserName;
    map['receiverUserName'] = _receiverUserName;
    map['senderImageURl'] = _senderImageURl;
    map['receiverImageURL'] = _receiverImageURL;
    map['chatIdentifier'] = _chatIdentifier;
    map['message'] = _message;
    map['messageType'] = _messageType;
    map['fileUrl'] = _fileUrl;
    map['forwardMessage'] = _forwardMessage;
    map['deleted'] = _deleted;
    map['deletedForSender'] = _deletedForSender;
    map['deletedForReciever'] = _deletedForReciever;
    map['time'] = _time;
    map['read'] = _read;
    map['_v'] = _v;
    map['isGroup'] = _isGroup;
    map['groupId'] = _groupId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['sending'] = sending;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreviousChat &&
          runtimeType == other.runtimeType &&
          _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}