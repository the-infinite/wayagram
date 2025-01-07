import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParticipantDetails extends ConsumerStatefulWidget {
  const ParticipantDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ParticipantDetailsState();
}

class _ParticipantDetailsState extends ConsumerState<ParticipantDetails> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [],
    );
  }
}
