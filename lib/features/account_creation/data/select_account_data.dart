class SelectAccountData {
  final String avatar;
  final String title;
  final String description;
  final String type;

  SelectAccountData(
      {required this.avatar,
      required this.description,
      required this.title,
      required this.type});
}

List<SelectAccountData> selectAccountData = [
  SelectAccountData(
      avatar: "assets/icons/personal.svg",
      description: "Create your personal account to get started \n with us",
      title: "Personal Account",
      type: "personal"),
  SelectAccountData(
      avatar: "assets/icons/business.svg",
      description: "Create a business account for your  \n business",
      title: "Business Account",
      type: "business")
];
