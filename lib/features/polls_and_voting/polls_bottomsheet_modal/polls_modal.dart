// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/wallet/view/fund_wallet_options_screen.dart';

class PollsModal extends ConsumerStatefulWidget {
  final String url;
  const PollsModal({super.key, required this.url});

  @override
  ConsumerState<PollsModal> createState() => _PollsModalState();
}

class _PollsModalState extends ConsumerState<PollsModal> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/successugt.png',
            ),
            SizedBox(height: 20.h),
            Text(
              'Congratulations your\npoll is live!',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24.sp, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Text(
              "Share it with your audience and watch the votes roll in",
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 17.h),
            WayaButton(
              callback: () async {
                // await ref.read(createPollVotingProvider.notifier).getAllPolls(page: 1);
                WayaNav.toNamed('/poll-and-voting', arguments: {'poll': 'poll'});
                ref.read(createPollVotingProvider.notifier).reset();
              },
              text: "View Application Status",
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.primary600),
              color: Colors.white,
              callback: () async {
                Clipboard.setData(ClipboardData(text: widget.url));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Link copied to clipboard',
                      style: TextStyle(fontFamily: WayaConstants.fontFamily, fontSize: 12.sp),
                    ),
                    backgroundColor: WayaColors.primary,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              text: "Copy Contest Invite Link",
              textColor: WayaColors.primary600,
            ),
          ],
        ),
      ),
    );
  }
}

class VoteOptionModal extends ConsumerStatefulWidget {
  final String voteFee;
  final String choiceId;
  final String pollId;
  final String candidateName;
  final String votingLink;

  const VoteOptionModal(
      {super.key,
      required this.voteFee,
      required this.choiceId,
      required this.pollId,
      required this.candidateName,
      required this.votingLink});

  @override
  ConsumerState<VoteOptionModal> createState() => _VoteOptionModalState();
}

class _VoteOptionModalState extends ConsumerState<VoteOptionModal> {
  String amount = "0";

  final double maxAmount = 50000000;
  String? errorMessage;

  void _updateAmount(String value) {
    setState(() {
      if (amount == "0") {
        amount = value;
      } else {
        // Prevent leading zeros
        if (amount == "0") {
          amount = value;
        } else {
          if (amount.length > 8) return;
          amount += value;
        }
      }

      // Clear error when user starts typing again
      errorMessage = null;
    });
  }

  void _deleteAmount() {
    setState(() {
      if (amount.length > 1) {
        amount = amount.substring(0, amount.length - 1);
        if (amount.isEmpty) {
          amount = "0";
        }
      } else {
        amount = "0";
      }
      errorMessage = null;
    });
  }

