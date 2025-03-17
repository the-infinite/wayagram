import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/moments/data/model/moment_viewer_response_model.dart';
import 'package:wayagram/features/moments/vm/moment_vm.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';
import 'package:timeago/timeago.dart' as timeago;

class MomentViewers extends ConsumerStatefulWidget {
  final String momentId;
  const MomentViewers({super.key, required this.momentId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MomentViewersState();
}

class _MomentViewersState extends ConsumerState<MomentViewers> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(momentVmProvider.notifier).getMomentId(widget.momentId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(momentVmProvider);

    if (state.momentId.isEmpty) {
      return CircularProgressIndicator();
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Moment Viewers",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: PaginatedDataView<MomentViewer>(
            uniqueKey: 'moment-viewer',
            loadingState: SizedBox(
                height: context.height * 0.2,
                child: Center(
                  child: CircularProgressIndicator(),
                )),
            emptyState: SizedBox(
              height: context.height * 0.2,
              child: Center(
                child: Text(
                  "No Viewer",
                  style: TextStyle(
                      color: wayaTheme.colorScheme.greyColor300, fontSize: 14.sp),
                ),
              ),
            ),
            fetchData: ref.read(momentVmProvider.notifier).momentViewers,
            result: (data, scroll) {
              return ListView.builder(
                  // controller: scroll,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return builViewers(context: context, viewer: data[index]);
                  });
            },
          ))
        ],
      ),
    );
  }

  Widget builViewers(
      {required BuildContext context, required MomentViewer viewer}) {
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      WayaDp(
                        image: viewer.image,
                        radius: 25,
                      ),
                      if (viewer.likeMoment)
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: SvgPicture.asset(
                              WayaAssets.icons.mSmallHeart.path,
                              width: 16,
                              height: 16,
                            ))
                    ],
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 150.w,
                        child: Text(viewer.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: wayaTheme.textTheme.bodyMedium),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      SizedBox(
                        width: 150.w,
                        child: Text(
                          viewer.username ?? '',
                          style: wayaTheme.textTheme.hintStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                ],
              ),
              Text(
                timeago.format(viewer.viewedAt),
                style: wayaTheme.textTheme.hintStyle,
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
