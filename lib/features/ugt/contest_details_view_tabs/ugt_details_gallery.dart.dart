import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

class UgtDetailsGallery extends ConsumerStatefulWidget {
  final Contest model;
  const UgtDetailsGallery(this.model, {super.key});

  @override
  _UgtDetailsGalleryState createState() => _UgtDetailsGalleryState();
}

class _UgtDetailsGalleryState extends ConsumerState<UgtDetailsGallery> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final posts = ref.watch(postProvider);

    final wayaTheme = Theme.of(context);
    // final postNotifier = ref.read(postProvider.notifier);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //  if (posts.isEmpty) emptyWidget(),
        /*   if (posts.isNotEmpty)
          ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              if (postNotifier.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              final post = posts[index];
              return GestureDetector(
                onTap: () {
                  ref.read(selectedContestProvider.notifier).state = post;
                  WayaNav.toNamed('/upcoming-manage-contest-details');
                },
                child: ContestCard(
                  post,
                  postNotifier.toggleLike,
                  postNotifier.toggleShare,
                  postNotifier.doFollow,
                ),
              );
            },
          ), */
      ],
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc:
            "You don’t have any active contest here. Create a \n contest and have different participant",
        title: "No Contest Created",
        buttonText: "Host a Contest",
        onTap: () {
          //  ivalidateUGTVM(ref);
          //  WayaNav.toNamed("/create-contest");
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
