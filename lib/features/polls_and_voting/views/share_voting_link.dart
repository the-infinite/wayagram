

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';


class ShareVotingLink extends ConsumerStatefulWidget {
  static const route = '/share-voting';
  const ShareVotingLink({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShareVotingLinkState();
}

class _ShareVotingLinkState extends ConsumerState<ShareVotingLink>  {

  String fil = '';
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    //final dynamic url  = ModalRoute.of(context)?.settings.arguments;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final url  = ModalRoute.of(context)?.settings.arguments as String?;
      ref.read(createPollVotingProvider.notifier).getPollsByUrl(url!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPollVotingProvider);
    //final poll = ref.watch(createPollVotingProvider.notifier);
    //final wayaTheme = Theme.of(context);
    return WayaScaffold(
      removeAppBar: true,
        backgroundColor: WayaColors.success,
        isLoading: false,
        isScrollable: true,
        body: Padding(
          padding: EdgeInsets.only(top: 70.h),
          child: Column(
            children: [
              Screenshot(
                controller: screenshotController,
                child: Container(
                  //padding: EdgeInsets.only(left: 10.w),
                  color:WayaColors.success,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Center(child: Image.asset('assets/images/successugt.png',)),
                      const Gap(30),
                      Center(
                        child: Text(
                          'Who is the current president of\nnigeria?',
                          style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.white ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Gap(5),
                      Text(
                        'Fasas has participated in this poll and is recommending you take part in the poll',
                        style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.white,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: viewModel.voteUrlData?.choices?.length,
                          itemBuilder: (context, index){
                            final poll = viewModel.voteUrlData?.choices?[index];
                            return  voteCount('${poll?.imageUrl}', '${poll?.text?.capitalizeFirst}', context, '', 50.w);
                          }),

                      const Gap(40),
                      // voteCount('assets/images/polls/azikwe.png', 'Dr Nnamdi Azikwe', context, '50', 266.0.h),
                      // const Gap(10),
                      // voteCount('assets/images/polls/tinubu.png', 'Bola Ahmed Tinubu', context, '40', 285.0.h),
                      // const Gap(10),
                      // voteCount('assets/images/polls/buhari.png', 'Mohammed\nBuhari', context, '10', 193.0.h),
                      // const Gap(80),

                    ],
                  ),
                ),
              ),
              WayaButton(
                border: Border.all(color: WayaColors.greyColor300),
                color: WayaColors.success,
                callback: () => screenshotNSend(context),
                text: "Share Voting Invitation",
                textColor: WayaColors.white,
              ),
            ],
          ),
        ) );
  }
//   Widget _scoreCard(){
//     return Center(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Circular Percent Indicator
//           LinearPercentIndicator(
//             percent: 0.7, // 70% indicator
//             center: Image.asset(
//               'assets/images/polls/tinubu.png', // Replace with your image path
//               width: 40,
//               height: 40,
//             ),
//             progressColor: Colors.blue,
//             backgroundColor: Colors.grey.shade300,
//           ),
//           const SizedBox(width: 16), // Space between widgets
//           // Text Widget
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children:  [
//               Text(
//                 "Profile Progress",
//                 style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 "70% completed",
//                 style: TextStyle(fontSize: 14.sp, color: Colors.grey),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

  screenshotNSend(ctx) async{
    final directory = (await getApplicationDocumentsDirectory ()).path;
    String fileName = '${DateTime.now().microsecondsSinceEpoch.toString()}.png';
    String path = directory;
    screenshotController.captureAndSave(path, fileName:fileName).then((value) {
      setState(() {
        fil = '$path/$fileName';
      });

      XFile file = XFile(fil);

      if(fil != ''){
        Share.shareXFiles([file], text: '');
      }
    });
  }

  voteCount(img, name, ctx, count, width){
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20.w),
          height: 60.h,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            Image.asset(img, height: 44.h,),
            const Gap(40),
            Text(
              name,
              style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: WayaColors.success),
            ),

          ],)

        ),
        const Gap(10),
        // Text(
        //   '$count%',
        //   style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
        //       fontSize: 20,
        //       fontWeight: FontWeight.w700,
        //       color: Theme.of(context).colorScheme.white ),
        //   textAlign: TextAlign.center,
        // ),
      ],
    );
  }

  choiceStatistics(img, name, ctx, chk, voteFee, choiceId,
      pollId,candidateName, votingLink, votePercentage, voteCount ){
    return voteCount == '0'? Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        // onTap: (){
        //   WayaUtils.showModalSheet(
        //     ctx,
        //     child: VoteOptionModal(voteFee:  voteFee,choiceId: choiceId,
        //       pollId: pollId,candidateName: candidateName,
        //       votingLink:votingLink,),
        //   );
        // },
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
                    fontSize: 14.sp,
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
                    fontSize: 14.sp,
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
              // WayaUtils.showModalSheet(
              //   ctx,
              //   child: VoteOptionModal(voteFee:  voteFee,choiceId: choiceId,
              //     pollId: pollId,candidateName: candidateName,
              //     votingLink:votingLink,),
              // );
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
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(ctx).colorScheme.white ),
                ),

              ],) : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    name,
                    style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                        fontSize: 14.sp,
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
                style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(ctx).colorScheme.black ),
              ),
              Text(
                '$voteCount votes',
                style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(ctx).colorScheme.greyColor500 ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
