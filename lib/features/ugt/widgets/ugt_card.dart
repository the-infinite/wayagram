import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import 'package:gap/gap.dart';

class UgtCard extends StatelessWidget {
  final Ugt ugt;
  const UgtCard({super.key, required this.ugt});

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
              Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45),
                      image: DecorationImage(
                          image: AssetImage(ugt.logo), fit: BoxFit.cover),
                    ),
                  ),
                  const Gap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        ugt.institution,
                        style: wayaTheme.textTheme.bodyMedium,
                      ),
                      const Gap(10),
                      Text(
                        '${ugt.noOfParticipants} Participants',
                        style: wayaTheme.textTheme.hintStyle,
                      ),
                    ],
                  )
                ],
              ),
              const Gap(20),
              Text(
                ugt.about,
                style: wayaTheme.textTheme.hintStyle,
              ),
              const Gap(20),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return VoteItem(vote: ugt.votes[index], index: index);
                  },
                  itemCount: ugt.votes.length),
              // const Gap(20),
            ],
          ),
        ),
        const Gap(30)
      ],
    );
  }
}

class VoteItem extends StatelessWidget {
  final Vote vote;
  final int index;
  const VoteItem({super.key, required this.vote, required this.index});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          vote.name,
          style: TextStyle().wayaCopyWith(
              color: wayaTheme.colorScheme.customBlack,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
        const Gap(8),
        SizedBox(
          width: double.infinity,
          height: 10,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: wayaTheme.colorScheme.greyColor200,
                ),
                height: 10,
                width: double.infinity,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: wayaTheme.colorScheme.customPrimary,
                ),
                height: 10,
                width: context.width * vote.noOfVotes,
              ),
            ],
          ),
        ),
        const Gap(8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${vote.noOfVotes * 100} Votes",
              style: TextStyle().wayaCopyWith(
                  color: wayaTheme.colorScheme.customBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              WayaHelpers.toOrdinal(index + 1),
              textAlign: TextAlign.end,
              style: TextStyle().wayaCopyWith(
                  color: wayaTheme.colorScheme.customBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const Gap(20),
      ],
    );
  }
}
