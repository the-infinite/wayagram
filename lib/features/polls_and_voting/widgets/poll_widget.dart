import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/polls_and_voting/data/model/fetch_all_polls.dart';
import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';

class PollWidget extends ConsumerWidget {
  final Docs poll;

  const PollWidget({
    super.key,
    required this.poll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

    int daysLeft = DateTime.parse('${poll.endDate}')
        .difference(DateTime.parse('${poll.startDate}'))
        .inHours;
    return Container(
      margin: EdgeInsets.only(bottom: 40.h),
      //height: 400.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              WayaDp(
                image: poll.userData!.profilePicture ?? '',
                radius: 20,
              ),
              const Gap(10),
              Text(
                "${poll.userData?.firstName?.capitalizeFirst}",
                style: wayaTheme.textTheme.bodyBold.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              const Gap(3),
              Text(
                "• ${WayaHelpers.formatTimeAgo('${poll.startDate}')}",
                style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.greyColor500),
              ),
              Spacer(),
              Image.asset(
                'assets/images/polls/menu.png',
                height: 32.h,
              ),
            ],
          ),
          const Gap(12),
          Text(
            "${poll.question?.capitalizeFirst}",
            style: wayaTheme.textTheme.bodyBold.copyWith(
              fontSize: 16.sp,
            ),
          ),

          const Gap(3),

          //> choice description if its exist
          if (poll.choices != null && poll.choices!.isNotEmpty) ...[
            ...List.generate(poll.choices!.length, (index) {
              final description = poll.choices![index].description ?? '';
              return description.isNotEmpty
                  ? Text(
                      description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .wayaCopyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color:
                                  Theme.of(context).colorScheme.greyColor500),
                    )
                  : SizedBox.shrink();
            })
          ],

          const Gap(10),
          Text(
            '${poll.maxVotesPerUser ?? 0} Votes • $daysLeft hours remaining',
            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.greyColor500),
          ),
          const Gap(10),
          // index == 0?
          if (poll.choices != null && poll.choices!.isNotEmpty) ...[
            ...List.generate(poll.choices!.length, (index) {
              final choice = poll.choices![index];

              return InkWell(
                splashColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                onTap: () {
                  WayaUtils.showModalSheet(
                    context,
                    child: VoteOptionModal(
                      voteFee: poll.feePerVote!,
                      choiceId: choice.id!,
                      pollId: poll.id!,
                      candidateName: choice.text!,
                      votingLink: poll.url!,
                    ),
                  );
                },
                child: Container(
                    padding: EdgeInsets.only(
                        left: 10.w, right: 10.w, top: 10.w, bottom: 10.w),
                    margin: EdgeInsets.only(bottom: 4),
                    // height: 60.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: WayaColors.primary600,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: choice.imageUrl != null
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: [
                        choice.imageUrl != null
                            ? WayaImage(
                                imageUrl: choice.imageUrl ?? '',
                                fit: BoxFit.cover,
                                height: 44.h,
                                width: 60,
                              )
                            : SizedBox.shrink(),
                        choice.imageUrl != null
                            ? const Gap(40)
                            : SizedBox.shrink(),
                        Text(
                          choice.text ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .wayaCopyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.primary600),
                        ),
                      ],
                    )),
              );
            })
          ]
        ],
      ),
    );
  }
}
