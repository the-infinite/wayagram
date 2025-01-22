
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/data/model/get_poll_model.dart';
import 'package:wayagram/features/polls_and_voting/data/repo/poll_and_voting_repository.dart';
import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

class PollsForYou extends ConsumerStatefulWidget {
  const PollsForYou({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollsForYouState();
}
class _PollsForYouState extends ConsumerState<PollsForYou> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createPollVotingProvider.notifier).getAllPolls();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPollVotingProvider);
    return Column(
      children: [
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewModel.getPollModel.length,
            itemBuilder: (context, index) {
              final poll = viewModel.getPollModel[index];
              int daysLeft = DateTime.parse('${poll.endDate}').difference(DateTime.parse('${poll.startDate}')).inHours;

              int hoursLeft = DateTime.now().difference(DateTime.parse('${poll.createdAt}')).inHours;

              return Container(
                margin: EdgeInsets.only(bottom: 40.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(children: [
                      //Image.asset('assets/images/polls/rufai.png', height: 32.h,),
                      WayaDp(radius: 10,),
                      const Gap(3),
                      Text('', style: wayaTheme.textTheme.titleLarge),
                      const Gap(3),
                      Text(
                        ' • ${hoursLeft}h ago',
                        style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.greyColor500 ),
                      ),

                      Spacer(),
                      Image.asset('assets/images/polls/menu.png', height: 32.h,),

                    ],),
                    const Gap(10),

                    Text("${poll.question?.capitalizeFirst}", style: wayaTheme.textTheme.titleLarge),
                    const Gap(3),
                    if(poll.choices != null)
                      ...poll.choices!.map((e)=>
                          Text(
                            '${e.description?.capitalizeFirst}',
                            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.greyColor500 ),
                          ),),
                    const Gap(10),
                    Text(
                      '${poll.maxVotesPerUser} ${poll.maxVotesPerUser == 0 || poll.maxVotesPerUser == 1 ? 'Vote' : 'Votes'} • $daysLeft hours remaining',
                      style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.greyColor500 ),
                    ),
                    const Gap(10),

                    Column(
                      children: [
                        if(poll.choices != null)
                        ...poll.choices!.map((e)=>
                            presImage('${e.imageUrl}',
                            '${e.text}', context, true))
                      ],
                    )

                  ],),
              );
            }),
        const Gap(10),
      ],
    );
  }
  presImage(img, name, ctx, chk){
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        onTap: (){
          WayaUtils.showModalSheet(
            ctx,
            child: VoteOptionModal(),
          );
        },
        child: Container(
          padding: EdgeInsets.only(left: 20.w, bottom: 10),
          height: 60.h,
          decoration: BoxDecoration(
            border: Border.all(color: WayaColors.primary600, ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: chk ? Row(children: [
            //Image.network(img, height: 44.h),
            WayaImage(imageUrl: img, height: 44.h),
            const Gap(40),
            Text(
              name,
              style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(ctx).colorScheme.primary600 ),
            ),

          ],) : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                name,
                style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(ctx).colorScheme.primary600 ),
              ),

            ],),
        ),
      ),
    );
  }
}


