
class CreateShopModel {
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;
  final String? logo;
  final String vendorId;
  final String lga;
  final String state;

  CreateShopModel(
      {required this.name,
      required this.description,
      required this.address,
      required this.phone,
      required this.email,
      required this.logo,
      required this.vendorId,
      required this.lga,
      required this.state});

  factory CreateShopModel.fromJson(Map<String, dynamic> json) {
    return CreateShopModel(
        name: json['name'],
        description: json['description'],
        address: json['address'],
        phone: json['phone'],
        email: json['email'],
        vendorId: json['vendorId'],
        logo: json['logo'],
        lga: json['lga'],
        state: json['state']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
      'vendorId': vendorId,
      'lga': lga,
      'state': state
    };

    if (logo != null) json['logo'] = logo;

    return json;
  }
}
