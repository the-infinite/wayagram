class BusinessTypeData {
  final String title;
  final String description;
  final String type;

  BusinessTypeData(
      {required this.description, required this.title, required this.type});
}

final List<BusinessTypeData> businessDataType = [
  BusinessTypeData(
      description: 'Set up a business account with your c.a.c documents.',
      title: 'C.A.C Business Account',
      type: 'WITH-CAC'),
  BusinessTypeData(
      description:
          'We got you covered even if you don’t have a registered business',
      title: 'Non C.A.C Business Account',
      type: 'NO-CAC'),
];
