import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/moments/vm/moment_vm.dart';

class PostMomentWidget extends ConsumerWidget {
  const PostMomentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(momentVmProvider);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.white.withOpacity(0.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              SvgPicture.asset(WayaAssets.icons.mPublic.path),
              SizedBox(
                width: 4.w,
              ),
              Text(
                "Public Moment",
                style: TextStyle(
                    color: wayaTheme.colorScheme.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          SizedBox(
            width: 36,
            height: 36,
            child:  WayaButton(
              height: 36,
              radius: 36,
              callback: !state.isCreatingMoment ?() {
                ref
                    .read(momentVmProvider.notifier)
                    .submitMoment(context: context);
              } : null,
              centerWidget: Center(
                child: SvgPicture.asset(WayaAssets.icons.aMoment.path),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
