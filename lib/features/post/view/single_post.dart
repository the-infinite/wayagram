import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/features/explore/vm/explore_vm.dart';
import 'package:wayagram/shared/cache/post.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';

class SinglePost extends ConsumerStatefulWidget {
  static const route = "/single-post";
  final String postId;
  const SinglePost({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SinglePostState();
}

class _SinglePostState extends ConsumerState<SinglePost> {
  late final notifier = ref.read(exploreVmProvider.notifier);
  PostModel? post;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final singlePost = await notifier.getSinglePosts(postId: widget.postId);

      setState(() {
        if (singlePost != null) {
          setState(() {
            post = PostModel.fromJson(singlePost);
               wayaPostCache.cacheAll([PostModel.fromJson(singlePost)]);
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);

    if (post == null) {
      return Container(
        color: wayaTheme.colorScheme.white,
        width: context.width,
        height: context.height,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
 //   print(post?.categories ?? '');
    return WayaScaffold(
        body: Column(
          children: [
             WayaPostWidget(
      data: post!,
      index: 0,
      padded: false,
      sourceType: post?.sourceType ?? '',
    )
    
          ],
        )
    );
  }
}
