class UpgradeToBusinessModel {
//  final String? roleId;
final String? accountTypeId;
  final Business business;

  UpgradeToBusinessModel({
  //  this.roleId,
     this.accountTypeId,
    required this.business,
  });

  factory UpgradeToBusinessModel.fromJson(Map<String, dynamic> json) {
    return UpgradeToBusinessModel(
     // roleId: json['roleId'],
       accountTypeId: json['accountTypeId'],
      business: Business.fromJson(json['business']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'roleId': roleId,
      'accountTypeId': accountTypeId,
      'business': business.toJson(),
    };
  }
}

class Business {
  final String name;
  final String businessTypeId;
  final String? contactEmail;
  final String? contactPhone;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? lga;

  Business(
      {required this.name,
      required this.businessTypeId,
      this.contactEmail,
      this.contactPhone,
      this.address,
      this.city,
      this.state,
      this.country,
      this.lga});

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
        name: json['name'],
        businessTypeId: json['businessTypeId'],
        contactEmail: json['contactEmail'],
        contactPhone: json['contactPhone'],
        address: json['address'],
        city: json['city'],
        state: json['state'],
        country: json['country'],
        lga: json['lga']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'businessTypeId': businessTypeId,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'lga': lga
    };
  }
}
