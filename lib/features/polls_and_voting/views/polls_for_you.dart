
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/views/my_events.dart';
import 'package:wayagram/features/polls_and_voting/data/model/fetch_all_polls.dart';
import 'package:wayagram/features/polls_and_voting/data/model/get_poll_model.dart';
import 'package:wayagram/features/polls_and_voting/data/repo/poll_and_voting_repository.dart';
import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

class PollsForYou extends ConsumerStatefulWidget {
  const PollsForYou({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollsForYouState();
}
class _PollsForYouState extends ConsumerState<PollsForYou> {

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPollVotingProvider);
    return Expanded(
      child: PaginatedDataView<Docs>(
          uniqueKey: 'polls-for-you',
          loadingState: SizedBox(
              height: context.height * 0.4,
              child: Center(
                child: CircularProgressIndicator(),
              )),
          emptyState:PollEmptyState(),
          fetchData: ref.read(createPollVotingProvider.notifier).getAllPolls,
          result: (data, s) {
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.fetchAllPols.length,
                itemBuilder: (context, index) {
                  final poll = viewModel.fetchAllPols[index];
                  int daysLeft = DateTime.parse('${poll.endDate}').difference(DateTime.parse('${poll.startDate}')).inHours;
                  //int hoursLeft = DateTime.now().difference(DateTime.parse('${poll.createdAt}')).inHours;
                  print('URL ===> ${poll.url}');

                  String formatTimeAgo(String dateString) {
                    DateTime dateTime =
                    DateTime.parse(dateString); // Convert string to DateTime
                    return timeago.format(dateTime); // Convert to "time ago" format
                  }
                  return Container(
                    margin: EdgeInsets.only(bottom: 40.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(poll.userData?.profilePicture ?? ''),
                            radius: 10,
                            backgroundColor: wayaTheme.colorScheme.greyColor200,
                          ),
                          const Gap(3),
                          Text('${poll.userData?.firstName?.capitalizeFirst}', style: wayaTheme.textTheme.titleLarge),
                          const Gap(3),
                          Text(
                            ' • ${ WayaHelpers.formatTimeAgo('${poll.startDate}')}',
                            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.greyColor500 ),
                          ),

                          Spacer(),
                          Image.asset('assets/images/polls/menu.png', height: 32.h,),
                         /* InkWell(
                              onTap: (){
                                PopupMenuButton(
                                  onSelected: (value) {},
                                  iconColor: wayaTheme.colorScheme.greyColor400,
                                  position: PopupMenuPosition.under,
                                  itemBuilder: (context) {
                                    return [

                                      PopupMenuItem<int>(
                                        value: 0,
                                        child: _buildActionNav(
                                          context: context,
                                          onTap: () {
                                            Share.share('${poll.url}');
                                          },
                                          asset: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
                                          text: "Share Group link",
                                          color: wayaTheme.colorScheme.customBlack,
                                        ),
                                      ),

                                    ];
                                  },
                                );
                              },
                              //child: Image.asset('assets/images/polls/menu.png', height: 32.h,)
                          ),*/

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
//[vote(choice)/vote(poll)] * 100
                        Column(
                          children: [
                            if(poll.choices != null)
                              ...poll.choices!.map((e)=>
                                  choiceStatistics('${e.imageUrl}',
                                      '${e.text}', context, true, poll.feePerVote,
                                      e.id, e.pollId,e.text, poll.url,
                                      '${(((e.voteCount!)/viewModel.fetchAllPols[index].voteCount!)*100)}',
                                      //'${(viewModel.fetchAllPols[index].voteCount!/(e.voteCount!))*100}',
                                      '${e.voteCount}'))
                          ],
                        )

                      ],),
                  );
                });
          }),


    );
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
            child: VoteOptionModal(voteFee:  voteFee,choiceId: choiceId,
              pollId: pollId,candidateName: candidateName,
            votingLink:votingLink,),
          );
        },
        child: Container(
          padding: EdgeInsets.only(left: 20.w,),
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

  choiceStatistics(img, name, ctx, chk, voteFee, choiceId,
      pollId,candidateName, votingLink, votePercentage, voteCount, ){
    return voteCount == '0'? Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        onTap: (){
          WayaUtils.showModalSheet(
            ctx,
            child: VoteOptionModal(voteFee:  voteFee,choiceId: choiceId,
              pollId: pollId,candidateName: candidateName,
              votingLink:votingLink,),
          );
        },
        child: Container(
          padding: EdgeInsets.only(left: 20.w,),
          height: 60.h,
          decoration: BoxDecoration(
            border: Border.all(color: WayaColors.primary600, ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: chk ? Row(children: [
            WayaImage(
              imageUrl:img,
              height: 44.h,
              width: 59.w,
              radius: BorderRadius.circular(4),
            ),
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
    ):
    Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          InkWell(
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            onTap: (){
              WayaUtils.showModalSheet(
                ctx,
                child: VoteOptionModal(voteFee:  voteFee,choiceId: choiceId,
                  pollId: pollId,candidateName: candidateName,
                  votingLink:votingLink,),
              );
            },
            child: Container(
              padding: EdgeInsets.only(left: 20.w,),
              height: 60.h,
              decoration: BoxDecoration(
                color: WayaColors.primary500,
                border: Border.all(color: WayaColors.primary600, ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: chk ? Row(children: [
                WayaImage(
                  imageUrl:img,
                  height: 44.h,
                  width: 59.w,
                  radius: BorderRadius.circular(4),
                ),
                               /*     Image.network(
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
                          color: WayaColors.greyColor100,
                          border: Border.all(
                            color: Colors.white,
                          )),
                      //MediaQuery.of(ctx).size.height /12,
                      height: 44.h,
                      width: MediaQuery.of(ctx).size.height /12,
                      child:  Center(
                        child:
                        Image.asset('assets/images/pages/image_placeholder.png',height: 66.h, width: 50.w,)
                      ),
                    );
                  },
                  fit: BoxFit.cover,
                  height: 44.h,
                  width: MediaQuery.of(ctx).size.height /8,
                )*/
                const Gap(30),
                Text(
                  '$name  ',
                  style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(ctx).colorScheme.white ),
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
          Gap(10),
          Column(
            children: [
              Text(
                '$votePercentage%',
                //'${(voteCount/100)}%',
                style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(ctx).colorScheme.black ),
              ),
              Text(
                '$voteCount ${voteCount == '1'? 'vote' : 'votes'}',
                style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(ctx).colorScheme.greyColor500 ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionNav({
    required BuildContext context,
    required VoidCallback onTap,
    required Widget asset,
    required String text,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          asset,
          const Gap(4),
          Text(
            text,
            style: TextStyle().wayaCopyWith(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }

}

class PollEmptyState extends StatelessWidget {
  const PollEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: EmptyState(
            hasButton: false,
            onTap: () {
              //WayaNav.toNamed(CreatePost.route);
            },
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter:
              ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You haven't created any poll yet"),
      ),
    );
  }
}



