import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/search/search.dart';
import 'package:wayagram/features/explore/widgets/tabbed_feed.dart';
import 'package:wayagram/features/explore/bottom_sheet/create_sheet.dart';

class ChatAndSocial extends ConsumerStatefulWidget {
  static const route = "/chat-and-social";
  const ChatAndSocial({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatAndSocialState();
}

class _ChatAndSocialState extends ConsumerState<ChatAndSocial> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      scrollController: scrollController,
      title: "Chat & Socials",
      backgroundColor: wayaTheme.colorScheme.scaffoldColor,
      appBarTrailing: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => WayaNav.toNamed(SearchView.route),
              child: SvgPicture.asset(WayaAssets.icons.searchIconFeed.path),
            ),
            const Gap(6),
            WayaDp(
              onTap: () => WayaNav.toNamed('/general-settings'),
              radius: 18,
            ),
          ],
        ),
      ),
      body: TabbedFeedWidget(),
      floatingActionButton: IntrinsicHeight(
        child: SizedBox(
          width: 50,
          child: ListenableBuilder(
            listenable: scrollController,
            builder: (context, _) => Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10.h,
              children: [
                //? First, the scroll up button.
                if (scrollController.offset >= 200)
                  GestureDetector(
                    onTap: () {
                      //? Animate to the position in question.
                      scrollController.animateTo(0, duration: const Duration(milliseconds: 650), curve: Curves.easeIn);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: wayaTheme.colorScheme.customPrimary,
                        ),
                        shape: BoxShape.circle,
                        color: wayaTheme.colorScheme.primary50,
                      ),
                      child: Icon(
                        Icons.arrow_upward,
                        color: wayaTheme.colorScheme.customPrimary,
                        size: 20,
                      ),
                    ),
                  ),

                //? This is fine.
                WayaButton(
                  callback: () => WayaUtils.showModalSheet(context, child: CreateSheet()),
                  height: 50,
                  centerWidget: Center(
                    child: Icon(
                      Icons.add,
                      color: wayaTheme.colorScheme.white,
                      size: 40,
                    ),
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
