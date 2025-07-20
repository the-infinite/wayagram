import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';

class SendRequestCardWidget extends StatefulWidget {
  final String memberCount;
  final String groupName;
  final String groupDesc;
  final String image;
  final String id;
  final Future<void> Function(BuildContext ctx, String id) onTap;
  const SendRequestCardWidget({
    super.key,
    required this.memberCount,
    required this.groupName,
    required this.groupDesc,
    required this.image,
    required this.id,
    required this.onTap,
  });

  @override
  State<SendRequestCardWidget> createState() => _SendRequestCardWidgetState();
}

class _SendRequestCardWidgetState extends State<SendRequestCardWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.greyColor200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(left: 0, right: 0),
            leading: CircleAvatar(
                radius: 40,
                backgroundColor: WayaColors.greyColor100,
                backgroundImage: NetworkImage(widget.image)),
            title: Row(
              children: [
                Text('${widget.groupName.capitalizeFirst}',
                    style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.black)),
                Spacer(),
                SizedBox(
                  width: context.width * 0.30,
                  child: WayaButton(
                    callback: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await widget.onTap(context, widget.id);
                      setState(() {
                        isLoading = false;
                      });
                    },
                    //     ()async{
                    //   await group.joinGroup(context, '${recommendedGroup?.id}');
                    // },
                    text: 'Send Join Request',
                    isLoading: isLoading,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .wayaCopyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.white),
                    height: 32.h,
                  ),
                )
              ],
            ),
            subtitle: Text(
              '${widget.memberCount} Members',
              style: Theme.of(context).textTheme.bodySmall!.wayaCopyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.greyColor500),
            ),
          ),
          Text(
            '${widget.groupDesc.capitalizeFirst}',
            style: Theme.of(context).textTheme.bodySmall!.wayaCopyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.greyColor500),
          ),
        ],
      ),
    );
  }
}
