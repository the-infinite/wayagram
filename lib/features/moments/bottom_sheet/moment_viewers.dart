import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

class MomentViewers extends ConsumerStatefulWidget {
  final String momentId;
  const MomentViewers({super.key, required this.momentId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MomentViewersState();
}

class _MomentViewersState extends ConsumerState<MomentViewers> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Moment Viewers",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text("No Viewer"),
          )
        ],
      ),
    );
  }
}
