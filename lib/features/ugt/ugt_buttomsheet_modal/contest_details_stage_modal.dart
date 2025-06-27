import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';
import 'package:wayagram/features/ugt/my_contest_details/admin_contest_details.dart';

import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';
import 'package:wayagram/features/ugt/ugt_buttomsheet_modal/successful_modal.dart';

import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/features/ugt/widgets/contest_card.dart';

import '../../../core/components/waya_buttons.dart';
import '../../../core/utils/waya_navigation.dart';
import '../widgets/upcoming_widgets/upcoming_widget.dart';

class ContestDetailsStageModal extends StatefulHookConsumerWidget {
  final Stage? post;
  final MyContestContestantModel? model;
  // String stageName;
  // final Function( BuildContext,WidgetRef) onTap;
  const ContestDetailsStageModal({required this.post, required this.model, /*  required this.stageName, */ super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ApplicationStatusState();
}

class _ApplicationStatusState extends ConsumerState<ContestDetailsStageModal> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    var viewModel = ref.watch(votersContestNotifier.notifier);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Application Status", style: wayaTheme.textTheme.bodyMedium),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              "Stay updated with the progress of your Contests application. Below are the details and current status of your submission",
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.start,
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UpcomingWidget(title: "Next stage name", content: widget.post?.stageName ?? ""),
                // const Gap(20),
                UpcomingWidget(title: "Start date", content: formatDate(widget.post?.startDate ?? "")),
                //  const Gap(20),
                UpcomingWidget(title: "End date", content: formatDate(widget.post?.endDate ?? "")),
                /*   const Gap(20),
                UpcomingWidget(
                    title: "Duration",
                    content: widget.post?.contest?.durationType ?? ""), */
              ],
            ),
            _lineThick(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UpcomingWidget(title: "Entry type", content: widget.post?.entryType ?? ""),
                //  const Gap(20),
                UpcomingWidget(
                    title: "Entry fee", content: "₦${formatMoney(widget.post?.entryAmount?.toString() ?? "")}"),
                //   const Gap(20),
                UpcomingWidget(
                  title: "Vote to qualify",
                  content: widget.post?.voteCountToQualify?.toString() ?? "",
                  status: true,
                ),
                /*   const Gap(20),
                UpcomingWidget(
                    title: "Duration",
                    content: widget.post?.contest?.durationType ?? ""), */
              ],
            ),
            const Gap(20),
            WayaButton(
              callback: () async {
                if (widget.post?.entryType?.toLowerCase() != "free") {
                  WayaNav.goBack();
                  WayaUtils.showModalSheet(
                    context,
                    child: AvailableBalanceModal(
                      voteCount: "0",
                      model: widget.model,
                      voteFee: widget.post?.entryAmount?.toString() ?? "0",
                      // model: widget.model,
                      stageName: widget.post?.stageName ?? "",
                      votingLink: "",
                      onTap: () {
                        debugPrint("i am on the verge");
                      },
                      candidateName: "",
                    ),
                  );
                } else {
                  viewModel.acceptPaidStageContest(widget.model?.contestId ?? "", {
                    "contestId": widget.model?.contestId ?? "",
                    "stageName": widget.post?.stageName ?? "",
                    "profileId": widget.model?.profileId ?? "",
                  });
                  WayaNav.goBack();
                  WayaUtils.showModalSheetUgt(
                    context,
                    child: SuccessfulModal(
                      title: "You’re In! 🎉",
                      subtitle:
                          "No payment needed—your spot in the next round is secured. Get ready to bring your A-game!",
                      showCopyLink: false,
                      buttonText: "Go to Contest Dashboard",
                      onTap: (myContext, myRef) {
                        //  WayaNav.goBack();
                        debugPrint("i am cooking");

                        // WayaNav.goBack();

                        viewModel.fetchAllContestApplicant(widget.model?.contestId ?? "");

                        WayaNav.removeAllUntil(AdminContestDetails(id: ""), AdminContestDetails.route);
                      },
                    ),
                  );
                }
              },
              text: widget.post?.entryType?.toLowerCase() == "free" ? "Continue" : "Proceed to payment",
            ),
            const Gap(10),
            WayaButton(
              text: 'Go Back',
              color: wayaTheme.colorScheme.greyColor300,
              textColor: wayaTheme.colorScheme.customBlack,
              border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
              callback: () {},
            )
          ],
        ),
      ),
    );
  }

  _lineThick() {
    return Column(
      children: [
        const Gap(5),
        Container(
          height: 2, // Thickness of the line
          width: double.infinity, // Full width
          color: Color(0xffF0F2F5), // Line color
        ),
        const Gap(5),
      ],
    );
  }
}

