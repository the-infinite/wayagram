import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/event/views/add_event/add_event.dart';
import 'package:wayagram/features/group/view/create_group.dart';
import 'package:wayagram/features/moments/views/my_moments.dart';
import 'package:wayagram/features/pages/view/create_page.dart';
import 'package:wayagram/features/polls_and_voting/views/create_poll.dart';
import 'package:wayagram/features/post/view/create_post.dart';

class _CreateActionButton extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final Function() callback;

  // Construct.
  const _CreateActionButton({
    required this.icon,
    required this.title,
    required this.description,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      borderRadius: BorderRadius.circular(10),
      splashColor: WayaColors.primary.withAlpha(30),
      focusColor: WayaColors.primary.withAlpha(30),
      highlightColor: WayaColors.primary.withAlpha(30),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            //* First, the icon for this create action button.
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: WayaColors.primary.withAlpha(30),
              ),
              child: SvgPicture.asset(
                icon,
              ),
            ),

            //> Likkle space
            const Gap(1),

            //* Second, the title of this section.
            Text(
              title,
              textAlign: TextAlign.center,
              style: WayaTextStyles.bodyBold,
            ),

            //* The body of this action button.
            Text(
              description,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: WayaTextStyles.descriptionStyle.copyWith(
                fontSize: 13.sp,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CreateSheet extends ConsumerWidget {
  const CreateSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          //? First, the title of the popup.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* The title.
              Text(
                "Create",
                style: WayaTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              //* The dismiss button.
              IconButton(
                onPressed: () => WayaNav.goBack(),
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.all(2),
                  backgroundColor: WayaColors.greyColor200,
                ),
                icon: WayaAssets.icons.actonDismiss.svg(
                  color: WayaColors.black,
                ),
              ),
            ],
          ),

          // Something like space.
          const Gap(10),

          //? Second, the grid of actions.
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: [
              //> First Row

              //> Post --
              _CreateActionButton(
                  icon: WayaAssets.icons.csPost.path,
                  title: "Post",
                  description: "Share a post or write what is in your mind",
                  callback: () {
                    WayaNav.toNamed(CreatePost.route);
                  }),

              //> Poll --
              _CreateActionButton(
                  icon: WayaAssets.icons.csPoll.path,
                  title: "Poll",
                  description: "Share and create a poll easily",
                  callback: () {
                    WayaNav.toNamed(CreatePoll.route);
                  }),

              //> Donation --
              _CreateActionButton(
                  icon: WayaAssets.icons.csDonation.path,
                  title: "Donation",
                  description: "Create a donation and receive helps",
                  callback: () {
                     WayaNav.toNamed( BottomView.route, arguments: 2);
                  }),

              //> Second Row

              //> Page --
              _CreateActionButton(
                  icon: WayaAssets.icons.csPage.path,
                  title: "Page",
                  description: "Create a page for your business or fan",
                  callback: () {
                    WayaNav.toNamed(CreatePage.route);
                  }),

              //> Group --
              _CreateActionButton(
                  icon: WayaAssets.icons.csGroup.path,
                  title: "Group",
                  description: "Create a private or public group of interest",
                  callback: () {
                    WayaNav.toNamed(CreateGroup.route);
                  }),

              //> Events --
              _CreateActionButton(
                  icon: WayaAssets.icons.csEvent.path,
                  title: "Events",
                  description:
                      "Bring people together with public or private event",
                  callback: () {
                    WayaNav.toNamed(AddEvent.route);
                  }),

              //> Third Row

              //> Auction --
              _CreateActionButton(
                  icon: WayaAssets.icons.csPage.path,
                  title: "Auctions",
                  description: "Auction items privately or publicly",
                  callback: () {}),

              //> Moment --
              _CreateActionButton(
                  icon: WayaAssets.icons.csGroup.path,
                  title: "Moment",
                  description: "Share a photo or write something",
                  callback: () {
                    WayaNav.toNamed(MyMoments.route);
                  }),

              //> Go Live --
              _CreateActionButton(
                  icon: WayaAssets.icons.csEvent.path,
                  title: "Go Live",
                  description: "Share a post or write what is on your mind",
                  callback: () {}),
            ],
          )
        ],
      ),
    );
  }
}
