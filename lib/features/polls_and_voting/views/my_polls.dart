
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:share_plus/share_plus.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/data/model/fetch_all_polls.dart';
import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

class MyPolls extends ConsumerStatefulWidget {
  const MyPolls({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyPollsState();
}
class _MyPollsState extends ConsumerState<MyPolls> {

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPollVotingProvider);

    return Expanded(
      child: PaginatedDataView<Docs>(
          uniqueKey: 'my-polls',
          loadingState: SizedBox(
              height: context.height * 0.4,
              child: Center(
                child: CircularProgressIndicator(),
              )),
          emptyState:PollEmptyState(),
          fetchData: ref.read(createPollVotingProvider.notifier).getMyPolls,
          result: (data, s) {
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.fetchAllPols.length,
                itemBuilder: (context, index) {
                  final poll = viewModel.fetchAllPols[index];
                  int daysLeft = DateTime.parse('${poll.endDate}').difference(DateTime.parse('${poll.startDate}')).inHours;

                  DateTime expirationDate = DateTime.parse("${poll.endDate}");
                  DateTime currentDate = DateTime.now(); // Get current date and time

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
                          Text(' • ${ WayaHelpers.formatTimeAgo('${poll.createdAt}')}',
                            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.greyColor500 ),
                          ),

                          Spacer(),
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
                                    asset: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none, height: 20, color: WayaColors.greyColor600),
                                    text: " Share Poll link",
                                    color: wayaTheme.colorScheme.customBlack,
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 1,
                                  child: _buildActionNav(
                                    context: context,
                                    onTap: () {
                                      ref.read(createPollVotingProvider.notifier).deletePoll(context, postId: '${poll.id}');
                                      Navigator.pop(context);
                                    },
                                    asset: SvgPicture.asset(
                                      'assets/images/pages/delete.svg',
                                      color: wayaTheme.colorScheme.error500,
                                      height: 16,
                                    ),
                                    text: "  Delete Poll",
                                    color: wayaTheme.colorScheme.error500,
                                  ),
                                ),
                              ];
                            },
                            child: Image.asset('assets/images/polls/menu.png', height: 32.h,),
                          ),


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
                                      '${poll.feePerVote}', e.id, e.pollId, e.text, poll.url,
                                          (){

                                        if(currentDate.isAfter(expirationDate)){
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'The poll has ended.',
                                                style:
                                                TextStyle(fontFamily: WayaConstants.fontFamily, fontSize: 12),
                                              ),
                                              backgroundColor: WayaColors.primary,
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }else{
                                          WayaUtils.showModalSheet(
                                            context,
                                            child: VoteOptionModal(voteFee:  '${poll.feePerVote}',choiceId: '${e.id}',
                                              pollId: '${poll.id}',candidateName: '${e.text}',
                                              votingLink: '${poll.url}',),
                                          );
                                        }
                                      }))
                          ],
                        ),
                        const Gap(10),
                        //...poll.choices!.map((e)=>
                        WayaButton(
                          callback: (){
                            //WayaNav.to(PollDashboard(pollId: '${poll.choices?[index].pollId}',));
                            WayaNav.toNamed('/poll-dashboard',
                                arguments: '${poll.id}'
                              // arguments: '${poll.choices?[index].pollId}'
                            );
                          },
                          text: 'Manage Poll',
                        ),
                        //)
                      ],),
                  );
                });
          }),



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

  presImage(img, name, ctx, chk, voteFee, choiceId, pollId,candidateName, votingLink, onTap){
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        onTap: onTap,
        //     (){
        //   WayaUtils.showModalSheet(
        //     ctx,
        //     child: VoteOptionModal(voteFee: voteFee,choiceId: choiceId, pollId: pollId,candidateName: candidateName,
        //     votingLink:votingLink ,),
        //   );
        // },
        child: Container(
          padding: EdgeInsets.only(left: 20.w, bottom: 0),
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
              fontFamily: WayaConstants.fontFamily,
              fontWeight: FontWeight.w400,
              fontSize: 14,
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