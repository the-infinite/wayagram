class GroupDefault {
  final String name;
  final int numberOfFollowers;

  GroupDefault({required this.name, required this.numberOfFollowers});
}


class ChatDefault {
  final String name;
  final String mostRecentChat;
  final bool isChecked;

  ChatDefault(
      {required this.mostRecentChat,
      required this.name,
      this.isChecked = false});
}

class Vote {
  final String name;
  final double noOfVotes;

  Vote({required this.name, required this.noOfVotes});
}

class PollDefault {
  final String title;
  final int totalVotes;
  final List<Vote> votes;

  PollDefault(
      {required this.title, required this.totalVotes, required this.votes});
}

final List<PollDefault> pollList = [
  PollDefault(
      title: "Who is the biggest musician in Africa",
      totalVotes: 800,
      votes: [
        Vote(name: 'Wizkid Ayo', noOfVotes: 0.95),
        Vote(name: ' Ayo', noOfVotes: 0.50),
        Vote(name: 'Ayan', noOfVotes: 0.30),
      ])
];

final List<GroupDefault> groupList = [
  GroupDefault(name: "Manchester United", numberOfFollowers: 3000),
  GroupDefault(name: "Real Madrid", numberOfFollowers: 3500),
];


final List<ChatDefault> chatList = [
  ChatDefault(
      mostRecentChat: "I'd definitely shoot any opportunities by the leg",
      name: 'Edet Okonkwo'),
  ChatDefault(
      mostRecentChat: "I'd definitely shoot any opportunities by the leg",
      name: 'Amarachi Joseph',
      isChecked: true),
];
