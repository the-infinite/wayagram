import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:svg_flutter/svg.dart';
//import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/wallet/view/wallet_page.dart';
import 'package:wayagram/shared/components/engagement_range.dart';

import '../../../core/components/components.dart';
import '../../polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';

class DonationModal extends ConsumerStatefulWidget {
  final String amountRaised;
  final String targetAmount;
  final String title;
  final String campaignId;
  final String privacy;
  final String daysLeft;
  final String donationCount;
  final String minimumDonationAmount;
  const DonationModal(
      {super.key,
      required this.amountRaised,
      required this.targetAmount,
      required this.title,
      required this.campaignId,
      required this.privacy,
      required this.minimumDonationAmount,
      required this.daysLeft,
      required this.donationCount});

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
    // double numericAmount = double.tryParse(amount) ?? 0;

    // Validate amount
    if (amount == "0.00" || amount == "0" || amount.startsWith("00")) {
      setState(() {
        errorMessage = "Please enter a valid amount";
      });
      return;
    } else if (num.parse(amount) < num.parse(widget.minimumDonationAmount.replaceAll('.00', ''))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Minimum donation amount is ${widget.minimumDonationAmount}'),
          backgroundColor: WayaColors.primary,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      WayaNav.goBack();
      WayaUtils.showModalSheet(context,
          child: DonationPinEntryBottomSheet(
            amount: amount,
            campaignId: widget.campaignId,
            campaignTitle: widget.title,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Donate',
                style: wayaTheme.textTheme.bodyMedium!
                    .wayaCopyWith(fontSize: 24.sp, fontWeight: FontWeight.w700, color: wayaTheme.colorScheme.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.title,
                      style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.greyColor500,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration:
                    BoxDecoration(color: WayaColors.greyColor50, borderRadius: BorderRadius.all(Radius.circular(12))),
                child: EngagementRange(
                    topLeft:
                        "${WayaHelpers.formatPrice(int.parse(widget.amountRaised))} raised from ${WayaHelpers.formatPrice(int.parse(widget.targetAmount))} ",
                    bottomLeft: "${widget.donationCount} Donations",
                    bottomRight: "${widget.daysLeft} ${widget.daysLeft == '1' ? 'day' : 'days'} left",
                    range: widget.donationCount == '0' ? 0.0 : 0.4),
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
                    //'${ref.read(createPollVotingProvider.notifier).formatAm(amount)}',
                    amount,
                    style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                        fontSize: 48.sp,
                        fontWeight: FontWeight.w600,
                        color: amount == '0' ? wayaTheme.colorScheme.greyColor400 : wayaTheme.colorScheme.black),
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
              Container(
                height: 40,
                width: double.infinity,
                decoration:
                    BoxDecoration(color: WayaColors.greyColor50, borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Minimum Donation Amount: ',
                          style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.greyColor500,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: WayaHelpers.formatPrice(int.parse(widget.minimumDonationAmount.replaceAll('.00', ''))),
                          style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.greyColor500,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
      ),
    );
  }

  calculateAmount() {
    num x = 0;
    //x = num.parse(widget.voteFee)*num.parse(amount);
    debugPrint(x.toString());
    return x;
  }
}

class DonationPinEntryBottomSheet extends ConsumerStatefulWidget {
  final String amount;
  final String campaignId;
  final String campaignTitle;
  const DonationPinEntryBottomSheet(
      {super.key, required this.amount, required this.campaignId, required this.campaignTitle});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DonationPinEntryBottomSheetState();
}

class _DonationPinEntryBottomSheetState extends ConsumerState<DonationPinEntryBottomSheet> {
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
      var isPass = await ref.read(donationVmProvider.notifier).verifyWalletPin(_pin, context);

      if (isPass) {
        //WayaNav.goBack();
        debugPrint('DOANTION AMOUNT ${widget.amount}');
        await ref.watch(donationVmProvider.notifier).makeDonation(
            widget.campaignId,
            int.parse(widget.amount),
            //widget.amount,
            widget.campaignTitle,
            context);
        WayaUtils.showModalSheet(
          context,
          child: DonationGenerosityModal(),
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

  //final WayaLocalDataSource _wayaLocalDataSource = WayaLocalDataSource();

  @override
  Widget build(BuildContext context) {
    //debugPrint('DARLINGTON AMOUNT ${widget.amount}');
    //final viewModel = ref.watch(donationVmProvider.notifier);
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

class DonationSuccessModal extends ConsumerStatefulWidget {
  final String url;
  const DonationSuccessModal({super.key, required this.url});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DonationSuccessModalState();
}

class _DonationSuccessModalState extends ConsumerState<DonationSuccessModal> {
  @override
  Widget build(BuildContext context) {
    //final viewModel = ref.watch(donationVmProvider);
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/success.png',
              height: 116.h,
            ),
            SizedBox(height: 20.h),
            Text(
              'Your Donation has Been Posted Successfully',
              style: wayaTheme.textTheme.bodyMedium!
                  .wayaCopyWith(fontSize: 24.sp, fontWeight: FontWeight.w700, color: wayaTheme.colorScheme.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Text(
              "Your cause is now live! Share it with others to maximize impact and start making a difference",
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            WayaButton(
              callback: () async {
                WayaNav.goBack();
                WayaNav.toNamed("/donations");
                ref.read(donationVmProvider.notifier).reset();
              },
              text: "Go to Donations",
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.greyColor300),
              color: Colors.white,
              callback: () async {
                WayaNav.goBack();
                Share.share(widget.url);
              },
              text: "Share Donation Link",
              textColor: WayaColors.black,
            ),
          ],
        ),
      ),
    );
  }
}

class DonationUnSuccessfulModal extends ConsumerStatefulWidget {
  const DonationUnSuccessfulModal({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DonationUnSuccessfulModalState();
}

class _DonationUnSuccessfulModalState extends ConsumerState<DonationUnSuccessfulModal> {
  @override
  Widget build(BuildContext context) {
    //final viewModel = ref.watch(donationVmProvider);
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/d-code-invalid.png',
              height: 116.h,
            ),
            SizedBox(height: 20.h),
            Text(
              'Donation Unsuccessful',
              style: wayaTheme.textTheme.bodyMedium!
                  .wayaCopyWith(fontSize: 24.sp, fontWeight: FontWeight.w700, color: wayaTheme.colorScheme.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Text(
              "Payment failed. Top up your WayaGram Wallet to complete your Donation seamlessly",
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            WayaButton(
              callback: () async {
                WayaNav.goBack();
                WayaNav.toNamed(WalletPage.route);
                ref.read(donationVmProvider.notifier).reset();
              },
              text: "Fund Your Wallet",
              trailingIcon: SvgPicture.asset('assets/images/fund_wallet.svg'),
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.greyColor300),
              color: Colors.white,
              callback: () async {
                WayaNav.goBack();
              },
              text: "Cancel",
              textColor: WayaColors.black,
            ),
          ],
        ),
      ),
    );
  }
}

class DonationGenerosityModal extends ConsumerStatefulWidget {
  const DonationGenerosityModal({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DonationGenerosityModalState();
}

class _DonationGenerosityModalState extends ConsumerState<DonationGenerosityModal> {
  @override
  Widget build(BuildContext context) {
    //final viewModel = ref.watch(donationVmProvider);
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/generosity.png',
              height: 116.h,
            ),
            SizedBox(height: 20.h),
            Text(
              'Thank You for Your Generosity!',
              style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: WayaConstants.fontFamily,
                  color: wayaTheme.colorScheme.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Text(
              "Your donation has been successfully processed. Together, we're making a difference!",
              style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: WayaConstants.fontFamily,
                  color: wayaTheme.colorScheme.greyColor500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            WayaButton(
              callback: () async {
                WayaNav.goBack();
                WayaNav.toNamed("/donations");
                ref.read(donationVmProvider.notifier).reset();
              },
              text: "Return to Donation Post",
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.greyColor300),
              color: Colors.white,
              callback: () async {
                Share.share('hh');
              },
              text: "Share Invite to Other",
              textColor: WayaColors.black,
            ),
          ],
        ),
      ),
    );
  }
}

