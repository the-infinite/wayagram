//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:wayagram/core/components/components.dart';
// import 'package:wayagram/core/theme/extension/colors_extension.dart';
// import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
// import 'package:wayagram/core/theme/theme.dart';
// import 'package:wayagram/core/utils/utils.dart';
// import 'package:wayagram/features/polls_and_voting/data/model/get_poll_model.dart';
// import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';
//
// class PollWidget extends StatelessWidget {
//   final GetPollData getPollData;
//    const PollWidget({super.key, required this.getPollData});
//
//   @override
//   Widget build(BuildContext context) {
//     final wayaTheme = Theme.of(context);
//     return Container(
//       margin: EdgeInsets.only(bottom: 40.h),
//       //height: 400.h,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(children: [
//             Image.asset('assets/images/polls/rufai.png', height: 32.h,),
//             const Gap(3),
//             Text('', style: wayaTheme.textTheme.titleLarge),
//             const Gap(3),
//             Text(
//               ' • 2h ago',
//               style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: Theme.of(context).colorScheme.greyColor500 ),
//             ),
//
//             Spacer(),
//             Image.asset('assets/images/polls/menu.png', height: 32.h,),
//
//           ],),
//           const Gap(10),
//            Text("Who is the current president of nigeria?", style: wayaTheme.textTheme.titleLarge),
//
//           const Gap(3),
//
//           Text(
//             'I think we are all left with this question sometimes whenever we sleep sometimes.',
//             style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w400,
//                 color: Theme.of(context).colorScheme.greyColor500 ),
//           ),
//
//           const Gap(10),
//           Text(
//             '980 Votes • 23 hours 46 minutes remaining',
//             style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w400,
//                 color: Theme.of(context).colorScheme.greyColor500 ),
//           ),
//           const Gap(10),
//           // index == 0?
//           Column(
//             children: [
//               InkWell(
//                 splashColor: Colors.transparent,
//                 splashFactory: NoSplash.splashFactory,
//                 onTap: (){
//                   WayaUtils.showModalSheet(
//                     context,
//                     child: VoteOptionModal(voteFee: 9),
//                   );
//                 },
//                 child: Container(
//                   padding: EdgeInsets.only(left: 20.w),
//                   height: 60.h,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: WayaColors.primary600, ),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child:  Row(children: [
//                     WayaImage(imageUrl: 'img', height: 44.h),
//                     const Gap(40),
//                     Text(
//                       'name',
//                       style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Theme.of(context).colorScheme.primary600 ),
//                     ),
//
//                   ],)
//
//                 ),
//               ),
//               const Gap(10),
//             ],
//           )
//
//         ],),
//     );
//   }
// }
