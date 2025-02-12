import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/moments/data/model/moment_response_model.dart';
import 'package:wayagram/features/moments/data/repo/moment_repository.dart';

class ReplyMomentWidget extends ConsumerStatefulWidget {
  final String uniqueKey;
  final MomentData moment;
  final Function() pause;
  final Function() continues;

  const ReplyMomentWidget(
      {super.key,
      required this.uniqueKey,
      required this.moment,
      required this.continues,
      required this.pause});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReplyMomentWidgetState();
}

class _ReplyMomentWidgetState extends ConsumerState<ReplyMomentWidget> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(replyMomentVmProvider(widget.uniqueKey).notifier)
          .initialize(widget.moment);
      ref
          .read(replyMomentVmProvider(widget.uniqueKey).notifier)
          .postSingleUserMoment(moment: widget.moment);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final state = ref.watch(replyMomentVmProvider(widget.uniqueKey));
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 45,
            width: 315.w,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.transparent,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(width: 1, color: wayaTheme.colorScheme.white)),
            child: TextField(
              style: TextStyle(
                fontSize: 12,
                color: wayaTheme.colorScheme.white,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Reply Moment',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: wayaTheme.colorScheme.white,
                ),
              ),
              onChanged: (value) {
                widget.pause();
                ref
                    .read(replyMomentVmProvider(widget.uniqueKey).notifier)
                    .updateComment(value);
              },
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          if (state.comment.isNotEmpty) ...[
            SizedBox(
              width: 40,
              height: 40,
              child: WayaButton(
                height: 40,
                radius: 40,
                callback: () {
                  ref
                      .read(replyMomentVmProvider(widget.uniqueKey).notifier)
                      .isCommented(true);
                  widget.continues();
                },
                centerWidget: Center(
                  child: SvgPicture.asset(WayaAssets.icons.aMoment.path),
                ),
              ),
            ),
          ] else ...[
            GestureDetector(
              onTap: () {
                ref
                    .read(replyMomentVmProvider(widget.uniqueKey).notifier)
                    .toggleLiked();
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: state.isLiked
                        ? wayaTheme.colorScheme.customPrimary
                        : wayaTheme.colorScheme.transparent,
                    border: Border.all(
                        width: 1, color: wayaTheme.colorScheme.white)),
                child: Center(
                  child: SvgPicture.asset(WayaAssets.icons.mNotliked.path),
                ),
              ),
            )
          ]
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

  ReplyMomentState(
      {this.isComment = false,
      this.isLiked = false,
      this.isLoading = false,
      this.moment,
      this.comment = ''});

  ReplyMomentState copyWith(
      {bool? isLiked,
      bool? isComment,
      MomentData? moment,
      bool? isLoading,
      String? comment}) {
    return ReplyMomentState(
        isComment: isComment ?? this.isComment,
        isLiked: isLiked ?? this.isLiked,
        comment: comment ?? this.comment,
        moment: moment ?? this.moment,
        isLoading: isLoading ?? this.isLoading);
  }
}

final replyMomentVmProvider =
    StateNotifierProvider.family<ReplyMomentVm, ReplyMomentState, String>(
        (ref, uniqueKey) {
  return ReplyMomentVm(MomentRepository(), WayaSecureDataSource(), ref);
});

class ReplyMomentVm extends StateNotifier<ReplyMomentState> {
  final Ref ref;
  final WayaSecureDataSource _secureDataSource;
  final MomentRepository _momentRepository;

  ReplyMomentVm(this._momentRepository, this._secureDataSource, this.ref)
      : super(ReplyMomentState());

  void initialize(MomentData moment) {
    state = state.copyWith(moment: moment);
  }

  void updateComment(String comment) {
    state = state.copyWith(comment: comment);
  }

  void isCommented(bool isComment) async {
    state = state.copyWith(isComment: isComment);
    await postSingleUserMoment(moment: state.moment!);
  }

  void toggleLiked() async {
    state = state.copyWith(isLiked: !state.isLiked);
    await postSingleUserMoment(moment: state.moment!);
  }

  Future<void> postSingleUserMoment({required MomentData moment}) async {
    try {
      final profileId = await _secureDataSource.getUserId();
      if (profileId == moment.userId) return;
      final response = await _momentRepository.viewMoments(
          profileId: profileId!,
          momentId: moment.id,
          likeMoment: state.isLiked,
          comment: state.isComment);

      if (response.success) {
        print(response.data);
      }
    } catch (error) {
      print(error);
    }
  }
}
