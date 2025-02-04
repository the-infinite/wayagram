import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/features/explore/data/model/default.dart';
import 'package:wayagram/features/shared/components/engagement_range.dart';
import 'package:gap/gap.dart';

class PollsCard extends StatelessWidget {
  final PollDefault poll;
  const PollsCard({super.key, required this.poll});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    // TODO: implement build
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
                    poll.title,
                    style: wayaTheme.textTheme.bodyMedium,
                  ),
                  const Gap(10),
                  Text(
                    '${poll.totalVotes} Votes',
                    style: wayaTheme.textTheme.hintStyle,
                  ),
                ],
              ),
              const Gap(20),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return EngagementRange(
                        topLeft: poll.votes[index].name,
                        range: poll.votes[index].noOfVotes,
                        bottomRight: WayaHelpers.toOrdinal(index + 1),
                        bottomLeft:
                            "${poll.votes[index].noOfVotes * 100} Votes");
                  },
                  itemCount: poll.votes.length),
              // const Gap(20),
            ],
          ),
        ),
        const Gap(30)
      ],
    );
  }
}
