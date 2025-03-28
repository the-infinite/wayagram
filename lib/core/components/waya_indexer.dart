import 'package:flutter/material.dart';

abstract class WayaIndexedInterface {
  int get index;
}

class WayaIndexedWidget extends StatelessWidget implements WayaIndexedInterface {
  @override
  final int index;
  final Widget child;
  const WayaIndexedWidget({
    super.key,
    this.index = 0,
    required this.child,
  });

  factory WayaIndexedWidget.fromWidget(Widget child, [int index = 1]) {
    return WayaIndexedWidget(
      index: index,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) => child;
}

class WayaIndexerWidget extends Stack {
  final bool reversed;

  WayaIndexerWidget({
    super.key,
    super.alignment,
    super.textDirection,
    this.reversed = false,
    super.fit,
    super.clipBehavior,
    List<Widget> children = const <Widget>[],
  }) : super(
          children: children
            ..sort((Widget a, Widget b) {
              int reverser = reversed ? -1 : 1;
              int aIndex = 1;
              int bIndex = 1;
              if (a is WayaIndexedInterface) {
                aIndex = (a as WayaIndexedInterface).index;
              }
              if (b is WayaIndexedInterface) {
                bIndex = (b as WayaIndexedInterface).index;
              }
              return aIndex - bIndex * reverser;
            }),
        );

  /// use shadow list to sort items
  WayaIndexerWidget.shadow({
    super.key,
    super.alignment,
    super.textDirection,
    this.reversed = false,
    super.fit,
    super.clipBehavior,
    List<Widget> children = const <Widget>[],
    List<int> shadow = const <int>[],
  })  : assert(shadow.length == children.length),
        super(
          children: children
            ..sort(
              (Widget a, Widget b) {
                int reverser = reversed ? -1 : 1;
                return shadow[children.indexOf(a)] - shadow[children.indexOf(b)] * reverser;
              },
            ),
        );
}
