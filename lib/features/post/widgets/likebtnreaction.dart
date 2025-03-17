
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';

class LikeButtonWithReactions extends StatefulWidget {
  final bool isLiked;
  final Function(String reaction) onLike;
  final Function(String reaction) onReact; // Pass the selected reaction

  const LikeButtonWithReactions({
    Key? key,
    required this.isLiked,
    required this.onLike,
    required this.onReact,
  }) : super(key: key);

  @override
  _LikeButtonWithReactionsState createState() =>
      _LikeButtonWithReactionsState();
}

class _LikeButtonWithReactionsState extends State<LikeButtonWithReactions> {
  OverlayEntry? _overlayEntry;

  void _showReactionsOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy - 50, // Position above the like button
        left: offset.dx - (size.width / 2),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildReactionIcon("❤️", "Love"),
                _buildReactionIcon("😂", "Haha"),
                _buildReactionIcon("😮", "Wow"),
                _buildReactionIcon("😢", "Sad"),
                _buildReactionIcon("😡", "Angry"),
              ],
            ),
          ),
        ),
      ),
    );

    overlay?.insert(_overlayEntry!);
  }

  void _hideReactionsOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildReactionIcon(String emoji, String reaction) {
    return GestureDetector(
      onTap: () {
        widget.onReact(reaction);
        _hideReactionsOverlay();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          emoji,
          style:  TextStyle(fontSize: 24.sp),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onLike("Like");
      },
      onLongPress: () => _showReactionsOverlay(context),
      child: Row(
        children: [
          Image.asset('assets/images/pages/like.png',
            color: widget.isLiked ? Colors.red : Colors.grey,),
          const SizedBox(width: 6),
          Text(
            "Like",
            style: TextStyle(
              fontSize: 16.sp,
              color: widget.isLiked ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
