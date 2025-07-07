import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/media.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/shared/features/chat/widget/empty_conversation.dart';

import 'section.dart';

class ChatMediaWidget extends StatefulWidget {
  final ChatModel chat;
  final WidgetRef ref;

  // Construct.
  const ChatMediaWidget({
    super.key,
    required this.chat,
    required this.ref,
  });

  @override
  State<ChatMediaWidget> createState() => _ChatMediaWidgetState();
}

class _ChatMediaWidgetState extends State<ChatMediaWidget> {
  final mediaTypeController = ValueNotifier(0);
  late final notifier = widget.ref.read(chatProvider(widget.chat.id).notifier);

  @override
  void initState() {
    super.initState();

    //? How.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        notifier.getChatMedia();
      },
    );
  }

  @override
  void dispose() {
    mediaTypeController.dispose();
    super.dispose();
  }

  //? How we do this thing.
  List<ChatMediaModel> getMedia(int groupValue) {
    final state = widget.ref.read(chatProvider(widget.chat.id));
    return switch (groupValue) {
      1 => state.videos,
      2 => state.images,
      _ => state.media,
    };
  }

  @override
  Widget build(BuildContext context) {
    //? Anyways.
    final state = widget.ref.read(chatProvider(widget.chat.id));

    //? This is fine.
    return ValueListenableBuilder(
      valueListenable: mediaTypeController,
      builder: (context, groupValue, _) {
        //? Get the media you are supposed to be seeing.
        final viewedMedia = getMedia(groupValue);

        //? Return this.
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            //? Now, for the media themselves.
            Row(
              spacing: 10.w,
              children: [
                //? For all types of media..
                Expanded(
                  child: SectionCountButton(
                    title: "All Media",
                    count: state.media.length,
                    value: 0,
                    controller: mediaTypeController,
                  ),
                ),

                //? For videos
                Expanded(
                  child: SectionCountButton(
                    title: "Videos",
                    count: 0,
                    value: 1,
                    controller: mediaTypeController,
                  ),
                ),

                //? For pictures
                Expanded(
                  child: SectionCountButton(
                    title: "Images",
                    count: 0,
                    value: 2,
                    controller: mediaTypeController,
                  ),
                ),
              ],
            ),

            // Some space.
            Gap(10.h),

            //? Now as it is empty.
            if (viewedMedia.isEmpty) ...[
              // Space.
              Gap(80.h),

              //? Now for the media themselves.
              EmptyConversationsWidget(
                title: "No ${groupValue == 0 ? "media" : groupValue == 1 ? "videos" : "images"} yet",
                text: "Send the first one today",
              ),

              // Some other space.
              Gap(60.h),
            ]

            //? Since there is something to show.
            else
              ...[],
          ],
        );
      },
    );
  }
}
