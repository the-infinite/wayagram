import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/polls_and_voting/views/polls_and_votes.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/ugt/contest_profiles/contest_profile_page.dart';
import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';
import 'package:wayagram/features/ugt/data/model/contest_vote_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/features/wallet/view/wallet_page.dart';

import '../../../core/components/waya_buttons.dart';
import '../../../core/utils/waya_navigation.dart';

class PollsModal extends ConsumerStatefulWidget {
  const PollsModal({super.key});

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
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.black),
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
                WayaNav.removeUntil(PollAndVoting());
                ref.read(createPollVotingProvider.notifier).reset();
                // WayaNav.toNamed("/poll-and-voting");
              },
              text: "View Application Status",
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.primary600),
              color: Colors.white,
              callback: () async {
                //WayaNav.toNamed("/poll-dashboard");
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

class PinEntryBottomSheet extends StatefulHookConsumerWidget {
  final ContestVoteModel model;
  final String candidateName;
  final String link;
  final String amount;
  final String numOfVote;

  const PinEntryBottomSheet(
      {required this.model,
      required this.link,
      required this.amount,
      required this.numOfVote,
      required this.candidateName,
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

  void _submitPin(ValueNotifier<bool> isLoading) async {
    if (_pin.length == _pinLength) {
      // TODO: Submit PIN
      // log('PIN submitted: $_pin');
      // Navigator.of(context).pop();
      var isPass = await ref
          .read(votersContestNotifier.notifier)
          .verifyWalletPin(isLoading, _pin, {
        "contestId": widget.model.contestId ?? "",
        "contestantId": widget.model.contestantId ?? "",
        "hostUserId": widget.model.hostUserId ?? "",
        "amount": widget.amount,
        "numberOfVotes": widget.numOfVote,
        "profileId": widget.model.profileId ?? "",
        "type": widget.model.type ?? ""
      });

      if (isPass) {
        ref
            .read(votersContestNotifier.notifier)
            .getContestantProfileVoteDetails(
                ref.read(selectedContestProvider.notifier).state.id ?? "");
        Navigator.of(context).pop();
        WayaUtils.showModalSheet(context,
            child: VoteSuccessModal(
              candidateName: widget.candidateName,
              votingLink: "link",
            ));
      } else {
        /* WayaUtils.showModalSheet(context,
            child: VoteSuccessModal(
              candidateName: widget.candidateName,
              votingLink: "link",
            )); */
      }
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
          const Text(
            'Enter your PIN',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        style: const TextStyle(
                          fontSize: 24,
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
                    child: const Text('0', style: TextStyle(fontSize: 20)),
                    onPressed: () => _addDigit('0'),
                  );
                } else if (index == 11) {
                  return _buildKeypadButton(
                    child: isLoading.value
                        ? SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator())
                        : const Icon(Icons.arrow_forward,
                            color: Colors.black54),
                    onPressed: isLoading.value
                        ? () {
                            print(" i am so here");
                          }
                        : () {
                            print(" i am so noooooooot here");
                            _submitPin(isLoading);
                          },
                  );
                } else {
                  return _buildKeypadButton(
                    child: Text('${index + 1}',
                        style: const TextStyle(fontSize: 24)),
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

  Widget _buildKeypadButton(
      {required Widget child, required VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
          side: BorderSide(color: Colors.grey[300]!, width: 1)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
            side: BorderSide(color: Colors.grey[300]!, width: 1)),
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}

class VoteOptionModal extends ConsumerStatefulWidget {
  final String voteFee;

  final String candidateName;
  final String votingLink;
  final ContestVoteModel model;

  const VoteOptionModal(
      {super.key,
      required this.voteFee,
      required this.model,
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
    double numericAmount = double.tryParse(amount) ?? 0;

    // Validate amount
    if (amount == "0.00" || amount == "0" || amount.startsWith("00")) {
      setState(() {
        errorMessage = "Please enter a valid amount";
      });
      return;
    } else {
      Navigator.of(context).pop();
      print('$amount ${widget.voteFee}');
      WayaUtils.showModalSheet(
        context,
        child: ConfirmVoteOptionModal(
          amount: amount,
          voteFee: widget.voteFee,
          model: widget.model,
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
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.black),
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
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'Each vote costs ₦${widget.voteFee}',
                    style: TextStyle().wayaCopyWith(
                      color: WayaColors.primary,
                      fontSize: 12,
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
                      fontSize: 48,
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
              text:
                  "Total: ₦${ref.read(createPollVotingProvider.notifier).formatAm(calculateAmount())}",
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
    print(x);
    return x;
  }
}

class ConfirmVoteOptionModal extends ConsumerStatefulWidget {
  //final String quantity;
  final String amount;
  final String voteFee;

  final String candidateName;
  final String votingLink;
  final ContestVoteModel model;

  //String amount;
  const ConfirmVoteOptionModal(
      {super.key,
      required this.amount,
      required this.voteFee,
      required this.model,
      required this.candidateName,
      required this.votingLink});

  @override
  ConsumerState<ConfirmVoteOptionModal> createState() =>
      _ConfirmVoteOptionModalState();
}

class _ConfirmVoteOptionModalState
    extends ConsumerState<ConfirmVoteOptionModal> {
  final WayaLocalDataSource _wayaLocalDataSource = WayaLocalDataSource();

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPollVotingProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vote Option',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.black),
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
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text:
                        '${ref.read(createPollVotingProvider.notifier).formatAm(widget.amount)} Votes ',
                    style: TextStyle().wayaCopyWith(
                      color: WayaColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'this would cost  ',
                    style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.greyColor500,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text:
                        '₦${ref.read(createPollVotingProvider.notifier).formatAm('${num.parse(widget.amount) * num.parse(widget.voteFee)}')}',
                    style: TextStyle().wayaCopyWith(
                      color: WayaColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(200),
            WayaButton(
              callback: !viewModel.isLoading
                  ? () async {
                      Navigator.of(context).pop();
                      ref.watch(votersContestNotifier.notifier).getUserWallet();
                      print('${widget.amount} ${widget.voteFee}');
                      WayaUtils.showModalSheet(
                        context,
                        child: AvailableBalanceModal(
                          voteCount: widget.amount,
                          voteFee: widget.voteFee,
                          model: widget.model,
                          votingLink: widget.votingLink,
                          candidateName: widget.candidateName,
                        ),
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
              centerWidget:
                  LoadingState(loading: viewModel.isLoading, text: 'Yes, Vote'),
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.greyColor300),
              color: Colors.white,
              callback: () async {
                Navigator.of(context).pop();
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

//avialable balance
class AvailableBalanceModal extends StatefulHookConsumerWidget {
  //final String quantity;
  final String voteCount;
  final String voteFee;

  final String candidateName;
  final String votingLink;
  final ContestVoteModel model;

  //String amount;
  const AvailableBalanceModal(
      {super.key,
      required this.voteFee,
      required this.voteCount,
      required this.model,
      required this.candidateName,
      required this.votingLink});

  @override
  ConsumerState<AvailableBalanceModal> createState() =>
      _AvailableBalanceModalState();
}

class _AvailableBalanceModalState extends ConsumerState<AvailableBalanceModal> {
  final WayaLocalDataSource _wayaLocalDataSource = WayaLocalDataSource();

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
              'Vote Contestant',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.black),
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
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '${widget.voteCount} Votes ',
                    style: TextStyle().wayaCopyWith(
                      color: WayaColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
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
                  ),
                  TextSpan(
                    text: 'this would cost  ',
                    style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.greyColor500,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text:
                        '₦${formatMoney('${num.parse(widget.voteCount) * num.parse(widget.voteFee)}')}?',
                    style: TextStyle().wayaCopyWith(
                      color: WayaColors.primary,
                      fontSize: 14,
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
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Gap(5),
                    Container(
                      // width: 200,
                      height: 80,
                      decoration: BoxDecoration(
                        color: WayaColors.white,
                        borderRadius:
                            BorderRadius.circular(6), // Rounded corners
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
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '₦${formatMoney(viewModel.data?.balance ?? "00")}',
                                  style: TextStyle().wayaCopyWith(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  ".00",
                                  style: TextStyle().wayaCopyWith(
                                    color: WayaColors.greyColor400,
                                    fontSize: 12,
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
                      Navigator.of(context).pop();
                      WayaUtils.showModalSheet(context,
                          child: PinEntryBottomSheet(
                            model: widget.model,
                            candidateName: widget.candidateName,
                            link: widget.votingLink,
                            amount:
                                '${num.parse(widget.voteCount) * num.parse(widget.voteFee)}',
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
              centerWidget:
                  LoadingState(loading: isLoading.value, text: 'Yes, Vote'),
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.greyColor300),
              color: Colors.white,
              callback: () async {
                Navigator.of(context).pop();
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

//
class VoteSuccessModal extends ConsumerStatefulWidget {
  final String candidateName;
  final String votingLink;
  const VoteSuccessModal(
      {super.key, required this.candidateName, required this.votingLink});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VoteSuccessModalState();
}

class _VoteSuccessModalState extends ConsumerState<VoteSuccessModal> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPollVotingProvider);
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
            /*  Text(
              'Thank you for voting for \nYour support means everything',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.black),
              textAlign: TextAlign.center,
            ), */
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Thank you for voting for ',
                    style: TextStyle().wayaCopyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.black,
                    ),
                  ),
                  TextSpan(
                    text: widget.candidateName,
                    style: TextStyle().wayaCopyWith(
                      color: WayaColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: '! Your support means everything',
                    style: TextStyle().wayaCopyWith(
                      color: Theme.of(context).colorScheme.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            /*   Text(
              "I just voted for ${widget.candidateName.toLowerCase().capitalizeFirst}! Join me in supporting them. #VoteNow",
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.center,
            ), */
            SizedBox(height: 30.h),
            WayaButton(
              callback: () async {
                Navigator.of(context).pop();
                //  WayaNav.toNamed("/poll-and-voting");
              },
              text: "Return to Contest Page",
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.greyColor300),
              color: Colors.white,
              callback: () async {
                print('YOUR URL ${widget.votingLink}');
                Share.share(widget.votingLink);

                //WayaNav.toNamed('/share-voting', arguments: widget.votingLink);
              },
              text: "Share",
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
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.black),
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
                WayaNav.toNamed(WalletPage.route);
                //WayaNav.toNamed("/poll-and-voting");
              },
              text: "Fund Wallet",
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.greyColor300),
              color: Colors.white,
              callback: () async {
                //WayaNav.toNamed("/poll-dashboard");
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
          color: backgroundColor != null
              ? Colors.transparent
              : Colors.grey.shade300,
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
                    fontSize: 24,
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
  _PaymentDialogState createState() => _PaymentDialogState();
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
                  style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                const Gap(15),
                Text(
                  'Waya will take a commission from the payment and the rest of the money will be paid into your account at the end of post duration or its expiry date.',
                  style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        WayaUtils.showModalSheet(
                          context,
                          child: PollsModal(),
                        );
                      },
                      child: Text(
                        'Ok, I Agree',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .wayaCopyWith(
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


