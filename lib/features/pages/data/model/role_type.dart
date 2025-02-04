import '../../../../core/data/model/model.dart';

class RoleModel{
  String roleType;
  String image;

  RoleModel({required this.roleType, required this.image,});
}

class DummyData {
  static List<Select> roleList = [
    Select(label: 'Admin', value: 'Admin'),
    Select(label: 'Moderator', value: 'Moderator'),
    Select(label: 'Editor', value: 'Editor'),
    // RoleModel(
    //     roleType: "Admin",
    //     image: 'assets/images/pages/crown2.png',
    // ),
    // RoleModel(
    //   roleType: "Moderator",
    //   image: 'assets/images/pages/moderator.png',
    // ),
    // RoleModel(
    //   roleType: "Editor",
    //   image: 'assets/images/pages/crown.png',
    // ),
  ];
}