import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/dto/chat.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/moments/data/model/moment_response_model.dart';
import 'package:wayagram/features/moments/data/repo/moment_repository.dart';
import 'package:wayagram/features/moments/vm/moment_vm.dart';

class ReplyMomentWidget extends ConsumerStatefulWidget {
  final String uniqueKey;
  final MomentData moment;
  final Function() pause;
  final Function() continues;
  final TextEditingController textController;

  // Construct.
  const ReplyMomentWidget({
    super.key,
    required this.uniqueKey,
    required this.moment,
    required this.continues,
    required this.pause,
    required this.textController,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReplyMomentWidgetState();
}

class _ReplyMomentWidgetState extends ConsumerState<ReplyMomentWidget> {
  late final notifier = ref.read(replyMomentVmProvider(widget.uniqueKey).notifier);
  late final conversationNotifier = ref.read(conversationProvider.notifier);

  Map<String, bool> likedMoments = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(replyMomentVmProvider(widget.uniqueKey));
    final size = MediaQuery.sizeOf(context);
    bool isLiked = likedMoments[widget.moment.id] ?? false;
    //? Now move forward.
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 45,
              child: TextField(
                controller: widget.textController,
                onTap: () {
                  widget.pause();
                },
                onTapOutside: (event) {
                  widget.continues();
                },
                style: TextStyle(
                  fontSize: 12,
                  color: wayaTheme.colorScheme.white,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2000),
                    borderSide: BorderSide(
                      width: 1,
                      color: wayaTheme.colorScheme.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2000),
                    borderSide: BorderSide(
                      width: 1,
                      color: wayaTheme.colorScheme.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2000),
                    borderSide: BorderSide(
                      width: 1,
                      color: wayaTheme.colorScheme.white,
                    ),
                  ),
                  hintText: 'Reply Moment',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: wayaTheme.colorScheme.white,
                  ),
                ),
                onChanged: (value) {
                  widget.pause();
                  notifier.updateComment(value.trim());
                },
              ),
            ),
          ),

          // Some space.
          SizedBox(
            width: 5.w,
          ),

          //? If this has any comments...
          if (state.comment.isNotEmpty)
            SizedBox(
              width: 40,
              height: 40,
              child: WayaButton(
                height: 40,
                radius: 40,
                callback: () async {
                  final chat = await conversationNotifier.startChat(ChatType.personal, [widget.moment.userId]);

                  //? Since this is fine...
                  if (chat != null) {
                    //? If we could make this chat our focus.
                    late final chatNotifier = ref.read(chatProvider(chat.id).notifier);
                    chatNotifier.setChat(chat);

                    //? This is fine too.
                    final message = await chatNotifier.sendMessage(
                      SendMessageDto(
                        chatId: chat.id,
                        type: MessageType.text,
                        originalMessage: null,
                        originalMessageId: null,
                        content: state.comment,
                        contacts: null,
                        media: null,
                        momentId: widget.moment.id,
                      ),
                    );

                    //? Now, let us check if there are messages configured.
                    if (message != null) {
                      widget.textController.clear();
                      WayaSnackBar.showToast("Your reply has been sent successfully");
                    }
                  }
                  widget.continues();
                },
                centerWidget: Center(
                  child: SvgPicture.asset(WayaAssets.icons.aMoment.path),
                ),
              ),
            )

          //? Since there are no comments, let's try liking it shall we?
          else
            GestureDetector(
              onTap: () {
                setState(() {
                  likedMoments[widget.moment.id] = !(likedMoments[widget.moment.id] ?? false);
                });
                notifier.toggleLiked(likedMoments[widget.moment.id]!, widget.moment.id, widget.moment.userId);
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLiked ? wayaTheme.colorScheme.customPrimary : wayaTheme.colorScheme.transparent,
                  border: Border.all(
                    width: 1,
                    color: wayaTheme.colorScheme.white,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(WayaAssets.icons.mNotliked.path),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ReplyMomentState {
  final bool isLiked;
  final bool isComment;
  final bool isLoading;
  final String comment;
  final MomentData? moment;

  ReplyMomentState({
    this.isComment = false,
    this.isLiked = false,
    this.isLoading = false,
    this.moment,
    this.comment = '',
  });

  ReplyMomentState copyWith({bool? isLiked, bool? isComment, MomentData? moment, bool? isLoading, String? comment}) {
    return ReplyMomentState(
      isComment: isComment ?? this.isComment,
      isLiked: isLiked ?? this.isLiked,
      comment: comment ?? this.comment,
      moment: moment ?? this.moment,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final replyMomentVmProvider = StateNotifierProvider.family<ReplyMomentVm, ReplyMomentState, String>((ref, uniqueKey) {
  ref.watch(momentVmProvider);
  return ReplyMomentVm(MomentRepository(), WayaSecureDataSource(), ref);
});

class ReplyMomentVm extends StateNotifier<ReplyMomentState> {
  final Ref ref;
  final localStorageService = WayaLocalDataSource();
  final WayaSecureDataSource _secureDataSource;
  final MomentRepository _momentRepository;

  ReplyMomentVm(this._momentRepository, this._secureDataSource, this.ref) : super(ReplyMomentState());

  void initialize() {
    state = state.copyWith(isLiked: false);
  }

  void updateComment(String comment) {
    state = state.copyWith(comment: comment);
  }

  void isCommented(bool isComment, String id, String userId) async {
    state = state.copyWith(isComment: isComment);
    await postSingleUserMoment(momentId: id, userId: userId);
  }

  void toggleLiked(bool liked, String id, String userId) async {
    state = state.copyWith(isLiked: liked);
    await postSingleUserMoment(momentId: id, userId: userId);
  }

  Future<void> postSingleUserMoment({required String momentId, required String userId}) async {
    try {
      final profileId = await _secureDataSource.getUserId();
      if (profileId == userId) return;
      final response = await _momentRepository.viewMoments(
        profileId: profileId!,
        momentId: momentId,
        likeMoment: state.isLiked,
        comment: state.isComment,
      );

      if (!response.success) return;
      localStorageService.viewMoment(momentId);
      state = state.copyWith();
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.moments,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }
}
