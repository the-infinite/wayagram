class BusinessTypeData {
  final String title;
  final String description;
  final String type;

  BusinessTypeData(
      {required this.description, required this.title, required this.type});
}

final List<BusinessTypeData> businessDataType = [
   BusinessTypeData(
      description: 'Set up a business account \n with your c.a.c documents.',
      title: 'C.A.C Business \n Account',
      type: 'WITH-CAC'),
  BusinessTypeData(
      description:
          'We got you covered even if \n you don’t have a registered \n business yet',
      title: 'Non C.A.C Business \n Account',
      type: 'NO-CAC'),
 
];
