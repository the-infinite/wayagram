
class PollType {
  final int id;
  final String pollType;

  PollType({required this.id, required this.pollType});
}


List<PollType> pollTypes = [
  PollType(id: 1, pollType: 'Paid'),
  PollType(id: 2, pollType: 'Free'),

];