  void _handleSubmit() async {
    // Convert amount string to double for comparison

    // Validate amount
    if (amount == "0.00" || amount == "0" || amount.startsWith("00")) {
      setState(() {
        errorMessage = "Please enter a valid amount";
      });
      return;
    } else {
      WayaNav.goBack();
      WayaUtils.showModalSheet(
        context,
        child: ConfirmVoteOptionModal(
          amountPaid: amount,
          voteFee: widget.voteFee,
          choiceId: widget.choiceId,
          pollId: widget.pollId,
          candidateName: widget.candidateName,
          votingLink: widget.votingLink,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vote Option',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24.sp, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Select the number of votes you want to cast.  ',
                    style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.greyColor500,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'Each vote costs ₦${widget.voteFee}',
                    style: TextStyle().wayaCopyWith(
                      color: WayaColors.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        if (amount != '0') {
                          int x = int.parse(amount) - 1;
                          amount = x.toString();
                        }
                      });
                    },
                    child: Image.asset(
                      'assets/images/polls/minus.png',
                      height: 56.h,
                    )),
                Text(
                  '${ref.read(createPollVotingProvider.notifier).formatAm(amount)}',
                  //amount,
                  style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                      fontSize: 48.sp,
                      fontWeight: FontWeight.w600,
                      color: amount == '0'
                          ? Theme.of(context).colorScheme.greyColor400
                          : Theme.of(context).colorScheme.black),
                  textAlign: TextAlign.center,
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        int x = int.parse(amount) + 1;
                        amount = x.toString();
                      });
                    },
                    child: Image.asset(
                      'assets/images/polls/plus.png',
                      height: 56.h,
                    )),
              ],
            ),
            const Gap(20),
            WayaButton(
              color: WayaColors.primary50,
              callback: () async {
                // WayaUtils.showModalSheet(
                //   context,
                //   child: PinEntryBottomSheet(),
                // );
              },
              //text: "Total: ₦${num.parse(amount)*100}",
              text: "Total: ₦${ref.read(createPollVotingProvider.notifier).formatAm(calculateAmount())}",
              textColor: WayaColors.primary,
            ),
            const Gap(20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                for (var i = 1; i <= 9; i++)
                  NumPadButton(
                    text: '$i',
                    onTap: () => _updateAmount('$i'),
                  ),
                NumPadButton(
                  icon: Icons.backspace_outlined,
                  onTap: _deleteAmount,
                ),
                NumPadButton(
                  text: '0',
                  onTap: () => _updateAmount('0'),
                ),
                NumPadButton(
                  icon: Icons.arrow_forward,
                  iconColor: wayaTheme.primaryColor,
                  onTap: _handleSubmit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  calculateAmount() {
    num x = 0;
    x = num.parse(widget.voteFee) * num.parse(amount);
    debugPrint(x.toString());
    return x;
  }
}

class PollPinEntryBottomSheet extends ConsumerStatefulWidget {
  final String voteFee;
  final String choiceId;
  final String pollId;
  final String candidateName;
  final String votingLink;
  final String amount;
  const PollPinEntryBottomSheet(
      {super.key,
      required this.voteFee,
      required this.pollId,
      required this.choiceId,
      required this.candidateName,
      required this.votingLink,
      required this.amount});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollPinEntryBottomSheetState();
}

class _PollPinEntryBottomSheetState extends ConsumerState<PollPinEntryBottomSheet> {
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

  // void _submitPin() {
  //   if (_pin.length == _pinLength) {
  //
  //     WayaNav.goBack();
  //
  //      WayaUtils.showModalSheet(
  //       context,
  //       child: DonationGenerosityModal(),
  //     );
  //
  //
  //
  //   }
  // }

  void _submitPin() async {
    if (_pin.length == _pinLength) {
      var isPass = await ref.read(createPollVotingProvider.notifier).verifyWalletPin(_pin, context);
      if (isPass) {
        debugPrint('Poll AMOUNT ${widget.amount}');
        await ref.read(createPollVotingProvider.notifier).castYourVote(
              '${num.parse(widget.amount) * num.parse(widget.voteFee)}',
              widget.amount,
              widget.choiceId,
              widget.pollId,
              context,
              widget.candidateName.toLowerCase().capitalizeFirst,
              widget.votingLink,
            );
      } else {
        WayaNav.goBack();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid pin',
              style: TextStyle(fontFamily: WayaConstants.fontFamily, fontSize: 12.sp),
            ),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(createPollVotingProvider.notifier);
    return SafeArea(
      child: Container(
        height: 490.h,
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
            Expanded(
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
                        child: const Icon(Icons.arrow_forward, color: Colors.black54),
                        onPressed: () {
                          //final userId = _wayaLocalDataSource.getUserId();
                          if (_pin.length == _pinLength) {
                            // viewModel.submitPins(context);
                            // viewModel.verifyWalletPin(_pin);
                            //WayaNav.goBack();
                            _submitPin();
                          }
                        }
                        // _submitPin,
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

class ConfirmVoteOptionModal extends ConsumerStatefulWidget {
  //final String quantity;
  final String amountPaid;
  final String voteFee;
  final String choiceId;
  final String pollId;
  final String candidateName;
  final String votingLink;
  //String amount;
  const ConfirmVoteOptionModal({
    super.key,
    required this.amountPaid,
    required this.voteFee,
    required this.choiceId,
    required this.pollId,
    required this.candidateName,
    required this.votingLink,
  });

  @override
  ConsumerState<ConfirmVoteOptionModal> createState() => _ConfirmVoteOptionModalState();
}

class _ConfirmVoteOptionModalState extends ConsumerState<ConfirmVoteOptionModal> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    ref.watch(createPollVotingProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vote Option',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24.sp, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Are you sure you want to cast ',
                    style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.greyColor500,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '${ref.read(createPollVotingProvider.notifier).formatAm(widget.amountPaid)} Votes ',
                    style: TextStyle().wayaCopyWith(
                      color: WayaColors.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'this would cost  ',
                    style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.greyColor500,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text:
                        '₦${ref.read(createPollVotingProvider.notifier).formatAm('${num.parse(widget.amountPaid) * num.parse(widget.voteFee)}')}',
                    style: TextStyle().wayaCopyWith(
                      color: WayaColors.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(200),
            /*WayaButton(
              callback: !viewModel.isLoading
                  ? () async {
                      await ref.read(createPollVotingProvider.notifier).castYourVote(
                          '${num.parse(widget.amountPaid) * num.parse(widget.voteFee)}',
                          widget.amountPaid,
                          //'118ff236-2410-4b84-8976-1e96f26a2d47','89b12d4a-9f16-49c8-8592-8ff7402246f3',
                          widget.choiceId,
                          widget.pollId,
                          context,
                          widget.candidateName.toLowerCase().capitalizeFirst,
                          widget.votingLink);
                    }
                  : null,
              centerWidget: LoadingState(loading: viewModel.isLoading, text: 'Yes, Vote'),
            ),*/
            WayaButton(
                callback: () {
                  WayaNav.goBack();
                  WayaUtils.showModalSheet(context,
                      child: PollPinEntryBottomSheet(
                        voteFee: widget.voteFee,
                        pollId: widget.pollId,
                        choiceId: widget.choiceId,
                        candidateName: widget.candidateName,
                        votingLink: widget.votingLink,
                        amount: widget.amountPaid,
                      ));
                },
                text: 'Yes, Vote'),
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

class VoteSuccessModal extends ConsumerStatefulWidget {
  final String candidateName;
  final String votingLink;
  final String pollId;
  const VoteSuccessModal({super.key, required this.candidateName, required this.votingLink, required this.pollId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VoteSuccessModalState();
}

class _VoteSuccessModalState extends ConsumerState<VoteSuccessModal> {
  @override
  Widget build(BuildContext context) {
    ref.watch(createPollVotingProvider);
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/polls/vote.png',
              height: 116.h,
            ),
            SizedBox(height: 20.h),
            Text(
              'Thank you for voting!\nYour support means everything',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24.sp, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Text(
              "I just voted for ${widget.candidateName.toLowerCase().capitalizeFirst}! Join me in supporting them. #VoteNow",
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            WayaButton(
              callback: () async {
                WayaNav.goBack();
                WayaNav.toNamed("/poll-and-voting");
              },
              text: "Return to Polls Page",
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.greyColor300),
              color: Colors.white,
              callback: () async {
                debugPrint('YOUR URL ${widget.votingLink}');
                Share.share(
                  WayaValueHelper.getShareableUrl(WayaAppRoutes.getPollDetailsPage(widget.pollId)),
                  subject: 'Share Poll',
                );
                Share.share(widget.votingLink);

                //WayaNav.toNamed('/share-voting', arguments: widget.votingLink);
              },
              text: "Share Voting Invitation",
              textColor: WayaColors.black,
            ),
          ],
        ),
      ),
    );
  }
}

class VoteSuccessModalTwo extends ConsumerStatefulWidget {
  final String candidateName;
  final String votingLink;
  final String pollId;
  const VoteSuccessModalTwo({super.key, required this.candidateName, required this.votingLink, required this.pollId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VoteSuccessModalTwoState();
}

class _VoteSuccessModalTwoState extends ConsumerState<VoteSuccessModalTwo> {
  @override
  Widget build(BuildContext context) {
    ref.watch(createPollVotingProvider);
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/polls/vote.png',
              height: 116.h,
            ),
            SizedBox(height: 20.h),
            Text(
              'Thank you for voting!\nYour support means everything',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24.sp, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Text(
              "I just voted for ${widget.candidateName.toLowerCase().capitalizeFirst}! Join me in supporting them. #VoteNow",
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            WayaButton(
              callback: () async {
                WayaNav.goBack();
                WayaNav.toNamed("/poll-and-voting");
              },
              text: "Return to Polls Page",
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.greyColor300),
              color: Colors.white,
              callback: () async {
                debugPrint('YOUR URL ${widget.votingLink}');
                Share.share(
                  WayaValueHelper.getShareableUrl(WayaAppRoutes.getPollDetailsPage(widget.pollId)),
                  subject: 'Share Poll',
                );
                //Share.share(widget.votingLink);

                //WayaNav.toNamed('/share-voting', arguments: widget.votingLink);
              },
              text: "Share Voting Invitation",
              textColor: WayaColors.black,
            ),
          ],
        ),
      ),
    );
  }
}

class VoteInsufficientModal extends StatefulWidget {
  const VoteInsufficientModal({super.key});

  @override
  State<VoteInsufficientModal> createState() => _VoteInsufficientModalState();
}

class _VoteInsufficientModalState extends State<VoteInsufficientModal> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/polls/cancel.png',
              height: 116.h,
            ),
            SizedBox(height: 20.h),
            Text(
              'Insufficient Funds',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24.sp, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Text(
              "It seems your wallet balance isn't sufficient to cast your vote. Top up your wallet to proceed.",
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            WayaButton(
              callback: () async {
                WayaNav.goBack();
                WayaNav.toNamed(FundWalletOptionsScreen.route);
              },
              text: "Fund Wallet",
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.greyColor300),
              color: Colors.white,
              callback: () async {
                WayaNav.goBack();
                WayaNav.toNamed("/poll-and-voting");
              },
              text: "Go Back to Polls",
              textColor: WayaColors.black,
            ),
          ],
        ),
      ),
    );
  }
}

class NumPadButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  const NumPadButton({
    super.key,
    this.text,
    this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
        side: BorderSide(
          color: backgroundColor != null ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Center(
          child: icon != null
              ? Icon(
                  icon,
                  color: iconColor ?? Colors.grey.shade600,
                )
              : Text(
                  text!,
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.grey.shade800,
                  ),
                ),
        ),
      ),
    );
  }
}

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({super.key});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Container(
          height: 230,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Payment Information',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .wayaCopyWith(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.black),
                ),
                const Gap(15),
                Text(
                  'Waya will take a commission from the payment and the rest of the money will be paid into your account at the end of post duration or its expiry date.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .wayaCopyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.black),
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        WayaNav.goBack();
                        WayaUtils.showModalSheet(
                          context,
                          child: PollsModal(
                            url: '',
                          ),
                        );
                      },
                      child: Text(
                        'Ok, I Agree',
                        style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: WayaColors.primary,
                            ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
