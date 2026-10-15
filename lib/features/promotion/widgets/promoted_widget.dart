import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/promotion/views/promotion_detail.dart';

class PromotedWidget extends ConsumerStatefulWidget {
  final bool isDetail;
  // Construct.
  const PromotedWidget({super.key, this.isDetail = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PromotedWidgetState();
}

class _PromotedWidgetState extends ConsumerState<PromotedWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => WayaNav.toNamed(PromotionDetail.route),
        borderRadius: BorderRadius.circular(12.r),
        splashColor: theme.colorScheme.primary.withAlpha(30),
        focusColor: const Color.fromARGB(255, 179, 173, 170).withAlpha(30),
        highlightColor: theme.colorScheme.primary.withAlpha(30),
        child: Card(
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
            decoration: BoxDecoration(
              color: widget.isDetail
                  ? theme.colorScheme.white
                  : theme.colorScheme.scaffoldColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 0, right: 0),
                  leading: WayaImage(
                    imageUrl: "",
                    height: 40,
                    width: 40,
                    radius: BorderRadius.circular(50),
                  ),
                  horizontalTitleGap: 5.w,
                  title: Row(
                    children: [
                      //? The fullname of the user in question.
                      Text(
                        "Adam Johnson",
                        style: theme.textTheme.bodyMedium,
                      ),

                      // Infinite space.
                      Spacer(),

                      Container(
                        margin: EdgeInsets.only(right: 20.w),
                        padding: REdgeInsets.symmetric(
                            vertical: 5.dg, horizontal: 10.dg),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary50,
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        child: Text(
                          "7 days left",
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.customPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    '@dare-johnson123',
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.greyColor500,
                    ),
                  ),
                ),
                //? This is the user's bio.
                Text(
                  'Osumare',
                  style: theme.textTheme.displaySmall!.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.greyColor500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
