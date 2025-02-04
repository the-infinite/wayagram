
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
import 'package:wayagram/features/polls_and_voting/views/poll_dashboard.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

class MyPolls extends ConsumerStatefulWidget {
  const MyPolls({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyPollsState();
}
class _MyPollsState extends ConsumerState<MyPolls> {

  WayaLocalDataSource _wayaLocalDataSource = WayaLocalDataSource();


  @override
  void initState() {
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
            itemCount: viewModel.fetchAllPols.length,
            itemBuilder: (context, index) {
              //final poll = viewModel.getMyPollModel[index];
              final poll = viewModel.fetchAllPols[index];
              int daysLeft = DateTime.parse('${poll.endDate}').difference(DateTime.parse('${poll.startDate}')).inHours;
              int hoursLeft = DateTime.now().difference(DateTime.parse('${poll.createdAt}')).inHours;
              print('URL ===> ${poll.url}');
              return  Container(
                margin: EdgeInsets.only(bottom: 20.h),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage('${poll.userData?.profilePicture}'),
                        radius: 10,
                        backgroundColor: wayaTheme.colorScheme.greyColor200,
                      ),
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

                    Text("${poll.question?.toLowerCase().capitalizeFirst}", style: wayaTheme.textTheme.titleLarge),
                    const Gap(3),
                    if(poll.choices != null)
                      ...poll.choices!.map((e)=>
                          Text(
                            '${e.description?.toLowerCase().capitalizeFirst}',
                            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.greyColor500 ),
                          ),),



                    const Gap(10),
                    Text(
                      '${poll.maxVotesPerUser} ${poll.maxVotesPerUser == 0 || poll.maxVotesPerUser == 1 ? 'Vote' : 'Votes'} •  $daysLeft hours remaining',
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
                                  '${e.text?.toLowerCase().capitalizeFirst}', context, true,
                                  '${poll.feePerVote}', e.id, e.pollId, e.text, poll.url))
                      ],
                    ),
                    const Gap(10),
              //...poll.choices!.map((e)=>
                    WayaButton(
                      callback: (){
                         //WayaNav.to(PollDashboard(pollId: '${poll.choices?[index].pollId}',));
                        WayaNav.toNamed('/poll-dashboard',
                           // arguments: '${e.pollId}'
                            arguments: '${poll.choices?[index].pollId}'
                        );
                      },
                      text: 'Manage Poll',
                    ),
              //)
                  ],),
              );
            }),

        //const Gap(10),
      ],
    );
  }

  userIm(ctx, net) {
    
    return
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child:

            Image.network(
              net,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.white,
                  height:MediaQuery.of(ctx).size.height /9,
                  width: MediaQuery.of(ctx).size.height /9,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: CircularProgressIndicator(
                        color: WayaColors.primary.withOpacity(0.5),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!.toInt()
                            : null,
                      ),
                    ),
                  ),
                );
              },
              errorBuilder: (context, exception, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: WayaColors.primary,
                      border: Border.all(
                        color: Colors.white,
                      )),
                  height: MediaQuery.of(ctx).size.height /9,
                  width: MediaQuery.of(ctx).size.height /9,
                  child:  Center(
                      child: Image.asset('assets/images/home/profile_icon.png', height: 60.h, width: 70.w,)
                    //Text('Image\nError', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 8)),
                  ),
                );
              },
              fit: BoxFit.cover,
              height: MediaQuery.of(ctx).size.height /8,
              width: MediaQuery.of(ctx).size.height /8,
            ),
          ),

        ],
      ),
    ]);
  }

  presImage(img, name, ctx, chk, voteFee, choiceId, pollId,candidateName, votingLink){
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        onTap: (){
          WayaUtils.showModalSheet(
            ctx,
            child: VoteOptionModal(voteFee: voteFee,choiceId: choiceId, pollId: pollId,candidateName: candidateName,
            votingLink:votingLink ,),
          );
        },
        child: Container(
          padding: EdgeInsets.only(left: 20.w, bottom: 0),
          height: 60.h,
          decoration: BoxDecoration(
            border: Border.all(color: WayaColors.primary600, ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: chk ? Row(children: [
            //Expanded(child: Image.network(img, height: 44.h)),
            //WayaImage(imageUrl: img, height: 44.h),
            Expanded(child:  Stack(
              clipBehavior: Clip.none,
              children: [
                Image.network(
                  img,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.white,
                      height:44.h,
                      width: MediaQuery.of(ctx).size.height /9,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: CircularProgressIndicator(
                            color: WayaColors.primary.withOpacity(0.5),
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!.toInt()
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, exception, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: WayaColors.primary,
                          border: Border.all(
                            color: Colors.white,
                          )),
                      //MediaQuery.of(ctx).size.height /12,
                      height: 44.h,
                      width: MediaQuery.of(ctx).size.height /12,
                      child:  Center(
                          child:
                          //Image.asset('assets/images/home/profile_icon.png', height: 60.h, width: 70.w,)
                        Text('Image\nError', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 8)),
                      ),
                    );
                  },
                  fit: BoxFit.cover,
                  height: 44.h,
                  width: MediaQuery.of(ctx).size.height /8,
                ),

              ],
            ),),
            const Gap(30),
            Expanded(
              flex: 3,
              child: Text(
                name,
                style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(ctx).colorScheme.primary600 ),
              ),
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