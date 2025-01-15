class Vote {
  final String name;
  final double noOfVotes;

  Vote({required this.name, required this.noOfVotes});
}

class Ugt {
  final String logo;
  final String institution;
  final int noOfParticipants;
  final String about;
  final List<Vote> votes;

  Ugt(
      {required this.about,
      required this.institution,
      required this.logo,
      required this.noOfParticipants,
      required this.votes});
}
