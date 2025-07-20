import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/referral/vm/referral_vm.dart';

class CustomDateWidget extends ConsumerStatefulWidget {
  const CustomDateWidget({super.key});

  @override
  ConsumerState createState() => _CustomDateWidgetState();
}

class _CustomDateWidgetState extends ConsumerState<CustomDateWidget> {
  String selectedTimeFrame = 'Last Month';
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    // Initialize with Last Month selected
    _updateDatesForLastMonth();
  }

  void _updateDatesForLastMonth() {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1, now.day);
    setState(() {
      startDate = lastMonth;
      endDate = now;
    });
  }

//   void _updateDatesForLast6Months() {
//     final now = DateTime.now();
//     final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
//     setState(() {
//       startDate = sixMonthsAgo;
//       endDate = now;
//     });
//   }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate ?? DateTime.now() : endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(referralVm.notifier);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Custom Range',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          /*   Text(
            'Time Frame',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildTimeFrameButton('Last Month'),
              const SizedBox(width: 10),
              _buildTimeFrameButton('Last 6 Months'),
              const SizedBox(width: 10),
              _buildTimeFrameButton('Custom Range'),
            ],
          ), */
          const SizedBox(height: 20),
          Text(
            'Start Date',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          _buildDateField(context, true),
          const SizedBox(height: 20),
          Text(
            'End Date',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          _buildDateField(context, false),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                // Handle export logic here
                if (startDate == null || endDate == null) {
                  WayaSnackBar.showToast("Please select both dates");
                  return;
                }

                String startDateNew = DateFormat('yyyy-MM-dd').format(startDate!);
                String endDateNew = DateFormat('yyyy-MM-dd').format(endDate!);

                notifier.updateStartAndEndDate(startDateNew, endDateNew);
                notifier.getAllUserReferrals(true);
                WayaNav.goBack();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Filter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//   Widget _buildTimeFrameButton(String text) {
//     final isSelected = selectedTimeFrame == text;
//     return Expanded(
//       child: OutlinedButton(
//         onPressed: () {
//           setState(() {
//             selectedTimeFrame = text;
//             if (text == 'Last Month') {
//               _updateDatesForLastMonth();
//             } else if (text == 'Last 6 Months') {
//               _updateDatesForLast6Months();
//             }
//           });
//         },
//         style: OutlinedButton.styleFrom(
//           backgroundColor: isSelected ? Colors.red.shade50 : Colors.white,
//           side: BorderSide(
//             color: isSelected ? Colors.red : Colors.grey.shade300,
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: isSelected ? Colors.red : Colors.black,
//           ),
//         ),
//       ),
//     );
//   }

  Widget _buildDateField(BuildContext context, bool isStartDate) {
    final date = isStartDate ? startDate : endDate;
    return InkWell(
      onTap: () => _selectDate(context, isStartDate),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date != null ? DateFormat('MMMM dd\'th\' yyyy').format(date) : 'Select date',
              style: TextStyle(
                color: date != null ? Colors.black : Colors.grey,
              ),
            ),
            const Icon(Icons.calendar_today, size: 20),
          ],
        ),
      ),
    );
  }
}
