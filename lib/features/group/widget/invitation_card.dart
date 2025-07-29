import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/string_extension.dart';
import 'package:wayagram/features/group/data/model/group_invitation_model.dart';

class InvitationCard extends StatelessWidget {
  const InvitationCard(
      {super.key,
      required this.group,
      required this.wayaTheme,
      required this.ref,
      required this.accept,
      required this.reject});

  final GroupInvitationModelDocs group;
  final ThemeData wayaTheme;
  final WidgetRef ref;
  final VoidCallback accept;
  final VoidCallback reject;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.only(
        left: 10,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: WayaColors.greyColor100,
                backgroundImage: group.group?.profileImage == null
                    ? AssetImage("assets/placeholder.jpg")
                    : NetworkImage(
                        '${group.group?.profileImage}',
                      ),
              ),
              Gap(10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${group.group?.name?.capitalizeFirst}',
                      style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.black,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Gap(5),
                    Text(
                      '${group.group?.description?.capitalizeFirst}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .wayaCopyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.greyColor500,
                              overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: reject,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: wayaTheme.colorScheme.error)),
                        child: Icon(
                          Icons.close,
                          color: wayaTheme.colorScheme.error,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: accept,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: wayaTheme.colorScheme.success)),
                        child: Icon(
                          Icons.check,
                          color: wayaTheme.colorScheme.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
