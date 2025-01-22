
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

/*class MyPolls extends ConsumerWidget {
  const MyPolls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final wayaTheme = Theme.of(context);
    return Column(
      children: [


        ListView.builder(

            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) {
              return  Container(
                margin: EdgeInsets.only(bottom: 20.h),
                height: 400.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Image.asset('assets/images/polls/rufai.png', height: 32.h,),
                      const Gap(3),
                      Text("Rufai Maleek", style: wayaTheme.textTheme.titleLarge),
                      const Gap(3),
                      Text(
                        ' • 2h ago',
                        style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.greyColor500 ),
                      ),

                      Spacer(),
                      Image.asset('assets/images/polls/menu.png', height: 32.h,),


                    ],),
                    const Gap(10),
                   index == 0 || index == 1 ? Text("Who is the current president of nigeria?", style: wayaTheme.textTheme.titleLarge):
                    Text("Which Nigerian Artist has the most awards?", style: wayaTheme.textTheme.titleLarge),
                    const Gap(3),
                    index == 0 || index == 1 ?
                    Text(
                      'I think we are all left with this question sometimes whenever we sleep sometimes.',
                      style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.greyColor500 ),
                    ) : Container(),

                    const Gap(10),
                    Text(
                      '980 Votes • 23 hours 46 minutes remaining',
                      style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.greyColor500 ),
                    ),
                    const Gap(10),
                    index == 0?
                    Column(
                      children: [
                        presImage('assets/images/polls/azikwe.png', 'Dr Nnamdi Azikwe', context, true),
                        const Gap(10),
                        presImage('assets/images/polls/tinubu.png', 'Bola Ahmed Tinubu', context, true),
                        const Gap(10),
                        presImage('assets/images/polls/buhari.png', 'Mohammed Buhari', context, true),
                      ],
                    ): index == 1 ?  Column(
                      children: [
                        presImage('assets/images/polls/victony.png', 'Victony’s Stubborn', context, true),
                        const Gap(10),
                        presImage('assets/images/polls/rema.png', 'Rema ‘s Heis', context, true),
                        const Gap(10),
                        presImage('assets/images/polls/lagos.png', 'Made In Lagos', context, true),
                      ],
                    ):   Column(
                      children: [
                        presImage('assets/images/polls/azikwe.png', 'Wizkid', context, false),
                        const Gap(10),
                        presImage('assets/images/polls/tinubu.png', 'Davido', context, false),
                        const Gap(10),
                        presImage('assets/images/polls/buhari.png', 'Burna Boy', context, false),
                      ],
                    ),
                    const Gap(10),
                    WayaButton(
                        callback: (){
                          WayaNav.toNamed('/poll-dashboard');
                        },
                      text: 'Manage Poll',
                    ),


                  ],),
              );
            }),

        const Gap(25),

      ],
    );
  }
  presImage(img, name, ctx, chk){
    return InkWell(
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: (){
        WayaUtils.showModalSheet(
          ctx,
          child: VoteOptionModal(),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.w),
        height: 60.h,
        decoration: BoxDecoration(
          border: Border.all(color: WayaColors.primary600, ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: chk ? Row(children: [
         Image.asset(img, height: 44.h,),
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
    );
  }
}*/

class MyPolls extends ConsumerStatefulWidget {
  const MyPolls({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyPollsState();
}
class _MyPollsState extends ConsumerState<MyPolls> {

  WayaLocalDataSource _wayaLocalDataSource = WayaLocalDataSource();


  @override
  void initState() {
    print('DAARLINGTON  DIALD ==>> ${_wayaLocalDataSource.getUserId()}');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createPollVotingProvider.notifier).getMyPolls(_wayaLocalDataSource.getUserId());
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
            itemCount: viewModel.getMyPollModel.length,
            itemBuilder: (context, index) {
              final poll = viewModel.getMyPollModel[index];
              int daysLeft = DateTime.parse('${poll.endDate}').difference(DateTime.parse('${poll.startDate}')).inHours;

              int hoursLeft = DateTime.now().difference(DateTime.parse('${poll.createdAt}')).inHours;
              return  Container(
                margin: EdgeInsets.only(bottom: 20.h),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      WayaDp(radius: 10,),
                      //WayaImage(imageUrl:'${poll.userData?.profilePicture}', height: 32.h),
                      const Gap(3),
                      Text('${poll.userData?.firstName} ${poll.userData?.lastName}', style: wayaTheme.textTheme.titleLarge),
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
                      '${poll.maxVotesPerUser} ${poll.maxVotesPerUser == 0 || poll.maxVotesPerUser == 1 ? 'Vote' : 'Votes'} •  $daysLeft remaining',
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
                    ),
                    const Gap(10),
                    WayaButton(
                      callback: (){
                        WayaNav.toNamed('/poll-dashboard');
                      },
                      text: 'Manage Poll',
                    ),
                  ],),
              );
            }),

        //const Gap(10),
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