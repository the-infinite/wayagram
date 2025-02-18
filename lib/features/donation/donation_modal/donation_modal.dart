

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';

import '../../../core/components/components.dart';
import '../../polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';

class DonationModal extends ConsumerStatefulWidget {
  final String voteFee;
  final String choiceId;
  final String pollId;
  final String candidateName;
  final String votingLink;

  const DonationModal({super.key, required this.voteFee, required this.choiceId,
    required this.pollId, required this.candidateName, required this.votingLink});

  @override
  ConsumerState<DonationModal> createState() => _DonationModalState();
}

class _DonationModalState extends ConsumerState<DonationModal> {

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
    }else{
      Navigator.of(context).pop();
 /*     WayaUtils.showModalSheet(
        context,
        child: ConfirmVoteOptionModal(amountPaid: amount, voteFee: widget.voteFee,
          choiceId: widget.choiceId, pollId: widget.pollId,
          candidateName: widget.candidateName, votingLink: widget.votingLink,),
      );*/
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
                        if(amount != '0' ){
                          int x = int.parse(amount) - 1;
                          amount = x.toString();
                        }

                      });
                    },
                    child: Image.asset(
                      'assets/images/polls/minus.png',
                      height: 56.h,
                    )),
                Text('',
                  //'${ref.read(createPollVotingProvider.notifier).formatAm(amount)}',
                  //amount,
                  style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                      color: amount == '0' ?Theme.of(context).colorScheme.greyColor400 : Theme.of(context).colorScheme.black),
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
              //text: "Total: ₦${ref.read(createPollVotingProvider.notifier).formatAm(calculateAmount())}",
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
    x = num.parse(widget.voteFee)*num.parse(amount);
    print(x);
    return x;
  }
}
