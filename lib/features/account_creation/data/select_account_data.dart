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
      avatar: "assets/svg/personal.svg",
      description: "Create your personal account to get started \n with us",
      title: "Personal Account",
      type: "personal"),
  SelectAccountData(
      avatar: "assets/svg/business.svg",
      description: "Create a business account for your business",
      title: "Business Account",
      type: "business")
];
