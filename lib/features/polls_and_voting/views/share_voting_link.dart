

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPollVotingProvider);
    final wayaTheme = Theme.of(context);
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
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.white ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Gap(5),
                      Text(
                        'Fasas has participated in this poll and is recommending you take part in the poll',
                        style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.white,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const Gap(40),
                      voteCount('assets/images/polls/azikwe.png', 'Dr Nnamdi Azikwe', context, '50', 266.0.h),
                      const Gap(10),
                      voteCount('assets/images/polls/tinubu.png', 'Bola Ahmed Tinubu', context, '40', 285.0.h),
                      const Gap(10),
                      voteCount('assets/images/polls/buhari.png', 'Mohammed\nBuhari', context, '10', 193.0.h),
                      const Gap(80),

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
  Widget _scoreCard(){
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular Percent Indicator
          LinearPercentIndicator(
            percent: 0.7, // 70% indicator
            center: Image.asset(
              'assets/images/polls/tinubu.png', // Replace with your image path
              width: 40,
              height: 40,
            ),
            progressColor: Colors.blue,
            backgroundColor: Colors.grey.shade300,
          ),
          const SizedBox(width: 16), // Space between widgets
          // Text Widget
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Profile Progress",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "70% completed",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: WayaColors.success),
            ),

          ],)

        ),
        const Gap(10),
        Text(
          '$count%',
          style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.white ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
 }
