import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/bottom_sheet/report.dart';
import 'package:wayagram/features/event/data/model/add_event_state.dart';
import 'package:wayagram/features/moments/data/model/moment_response_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wayagram/features/moments/vm/moment_vm.dart';

class MomentUserInfoWidget extends ConsumerStatefulWidget {
  final MomentData moment;
  final dynamic isMine;
  final Function() pause;
  final Function() continues;
  const MomentUserInfoWidget({
    super.key,
    required this.moment,
    required this.continues,
    required this.isMine,
    required this.pause,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MomentUserInfoWidget();
}

class _MomentUserInfoWidget extends ConsumerState<MomentUserInfoWidget> {
  late final notifier = ref.read(momentVmProvider.notifier);
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return GestureDetector(
      onTap: () =>
          WayaNav.toNamed(WayaAppRoutes.getProfileRoute(widget.moment.userId)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 1, color: wayaTheme.colorScheme.white),
                  ),
                  child: WayaDp(
                    image: widget.moment.image,
                    radius: 20.r,
                    isSelf: false,
                    isEdit: false,
                    onTap: null,
                  ),
                ),
                SizedBox(
                  width: 6.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 160.w,
                      child: Text(
                        widget.isMine ? "You" : widget.moment.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: wayaTheme.colorScheme.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      timeago.format(widget.moment.updatedAt),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: wayaTheme.colorScheme.scaffoldColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ],
            ),
            if (!widget.isMine)
              GestureDetector(
                onTap: () async {
              

                  widget.pause();

                //  if (context.mounted) {
                  final response =   await WayaUtils.showModalSheet(
                      context,
                      child: Report(
                          statuses: eventReport,
                          currentStatus: '',
                          momentId: widget.moment.id
                          ),
                    );

                    if (response)


                 // }

                  widget.continues();
                },
                child: SvgPicture.asset(
                  WayaAssets.icons.mThreeDots.path,
                  color: wayaTheme.colorScheme.white,
                ),
              )
          ],
        ),
      ),
    );
  }
}
