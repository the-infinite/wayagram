import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/modals/warning.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/string_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';
import 'package:wayagram/shared/features/profile/model/poll.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class SinglePollWidget extends ConsumerWidget {
  final PollModel poll;
  final UserDetailsModel user;
  final bool padded;

  const SinglePollWidget({
    super.key,
    required this.poll,
    required this.user,
    this.padded = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    int daysLeft = poll.endDate.difference(DateTime.now()).inHours;

    //? This is fine.
    return Container(
      margin: EdgeInsets.only(bottom: 40.h),
      padding:
          padded ? EdgeInsets.symmetric(horizontal: 10.w) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              //? The profile picture of the user that created it.
              WayaDp(
                image: user.profilePicture ?? '',
                radius: 20.r,
              ),

              const Gap(10),
              Text(
                user.firstName.capitalizeFirst,
                style: wayaTheme.textTheme.bodyBold.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              const Gap(3),
              Text(
                "• ${WayaHelpers.formatTimeAgo(poll.startDate.toIso8601String())}",
                style: wayaTheme.textTheme.bodyMedium!.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: wayaTheme.colorScheme.greyColor500,
                ),
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
            poll.question.capitalizeFirst,
            style: wayaTheme.textTheme.bodyBold.copyWith(
              fontSize: 16.sp,
            ),
          ),

          const Gap(3),

          //> choice description if its exist
          if (poll.choices != null && poll.choices!.isNotEmpty) ...[
            ...List.generate(poll.choices!.length, (index) {
              final description = poll.choices![index].description;
              return description?.isNotEmpty ?? false
                  ? Text(
                      description!,
                      style: wayaTheme.textTheme.bodyMedium!.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: wayaTheme.colorScheme.greyColor500,
                      ),
                    )
                  : SizedBox.shrink();
            })
          ],

          const Gap(10),
          Text(
            '${poll.maxVotesPerUser ?? 0} Votes • ${daysLeft < 0 ? 'This poll has expired' : '$daysLeft hours remaining'}',
            style: wayaTheme.textTheme.bodyMedium!.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: wayaTheme.colorScheme.greyColor500),
          ),
          const Gap(10),
          // index == 0?
          if (poll.choices != null && poll.choices!.isNotEmpty) ...[
            ...List.generate(
              poll.choices!.length,
              (index) {
                final choice = poll.choices![index];

                return InkWell(
                  splashColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  onTap: () {
                    DateTime expirationDate = poll.endDate;
                    DateTime currentDate =
                        DateTime.now(); // Get current date and time

                    //? If this has expired.
                    if (currentDate.isAfter(expirationDate)) {
                      WayaUtils.showModalSheet(
                        context,
                        child: WayaWarningDialog(title: "The poll has ended"),
                      );
                    }

                    //? Show the voting modal if this poll has not expired.
                    else {
                      WayaUtils.showModalSheet(
                        context,
                        child: VoteOptionModal(
                          voteFee: poll.feePerVote!,
                          choiceId: choice.id,
                          pollId: poll.id,
                          candidateName: choice.text,
                          votingLink: poll.url!,
                        ),
                      );
                    }
                  },
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 10.w, right: 10.w, top: 10.w, bottom: 10.w),
                      margin: EdgeInsets.only(bottom: 4),
                      // height: 60.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: wayaTheme.colorScheme.primary600,
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
                            choice.text,
                            style: wayaTheme.textTheme.bodyMedium!.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: wayaTheme.colorScheme.primary600),
                          ),
                        ],
                      )),
                );
              },
            )
          ]
        ],
      ),
    );
  }
}
