import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/features/wallet/view/components/wallet_cards.dart';

class LearnMoreInstructionsContent extends StatelessWidget {
  const LearnMoreInstructionsContent({
    super.key,
  });

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
              'How to fund your account?',
              style: wayaTheme.textTheme.headlineLarge,
            ),
            SizedBox(height: 20.h),
            InstructionContainer(
              position: '1',
              title: 'Select the Virtual Account to Fund',
              description: 'Choose the account you want to fund to view its Account Number and Bank Name.',
            ),
            SizedBox(height: 17.h),
            InstructionContainer(
              position: '2',
              title: 'Copy Account Details',
              description: 'Tap Copy Account Number and note the Bank Name.',
            ),
            SizedBox(height: 17.h),
            InstructionContainer(
              position: '3',
              title: 'Open Your Bank App',
              description: 'Log in to your bank\'s app or website and go to Transfer or Send Money.',
            ),
            SizedBox(height: 17.h),
            InstructionContainer(
              position: '4',
              title: 'Enter Transfer Details',
              description: 'Paste the Account Number, select the Bank Name, and enter the amount.',
            ),
            SizedBox(height: 17.h),
            InstructionContainer(
              position: '5',
              title: 'Confirm Transfer',
              description: 'Review and confirm the details to complete the transfer.',
            ),
            SizedBox(height: 17.h),
            InstructionContainer(
              position: '6',
              title: 'Check Balance',
              description: 'Go back to Virtual Accounts to confirm the funds have arrived',
            ),
          ],
        ),
      ),
    );
  }
}

// class TransactionFilterContent extends StatefulWidget {
//   const TransactionFilterContent({
//     super.key,
//   });

//   @override
//   State<TransactionFilterContent> createState() => _TransactionFilterContentState();
// }

// class _TransactionFilterContentState extends State<TransactionFilterContent> {
//   var startDate = TextEditingController();
//   var endDate = TextEditingController();

//   int? _currentIndex;
//   final FocusNode _focusNode = FocusNode(); // Create a FocusNode

//   @override
//   void dispose() {
//     _focusNode.dispose(); // Dispose of the FocusNode when the widget is removed

//     super.dispose();
//   }

//   void _focusTextField() {
//     FocusScope.of(context).requestFocus(_focusNode); // Request focus on the field
//   }

//   @override
//   Widget build(BuildContext context) {
//     List filter = ['Last Month', 'Last 6 Months', 'Custom Range'];
//     List<HistoryDate> dateFilter = [
//       HistoryDate.thisWeek,
//       HistoryDate.thisMonth,
//     ];

//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 15.0,
//       ).copyWith(top: 40, bottom: 20),
//       child: Consumer<WalletProvider>(builder: (context, walletProvider, _) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Export Transaction',
//               style: AppTextStyle.headline4.copyWith(color: AppColors.black),
//             ),
//             Gap(20),
//             Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: List.generate(
//                   3,
//                   (index) => Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 10.0),
//                       child: InkWell(
//                         onTap: index == 2
//                             ? () {
//                                 _currentIndex = index;
//                                 setState(() {});
//                                 _focusTextField();
//                               }
//                             : () {
//                                 walletProvider.calculateTotalCreditAndDebit(
//                                     walletProvider.transactionLocalList, dateFilter[index]);
//                                 _currentIndex = index;
//                                 setState(() {});
//                               },
//                         child: buildChip(
//                           textColor: AppColors.grayColor2,
//                           padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
//                           borderColor: index == _currentIndex ? Colors.red : AppColors.grey,
//                           text: filter[index],
//                           color: index == _currentIndex ? Colors.red.withOpacity(0.2) : AppColors.background,
//                         ),
//                       ),
//                     ),
//                   ),
//                 )),
//             Gap(20),
//             DatePickerForm(
//               focusNode: _focusNode,
//               controller: startDate,
//               title: 'Start Date',
//               hintText: 'October 20th 2024',
//             ),
//             Gap(15),
//             DatePickerForm(
//               controller: endDate,
//               isToday: true,
//               title: 'End Date',
//               hintText: 'October 25th 2024',
//             ),
//             Gap(15),
//             AppButton(
//               title: 'Export Transaction',
//               onPressed: () {
//                 walletProvider.calculateCustomTotalCreditAndDebit(walletProvider.transactionLocalList,
//                     startDate: DateFormatterUtil.convertToDateTime(startDate.text),
//                     endDate: DateFormatterUtil.convertToDateTime(endDate.text));
//                 WayaNav.goBack();
//               },
//             )
//           ],
//         );
//       }),
//     );
//   }
// }
