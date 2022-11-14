class SearchPeopleResponse {
  SearchPeopleResponse({
      this.id, 
      this.firstName, 
      this.surname, 
      this.email, 
      this.phoneNumber, 
      this.userId,});

  SearchPeopleResponse.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    surname = json['surname'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    userId = json['userId'];
  }
  String? id;
  String? firstName;
  String? surname;
  String? email;
  String? phoneNumber;
  String? userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['surname'] = surname;
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    map['userId'] = userId;
    return map;
  }

  static List<SearchPeopleResponse> listFromJson(List? list) {
    if (list == null) return [];
    if (list.isEmpty) return [];
    return list.map((item) => SearchPeopleResponse.fromJson(item)).toList();
  }

  @override
  bool operator == (Object other){
    var obj = other as SearchPeopleResponse;
    var isSamePhoneNumber = (other.phoneNumber == phoneNumber) && (other.phoneNumber != null) && (phoneNumber != null);
    var isSameEmail = (other.email == email) && (other.email != null) && (email != null);
    return isSamePhoneNumber || isSameEmail;
  }

  @override
  int get hashCode => email.hashCode ^ phoneNumber.hashCode;
}