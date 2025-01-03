class SelectAccountData {
  final String avatar;
  final String title;
  final String description;
  final String type;
  final String id;

  SelectAccountData(
      {required this.avatar,
      required this.description,
      required this.title,
      required this.type,
      required this.id
      });
}

List<SelectAccountData> selectAccountData = [
  SelectAccountData(
      avatar: "assets/icons/personal.svg",
      description: "Create your personal account to get started \n with us",
      title: "Personal Account",
      type: "PERSONAL", 
      id: "1"
      ),
  SelectAccountData(
      avatar: "assets/icons/business.svg",
      description: "Create a business account for your  \n business",
      title: "Business Account",
      type: "BUSINESS",
      id: "2"
      )
];
