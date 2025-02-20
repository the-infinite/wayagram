
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyDonations extends ConsumerStatefulWidget {
  const MyDonations({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyDonationsState();
}

class _MyDonationsState extends ConsumerState<MyDonations> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index){
              return Column();
            }
        )
      ],
    );
  }
}
