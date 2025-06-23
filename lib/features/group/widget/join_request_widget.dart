
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/features/group/data/model/join_request_model.dart';

class JoinRequestWidget extends StatelessWidget {
  final VoidCallback accept;
  final VoidCallback reject;
  final JoinRequestDocs joinRequest;
  const JoinRequestWidget({super.key,
    required this.reject,
    required this.accept,
    required this.joinRequest});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Container(
      height: 60.h,
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.only(
        left: 10,
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(10),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: WayaColors.greyColor100,
                backgroundImage: joinRequest.user?.profilePicture == null
                    ? AssetImage(
                  '',
                )
                    : NetworkImage(
                  '${joinRequest.user?.profilePicture}',
                ),
              ),
              Gap(10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${joinRequest.user?.firstName} ${joinRequest.user?.lastName}',
                    style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.black),
                  ),
                  Gap(5),
                  Text(
                    '${joinRequest.user?.email}',
                    style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.greyColor500),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    InkWell(
                      onTap: accept,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: wayaTheme.colorScheme.success)
                        ),
                        child: Icon(Icons.check, color: wayaTheme.colorScheme.success,
                        ),
                      ),
                    ),
                    Gap(10),
                    InkWell(
                      onTap: reject,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: wayaTheme.colorScheme.error)
                        ),
                        child: Icon(Icons.close, color: wayaTheme.colorScheme.error,
                        ),
                      ),
                    ),

                    /* SizedBox(
                                    width: 68.w,
                                    child: WayaButton(
                                      callback: () async => await request.approveRequest(context, '${group.id}'),
                                      text: 'Approve',
                                      textStyle: TextStyle().wayaCopyWith(
                                        color: wayaTheme.colorScheme.success,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                      ),
                                      isLoading: viewModel.isLoading,
                                      height: 32.h,
                                      color: wayaTheme.colorScheme.success50,
                                      textColor: wayaTheme.colorScheme.success,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 68.w,
                                    child: WayaButton(
                                      callback: () async => await request.rejectRequest(context, '${group.id}'),
                                      text: 'Decline',
                                      textStyle: TextStyle().wayaCopyWith(
                                        color: wayaTheme.colorScheme.success,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                      ),
                                      isLoading: viewModel.isLoading,
                                      height: 32.h,
                                      color: WayaColors.error50,
                                      textColor: wayaTheme.colorScheme.error,
                                    ),
                                  ),*/
                  ],
                ),
              ),
            ],
          ),
          // Gap(6),
        ],
      ),
    );
  }
}