class AvailableBalanceModal extends StatefulHookConsumerWidget {
  //final String quantity;
  final String voteCount;
  final String voteFee;

  final String candidateName;
  final String stageName;
  final String votingLink;
  final Function() onTap;
  final MyContestContestantModel? model;

  //String amount;
  const AvailableBalanceModal({
    super.key,
    required this.voteFee,
    required this.voteCount,
    required this.stageName,
    required this.candidateName,
    this.model,
    required this.onTap,
    required this.votingLink,
  });

  @override
  ConsumerState<AvailableBalanceModal> createState() => _AvailableBalanceModalState();
}

class _AvailableBalanceModalState extends ConsumerState<AvailableBalanceModal> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //  ref.read(contestNotifierProvider.notifier).allCategories();
      ref.read(votersContestNotifier.notifier).getUserWallet();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(votersContestNotifier);
    final isLoading = useState(false);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pay for contest',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24.sp, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Are you sure you want to pay for the contest that will cost ',
                    style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.greyColor500,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  /*  TextSpan(
                    text: '${widget.voteCount} Votes ',
                    style: TextStyle().wayaCopyWith(
                      color: WayaColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ), */
                  /*  TextSpan(
                    text: 'For ',
                    style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.greyColor500,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '${widget.candidateName} ',
                    style: TextStyle().wayaCopyWith(
                      color: WayaColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ), */
                  /*   TextSpan(
                    text: 'this would cost  ',
                    style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.greyColor500,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ), */
                  TextSpan(
                    text: '₦${formatMoney(' ${num.parse(widget.voteFee)}')}?',
                    style: TextStyle().wayaCopyWith(
                      color: WayaColors.primary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Gap(30),
            Container(
              // width: 200,
              height: 150,
              decoration: BoxDecoration(
                color: WayaColors.primary50,
                borderRadius: BorderRadius.circular(20), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Available Balance',
                      style: TextStyle().wayaCopyWith(
                        // color: WayaColors.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Gap(5),
                    Container(
                      // width: 200,
                      height: 80,
                      decoration: BoxDecoration(
                        color: WayaColors.white,
                        borderRadius: BorderRadius.circular(6), // Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Wallet Balance',
                              style: TextStyle().wayaCopyWith(
                                color: WayaColors.greyColor500,
                                fontSize: 14.sp.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '₦${formatMoney(viewModel.data?.balance ?? "00")}',
                                  style: TextStyle().wayaCopyWith(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  ".00",
                                  style: TextStyle().wayaCopyWith(
                                    color: WayaColors.greyColor400,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(50),
            WayaButton(
              callback: !isLoading.value
                  ? () async {
                      WayaNav.goBack();
                      WayaUtils.showModalSheet(context,
                          child: PinEntryBottomSheet(
                            candidateName: widget.candidateName,
                            link: widget.votingLink,
                            model: widget.model,
                            stageName: widget.stageName,
                            onTap: widget.onTap,
                            amount: '${num.parse(widget.voteCount) * num.parse(widget.voteFee)}',
                            numOfVote: widget.voteCount,
                          ) /* PinVoteModal(
                          voteFee: "4",
                          choiceId: "45",
                          pollId: "dddssd",
                          votingLink: "link",
                          candidateName: "Jane Morphy",
                        ), */
                          );
                      /* await ref.read(createPollVotingProvider.notifier).castYourVote(
                   '${num.parse(widget.amountPaid)*num.parse(widget.voteFee)}',
                    widget.amountPaid,
                    //'118ff236-2410-4b84-8976-1e96f26a2d47','89b12d4a-9f16-49c8-8592-8ff7402246f3',
                    widget.choiceId, widget.pollId,
                   context,widget.candidateName.toLowerCase().capitalizeFirst, widget.votingLink);
                //
                ddddd */
                    }
                  : null,
              centerWidget: LoadingState(loading: isLoading.value, text: 'Yes, Pay'),
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.greyColor300),
              color: Colors.white,
              callback: () async {
                WayaNav.goBack();
              },
              text: "Go Back",
              textColor: WayaColors.black,
            ),
          ],
        ),
      ),
    );
  }
}

class PinEntryBottomSheet extends StatefulHookConsumerWidget {
  final String candidateName;
  final String link;
  final String amount;
  final String numOfVote;
  final String stageName;
  final MyContestContestantModel? model;

  final Function() onTap;

  const PinEntryBottomSheet(
      {required this.link,
      required this.amount,
      required this.numOfVote,
      required this.candidateName,
      required this.stageName,
      this.model,
      required this.onTap,
      super.key});

  @override
  _PinEntryBottomSheetState createState() => _PinEntryBottomSheetState();
}

class _PinEntryBottomSheetState extends ConsumerState<PinEntryBottomSheet> {
  String _pin = '';
  final int _pinLength = 4;

  void _addDigit(String digit) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += digit;
      });
    }
  }

  void _removeDigit() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _submitPin(BuildContext context1, ValueNotifier<bool> isLoading) async {
    if (_pin.length == _pinLength) {
      debugPrint("i dey here ee $_pin");
      //  WayaNav.goBack();

      var isPass = await ref.read(votersContestNotifier.notifier).verifyAndPayForPaidStageContest(isLoading, _pin, {
        "profileId": widget.model?.profileId ?? "",
        "contestId": widget.model?.contestId ?? "",
        "stageName": widget.stageName,
      });
      if (isPass) {
        // WayaNav.goBack();

        if (WayaNav.canPop()) {
          WayaNav.goBack();
        }

        WayaUtils.showModalSheetUgt(
          context,
          child: SuccessfulModal(
            title: "Payment Successful! 🎉",
            subtitle: "Your entry for the next round is confirmed. Best of luck!",
            showCopyLink: false,
            buttonText: "Go to Contest Dashboard",
            onTap: (myContext, myRef) {
              //  WayaNav.goBack();
              debugPrint("i am cooking");
              myRef.read(votersContestNotifier.notifier).fetchAllContestApplicant(widget.model?.contestId ?? "");
              // WayaNav.removeUntil(AdminContestDetails());
              WayaNav.removeAllUntil(AdminContestDetails(id: ""), AdminContestDetails.route);
              // WayaNav.goBack();
              //  WayaNav.toNamed("/create-profile-contest1");
            },
          ),
        );
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter your PIN',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            itemCount: _pinLength,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
                color: Colors.white,
              ),
              child: Center(
                child: index < _pin.length
                    ? Text("*",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ))
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 350.sp,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                if (index == 9) {
                  return _buildKeypadButton(
                    child: const Icon(Icons.backspace, color: Colors.black54),
                    onPressed: _removeDigit,
                  );
                } else if (index == 10) {
                  return _buildKeypadButton(
                    child: Text('0', style: TextStyle(fontSize: 20.sp)),
                    onPressed: () => _addDigit('0'),
                  );
                } else if (index == 11) {
                  return _buildKeypadButton(
                    child: isLoading.value
                        ? SizedBox(height: 40, width: 40, child: CircularProgressIndicator())
                        : const Icon(Icons.arrow_forward, color: Colors.black54),
                    onPressed: isLoading.value
                        ? () {
                            debugPrint(" i am so here");
                          }
                        : () {
                            debugPrint(" i am so noooooooot here");
                            //   widget.onTap();
                            _submitPin(context, isLoading);
                          },
                  );
                } else {
                  return _buildKeypadButton(
                    child: Text('${index + 1}', style: TextStyle(fontSize: 24.sp)),
                    onPressed: () => _addDigit('${index + 1}'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton({required Widget child, required VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48), side: BorderSide(color: Colors.grey[300]!, width: 1)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48), side: BorderSide(color: Colors.grey[300]!, width: 1)),
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
