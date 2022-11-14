import 'ContactList.dart';

class ContactsToUpload {
  ContactsToUpload({
      this.contactList,});

  ContactsToUpload.fromJson(dynamic json) {
    if (json['contactList'] != null) {
      contactList = [];
      json['contactList'].forEach((v) {
        contactList?.add(ContactList.fromJson(v));
      });
    }
  }
  List<ContactList>? contactList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (contactList != null) {
      map['contactList'] = contactList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}