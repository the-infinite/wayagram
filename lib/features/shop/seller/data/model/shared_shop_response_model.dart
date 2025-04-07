class SharedShopResponse {
  final String message;
  final bool status;
  final int statusCode;
  final List<SharedShop> data;

  SharedShopResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory SharedShopResponse.fromJson(Map<String, dynamic> json) {
    return SharedShopResponse(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: (json['data'] as List)
          .map((shopJson) => SharedShop.fromJson(shopJson))
          .toList(),
    );
  }
}

class SharedShop {
  final String shopId;
  final String shopName;
  final String shopDescription;
  final String shopLogo;
  final List<Role> roles;

  SharedShop({
    required this.shopId,
    required this.shopName,
    required this.shopDescription,
    required this.shopLogo,
    required this.roles,
  });

  factory SharedShop.fromJson(Map<String, dynamic> json) {
    return SharedShop(
      shopId: json['shopId'],
      shopName: json['shopName'],
      shopDescription: json['shopDescription'] ?? '',
      shopLogo: json['shopLogo'] ?? '',
      roles: (json['roles'] as List)
          .map((roleJson) => Role.fromJson(roleJson))
          .toList(),
    );
  }
}

class Role {
  final String roleId;
  final String roleName;
  final String description;

  Role({
    required this.roleId,
    required this.roleName,
    required this.description,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      roleId: json['roleId'],
      roleName: json['roleName'],
      description: json['description'] ?? '',
    );
  }
}
