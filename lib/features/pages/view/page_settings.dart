import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

class PageSetting extends StatefulHookConsumerWidget {
  static const route = '/pageSetting';
  const PageSetting({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PageSettingState();
}

class _PageSettingState extends ConsumerState<PageSetting>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);
    final viewModel2 = ref.watch(wayaSelectFieldViewModelProvider(Uuid().v4()));
    final pageNotifier = ref.read(createPageProvider.notifier);

    final followPermission = useState("Everyone");
    final commentPermission = useState("Everyone");
    final lastSeen = useState(false);

    /// Everyone, invited followers, restricted followers
    ///For comments we have: Admins only, Everyone, followers
    useEffect(() {
      bool isPublic = args["isPublic"] ?? false;
      bool isCommentPermission = args["commentPermission"] ?? false;

      followPermission.value = isPublic ? "Everyone" : "Friends";
      commentPermission.value = isCommentPermission ? "Everyone" : "Friends";

      return null;
    }, []);

    return WayaScaffold(
      backgroundColor: Theme.of(context).colorScheme.greyColor50,
      isLoading: viewModel.isLoading,
      isScrollable: false,
      title: 'Page Settings',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(20),
          Text(
            "Page Permission Settings",
            style: wayaTheme.textTheme.hintStyle,
          ),
          Gap(20),

          /// everyoneCanComment  --->
          /// isOpen              --->
          /// adminsCanCreate     --->

          /*   GestureDetector(
            onTap: () {
              viewModel2.selectValue(context, "Who Can Contact Me", [
                Select(label: "Everyone", value: "1"),
                Select(label: "Friends", value: "2"),
              ], (value) {
                //? set the state
                followPermission.value = value.first.label;
                //? updating the state
                pageNotifier.updatePageSetting(
                    context,
                    followPermission.value == "Everyone",
                    commentPermission.value == "Everyone",
                    args["pageId"]);
              }, false);
            },
            child: PrivacyWidget(
                title: "Is Open permission",
                value: "Allow anyone to follow without restrictions for a more inclusive community",
                showSwitch: false,
                whoCanContactMe: followPermission,
                switchValue: lastSeen),
          ),
          //Gap(10),

          Gap(20),
          GestureDetector(
            onTap: () {
              viewModel2.selectValue(context, "Who Can Contact Me", [
                Select(label: "Everyone", value: "1"),
                Select(label: "Friends", value: "2"),
              ], (value) {
                //? set the state
                commentPermission.value = value.first.label;
                //? updating the state
                pageNotifier.updatePageSetting(
                    context,
                    followPermission.value == "Everyone",
                    commentPermission.value == "Everyone",
                    args["pageId"]);
              }, false);
            },
            child: PrivacyWidget(
                title: "Comment Permissions",
                value:
                    "Choose who you want to comment on page posts to have more control over your page",
                showSwitch: false,
                whoCanContactMe: commentPermission,
                switchValue: lastSeen),
          ),*/

          /// New UI

          accessType(
              "Everyone can comment",
              "Allow anyone to follow without restrictions for a more inclusive community",
              viewModel.comment, (value) {
            ref
                .read(createPageProvider.notifier)
                .updateOpenCommentToEveryone(value);
            ref.read(createPageProvider.notifier).updatePageSetting(
                context,
                viewModel.openToEveryone,
                value,
                viewModel.adminCanCreate,
                args['pageId']);
          }),
          Gap(10),
          accessType(
              "Is Open permission",
              "Allow anyone to follow without restrictions for a more inclusive community",
              viewModel.openToEveryone, (value) {
            ref.read(createPageProvider.notifier).updateOpenToEveryone(value);
            ref.read(createPageProvider.notifier).updatePageSetting(
                context,
                value,
                viewModel.comment,
                viewModel.adminCanCreate,
                args['pageId']);
          }),
          Gap(10),
          accessType(
              "Admins can create",
              "Allow invited admins to manage/create post",
              viewModel.adminCanCreate, (value) {
            ref.read(createPageProvider.notifier).updateAdminCanCreate(value);
            ref.read(createPageProvider.notifier).updatePageSetting(
                context,
                viewModel.openToEveryone,
                viewModel.comment,
                value,
                args['pageId']);
          }),
        ],
      ),
    );
  }

  Widget accessType(
      String title, String? subTitle, bool chk, Function(bool)? onPressed) {
    final wayaTheme = Theme.of(context);
    return Container(
      height: 88.h,
      padding:
          EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: wayaTheme.textTheme.titleSmall),
        subtitle: Text(
          subTitle ?? '',
          style: TextStyle().wayaCopyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.greyColor500),
        ),
        trailing: Switch(value: chk, onChanged: onPressed),
      ),
    );
  }
}
