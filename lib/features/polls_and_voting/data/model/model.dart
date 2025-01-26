
class PollType {
  final String id;
  final String pollType;

  PollType({required this.id, required this.pollType});
}


List<PollType> pollTypes = [
  PollType(id: 'Paid', pollType: 'Paid'),
  PollType(id: 'Free', pollType: 'Free'),

];

