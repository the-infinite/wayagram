import 'dart:convert';
/// status : true
/// message : "Data saved"
/// frontEndId : "35f58cbb-1453-4e75-b3a6-cc8c92342fab"
/// id : "0929774b-81ba-461c-82cf-32db67cb94e5"
/// messageType : "textMessage"

SendMessageResponse sendMessageResponseFromJson(String str) => SendMessageResponse.fromJson(json.decode(str));
String sendMessageResponseToJson(SendMessageResponse data) => json.encode(data.toJson());
class SendMessageResponse {
  SendMessageResponse({
      bool? status, 
      String? message, 
      String? frontEndId, 
      String? id, 
      String? messageType,}){
    _status = status;
    _message = message;
    _frontEndId = frontEndId;
    _id = id;
    _messageType = messageType;
}

  SendMessageResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _frontEndId = json['frontEndId'];
    _id = json['id'];
    _messageType = json['messageType'];
  }
  bool? _status;
  String? _message;
  String? _frontEndId;
  String? _id;
  String? _messageType;
SendMessageResponse copyWith({  bool? status,
  String? message,
  String? frontEndId,
  String? id,
  String? messageType,
}) => SendMessageResponse(  status: status ?? _status,
  message: message ?? _message,
  frontEndId: frontEndId ?? _frontEndId,
  id: id ?? _id,
  messageType: messageType ?? _messageType,
);
  bool? get status => _status;
  String? get message => _message;
  String? get frontEndId => _frontEndId;
  String? get id => _id;
  String? get messageType => _messageType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['frontEndId'] = _frontEndId;
    map['id'] = _id;
    map['messageType'] = _messageType;
    return map;
  }

}