
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/pages/component/extras.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/post/vm/comment.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

import '../../chat/state/default.dart';

class ViewFullMedia extends ConsumerStatefulWidget {
  static const route = '/viewFullMedia';
  const ViewFullMedia({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewFullMediaState();
}

class _ViewFullMediaState extends ConsumerState<ViewFullMedia>
    with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final dynamic id  = ModalRoute.of(context)?.settings.arguments;
      ref.read(createGroupProvider.notifier).getGroupSinglePosts(id);
    });
  }


  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider.notifier);
    final viewModel2 = ref.watch(createGroupProvider);

    final dynamic args  = ModalRoute.of(context)?.settings.arguments;

    return WayaScaffold(
      padding: EdgeInsets.zero,
      appBar: AppBar(backgroundColor: Colors.black,
      leading: InkWell(
        onTap: ()=> WayaNav.goBack(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset('assets/icons/back_arrow.svg',),
          )),),
        isLoading: viewModel2.isLoading,
        backgroundColor: Colors.black,
        isScrollable: true,
        title: '',
        appBarTrailing: Row(
          spacing: 12,
          children: [

            PopupMenuButton(
                onSelected: (value) {},
                iconColor: wayaTheme.colorScheme.white,
                position: PopupMenuPosition.under,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: _buildActionNav(
                          context: context,
                          onTap: () {
                            WayaNav.goBack();


                          },
                          asset:
                          SvgPicture.asset('assets/icons/download.svg', height: 20,),
                          text: "  Download Media",
                          color: wayaTheme.colorScheme.customBlack),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: _buildActionNav(
                          context: context,
                          onTap: () {
                            Share.share('${args['url']}', subject: 'Share Options');
                          },
                          asset:WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
                          text: "  Share Post link",
                          color:wayaTheme.colorScheme.customBlack),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: _buildActionNav(
                          context: context,
                          onTap: () async{
                            WayaNav.goBack();
                            /*await WayaUtils.showModalSheet(context,
                                child: ReportGroup(
                                    statuses: groupReport,
                                    currentStatus: "",
                                    groupId: '${args['groupId']}'));*/

                          },
                          asset: SvgPicture.asset('assets/images/pages/flag.svg'),
                          text: "  Report Post",
                          color: wayaTheme.colorScheme.customBlack),
                    ),

                  ];
                },
                child: WayaAssets.icons.genSet.moreHorz.svg(fit: BoxFit.none, color: Colors.white)),
            Gap(8)
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              //padding: EdgeInsets.only(left: 15, right: 15,),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel2.groupPostdocs?.length,
                itemBuilder: (_, index,) {
                  final post = viewModel2.groupPostdocs?[index];

                  String formatTimeAgo(String dateString) {
                    DateTime dateTime =
                    DateTime.parse(dateString); // Convert string to DateTime
                    return timeago.format(dateTime); // Convert to "time ago" format
                  }

                  String removeHashtags(String text) {
                    return text.replaceAll(RegExp(r'#\w+'), '').trim();
                  }

                  return viewModel2.groupPostdocs!.isEmpty ? PostEmptyState(): Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      // Post header with author details
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 25.h, 15.w, 15.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {

                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      WayaDp(
                                        image: post?.user?.profilePicture,
                                        radius: 20,
                                      ),
                                      SizedBox(width: 10.w),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${post?.user?.firstName} ${post?.user?.lastName}',
                                                style: TextStyle(
                                                  fontFamily:
                                                  WayaConstants.fontFamily,
                                                  color: Colors.white,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Gap(5),
                                              Text(
                                                '• ${formatTimeAgo('${post?.createdAt}')}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .wayaCopyWith(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .greyColor500),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                //viewFull!();
                              },
                              child: ReadMoreText(
                                removeHashtags('${post?.content?.capitalizeFirst}'),
                                style: TextStyle(
                                  fontFamily: WayaConstants.fontFamily,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                ),
                                trimLines: 2,
                                annotations: [
                                  Annotation(
                                    regExp: RegExp(
                                        r'((https?:\/\/)?([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(\/[^\s]*)?)'),
                                    spanBuilder: (
                                        {required String text,
                                          TextStyle? textStyle}) =>
                                        TextSpan(
                                          text: text,
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                              decorationColor: Colors.blue),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final String fullUrl =
                                              text.startsWith('http')
                                                  ? text
                                                  : 'https://$text';
                                              _launchUrl(fullUrl);
                                            },
                                        ),
                                  ),
                                ],
                                colorClickableText: Colors.blue,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: "read more",
                                trimExpandedText: "show less",
                                moreStyle: const TextStyle(color: Colors.blue),
                                lessStyle:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: WayaColors.primary,
                                  fontFamily: WayaConstants.fontFamily,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            // PostContent(content: post.content),
                            SizedBox(
                              height: 5.h,
                            ),
                            if (post?.hashtags != null)
                              ...?post?.hashtags!.map((e) => Row(
                                children: [
                                  Text(
                                    '$e',
                                    style: TextStyle(
                                      color: WayaColors.primary,
                                      fontFamily: WayaConstants.fontFamily,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              )),

                          ],
                        ),
                      ),
                      post?.media == null || post!.media!.contains("cat.jpg")? Container():
                      // if (post.media != null)
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal, // Enables horizontal scrolling
                          itemCount: post.media?.length,
                          itemBuilder: (context, index) {
                            return Image.network(
                              post.media![index],
                              fit: BoxFit.cover,
                              width: 350, // Adjust width for better display
                              height: 200, // Matches the container height
                            );
                          },
                        ),
                      ),

                      // Post actions: Like, Comment, Repost, Share
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.w, 8.0.h, 15.w, 8.w),
                        child: Row(
                          children: [
                            actionType(
                                '${post?.likeCount} ${post?.likeCount == 1 || post?.likeCount == 0 ? 'Like' : 'Likes'}',
                                'assets/images/pages/like2.png', onPressed: () {
                              viewModel.likePost(context, postId: '${post?.id}',
                                  userId: '${ConversationState.self.id}');
                            },
                                color: post?.likeCount == 0
                                    ? WayaColors.greyColor500
                                    : WayaColors.primary),
                            actionType('${post?.commentCount} Comments',
                                'assets/images/pages/comment2.png', onPressed: () {
                                  showCommentBox(context, post?.id);
                                  print(post?.id);
                                }),
                            actionType('${post?.shareCount} Shares',
                                'assets/images/pages/share2.png', onPressed: () {
                                  viewModel.sharePost(context, postId: '${post?.id}');
                                  Share.share('${post?.url}', subject: 'Share Options');
                                }),
                            InkWell(
                                onTap: () {
                                  viewModel.bookmarkPost(context,
                                      postId: '${post?.id}');
                                },
                                child: Image.asset(
                                  'assets/images/pages/save.png',
                                  height: 32.h,
                                )),
                          ],
                        ),
                      ),

                    ],
                  );
                }),
          ],
        ),

    );
  }
  void showCommentBox(BuildContext context, postId) {
    @override
    final _formKey = GlobalKey<FormState>();
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);
    final viewModel2 = ref.read(createPageProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    });

    print('ShowCommentBox ${ref.read(createPageProvider.notifier).getCommentsStream(postId)}');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the keyboard push up the bottom sheet
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: 450.h,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('All Comments',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
                Gap(20),

                Expanded(
                    child:
                    WayaFutureSubscriber(
                        future:  ref.read(createCommentProvider.notifier).getCommentsStream(postId),
                        suspense:(_) => Center(child: CircularProgressIndicator(),),
                        error: (_, error, __)=>Center(child: CircularProgressIndicator(),),
                        builder: (_, data){
                          return  ListView.builder(
                            shrinkWrap: true,
                            itemCount: data?.length ?? 0,
                            itemBuilder: (context, index) {
                              String formatTimeAgo(String dateString) {
                                DateTime dateTime = DateTime.parse(dateString); // Convert string to DateTime
                                return timeago
                                    .format(dateTime); // Convert to "time ago" format
                              }
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.h, horizontal: 15.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        circleImage(
                                          radius: 10.r,
                                          data?[index].user
                                              ?.profilePicture ??
                                              '',
                                        ),
                                        Gap(10),
                                        Text(
                                          '${data?[index].user?.firstName} ${data?[index].user?.lastName}',
                                          style: TextStyle(
                                            fontFamily: WayaConstants.fontFamily,
                                            fontSize: 12.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Gap(10),
                                        Text(
                                          '• ${formatTimeAgo('${data?[index].createdAt}')}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .wayaCopyWith(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .greyColor500),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${data?[index].content?.capitalizeFirst}',
                                      style: TextStyle(
                                        //fontFamily: WayaConstants.fontFamily,
                                        fontSize: 12.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        })

                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: WayaDp(
                        radius: 20,
                      ),
                    ),
                    Gap(10),
                    Expanded(
                      flex: 2,
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FormField<String>(validator: (value) {
                                return null;
                              }, builder: (formState) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    WayaTextFormField(
                                      showBorder: true,
                                      keyboardType: TextInputType.text,
                                      controller: viewModel.content,
                                      hintText: 'Write comment here',
                                      borderColor: formState.hasError &&
                                          viewModel.content.text.isEmpty
                                          ? wayaTheme.colorScheme.error
                                          : null,
                                    ),
                                    if (formState.hasError &&
                                        viewModel.content.text.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          formState.errorText!,
                                          style: TextStyle(
                                              color:
                                              wayaTheme.colorScheme.error,
                                              fontSize: 12.sp),
                                        ),
                                      ),
                                  ],
                                );
                              }),
                              Gap(20),
                            ],
                          )),
                    ),
                    Gap(10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        width: 50,
                        child: WayaButton(
                          centerWidget: Image.asset(
                            'assets/images/pages/send_ic.png',
                            height: 25.h,
                          ),
                          callback: !viewModel.isLoading
                              ? () async {
                            if (_formKey.currentState!.validate()) {
                              await ref
                                  .watch(createPageProvider.notifier)
                                  .commentOnPost(
                                postId,
                                viewModel.content.text,
                              );
                              ref
                                  .watch(createPageProvider.notifier)
                                  .reset();
                              //WayaNav.goBack();
                            }
                          }
                              : null,
                          height: 50,
                          isLoading: viewModel.isLoading,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchUrl(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  actionType(txt, img, {onPressed, color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
            height: 32.h,
            width: 32.w,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: WayaColors.greyColor100),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                img,
                height: 15.h,
                color: color,
              ),
            ),
          ),
        ),
        /*InkWell(
            onTap: onPressed,
            child: Image.asset(img, height: 32.h, color: color,)),*/
        Gap(5),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(txt,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              )),
        ),
        const Gap(15),
      ],
    );
  }

  InkWell _buildActionNav(
      {required BuildContext context,
        required VoidCallback onTap,
        required Widget asset,
        required String text,
        required Color color}) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          asset,
          const Gap(4),
          Text(
            text,
            style: TextStyle().wayaCopyWith(
                color: color, fontWeight: FontWeight.w500, fontSize: 12.sp),
          )
        ],
      ),
    );
  }
}

class PostEmptyState extends StatelessWidget {
  const PostEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: EmptyState(
            hasButton: false,
            onTap: () {},
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter:
              ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "No media yet"),
      ),
    );
  }
}