import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/features/polls_and_voting/data/model/fetch_all_polls.dart';
import 'package:wayagram/shared/components/engagement_range.dart';
import 'package:gap/gap.dart';

class PollsCard extends StatelessWidget {
  final Docs poll;
  const PollsCard({super.key, required this.poll});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    List<Choices> sortedChoices = List.from(poll.choices ?? []);

    sortedChoices.sort((a, b) {
      double aVote = (a.voteCount ?? 0).toDouble();
      double bVote = (b.voteCount ?? 0).toDouble();
      double totalVotes = (poll.voteCount ?? 1).toDouble();

      double aCalc = totalVotes > 0 ? aVote / totalVotes : 0;
      double bCalc = totalVotes > 0 ? bVote / totalVotes : 0;

      return bCalc.compareTo(aCalc);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.white,
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: wayaTheme.colorScheme.greyColor200, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    poll.question ?? '',
                    style: wayaTheme.textTheme.bodyMedium,
                  ),
                  const Gap(10),
                  Text(
                    '${poll.maxVotesPerUser} ${poll.maxVotesPerUser! > 1 ? "Votes" : "Vote"}',
                    style: wayaTheme.textTheme.hintStyle,
                  ),
                ],
              ),
              const Gap(20),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: sortedChoices.length,
                itemBuilder: (context, index) {
                  int choiceVote = sortedChoices[index].voteCount!.toInt();
                  int totalPollCount = poll.voteCount!.toInt();
                  double calc =
                      totalPollCount > 0 ? choiceVote / totalPollCount : 0;

                  return EngagementRange(
                    topLeft: sortedChoices[index].text,
                    range: calc,
                    bottomRight: WayaHelpers.toOrdinal(index + 1),
                    bottomLeft: "${(calc * 100).toStringAsFixed(0)}% Votes",
                  );
                },
              ),
            ],
          ),
        ),
        const Gap(30),
      ],
    );
  }
}