class DonationAmountSetupModal extends ConsumerStatefulWidget {
  final String id;
  const DonationAmountSetupModal({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DonationAmountSetupModalState();
}

class _DonationAmountSetupModalState extends ConsumerState<DonationAmountSetupModal> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(donationVmProvider);
    final wayaTheme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              Text(
                'Set Your Minimum Donation Amount',
                style: wayaTheme.textTheme.bodyMedium!
                    .wayaCopyWith(fontSize: 24.sp, fontWeight: FontWeight.w700, color: wayaTheme.colorScheme.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              Text(
                "Define the smallest contribution required to support your cause",
                style: wayaTheme.textTheme.hintStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Divider(
                    color: WayaColors.greyColor300,
                    height: 1,
                  ),
                  Text(
                    "Enter Amount",
                    style: wayaTheme.textTheme.bodyMedium!
                        .wayaCopyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: wayaTheme.colorScheme.black),
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    color: WayaColors.greyColor300,
                    height: 1,
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormField<String>(validator: (value) {
                        if (viewModel.amount.text.isEmpty) {
                          return 'Amount is required';
                        }

                        return null;
                      }, builder: (formState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WayaTextFormField(
                              keyboardType: TextInputType.number,
                              controller: viewModel.amount,
                              hintText: 'e.g., 500,000',
                              suffixIcon: Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Text("NGN", style: wayaTheme.textTheme.hintStyle),
                              ),
                              borderColor: formState.hasError && viewModel.amount.text.isEmpty
                                  ? wayaTheme.colorScheme.error
                                  : null,
                            ),
                            if (formState.hasError && viewModel.amount.text.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  formState.errorText!,
                                  style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                                ),
                              ),
                          ],
                        );
                      }),
                    ],
                  )),
              SizedBox(height: 40.h),
              WayaButton(
                callback: () async {
                  await ref.read(donationVmProvider.notifier).editCampaign(context, viewModel.amount.text, widget.id);
                  WayaNav.goBack();
                  WayaNav.toNamed("/donations");
                  ref.read(donationVmProvider.notifier).reset();
                },
                text: "Set Minimum Amount",
                isLoading: viewModel.isLoading,
              ),
              SizedBox(height: 17.h),
              WayaButton(
                border: Border.all(color: WayaColors.greyColor300),
                color: Colors.white,
                callback: () async {
                  WayaNav.toNamed("/donations");
                },
                text: "Cancel",
                textColor: WayaColors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
