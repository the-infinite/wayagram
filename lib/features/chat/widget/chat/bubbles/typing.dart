import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/theme.dart';

class PersonalTypingIndicator extends StatefulWidget {
  const PersonalTypingIndicator({
    super.key,
  });

  @override
  State<PersonalTypingIndicator> createState() => _PersonalTypingIndicatorState();
}

class _PersonalTypingIndicatorState extends State<PersonalTypingIndicator> with TickerProviderStateMixin {
  AnimationController? _firstController;
  AnimationController? _secondController;
  AnimationController? _thirdController;

  static const _delay = Duration(milliseconds: 150);

  @override
  void initState() {
    // This is fine.
    try {
      _firstController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );

      _secondController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );

      _thirdController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );
    } catch (_) {}
    super.initState();
  }

  @override
  void dispose() {
    _firstController!.dispose();
    _secondController!.dispose();
    _thirdController!.dispose();
    super.dispose();
  }

  //? This is how we go forward.
  Future<void> _forward() async {
    _firstController!.repeat(reverse: true);
    await Future.delayed(_delay);
    _secondController!.repeat(reverse: true);
    await Future.delayed(_delay);
    _thirdController!.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    final controllers = [
      _firstController!,
      _secondController!,
      _thirdController!,
    ];

    //? After this screen is rendered.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await _forward();
      },
    );

    //? Return this.
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: WayaColors.greyColor200,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3,
              (index) => Padding(
                padding: EdgeInsets.only(right: index < 2 ? 4 : 0),
                child: FadeTransition(
                  opacity: Tween(
                    begin: 1.0,
                    end: 0.0,
                  ).animate(
                    CurvedAnimation(
                      curve: Curves.decelerate,
                      parent: controllers[index],
                    ),
                  ),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: WayaColors.greyColor500,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
