import 'package:flutter/material.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
//import 'package:wayagram/features/shared/components/engagement_range.dart';
import 'package:wayagram/features/ugt/data/model/ugt_model.dart';
import 'package:gap/gap.dart';

class UgtCard extends StatelessWidget {
  final Ugt ugt;
  const UgtCard({super.key, required this.ugt});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

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
                  WayaImage(
                    imageUrl: ugt.logo,
                    height: 45,
                    width: 45,
                    radius: BorderRadius.circular(45),
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
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Gap(20),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // return EngagementRange(
                    //     topLeft: ugt.votes[index].name,
                    //     range: ugt.votes[index].noOfVotes,
                    //     bottomRight: WayaHelpers.toOrdinal(index + 1),
                    //     bottomLeft:
                    //         "${ugt.votes[index].noOfVotes * 100} Votes");
                  },
                  //itemCount: ugt.votes.length
              ),
              // const Gap(20),
            ],
          ),
        ),
        const Gap(30)
      ],
    );
  }
}
