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
  ];

  static List<Select> pageRole = [
    Select(label: 'Admin', value: 'Admin'),
    Select(label: 'Editor', value: 'Editor'),

  ];
}