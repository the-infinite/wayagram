

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/features/explore/widgets/event_card.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';


class Events extends ConsumerStatefulWidget {
  const Events({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventsState();
}

class _EventsState extends ConsumerState<Events> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createGroupProvider.notifier).getEvent();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createGroupProvider);


    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
      color:wayaTheme.colorScheme.greyColor50 ,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: viewModel.fetchAllEventDocs?.length,
              itemBuilder: (_, index){
                final event =  viewModel.fetchAllEventDocs?[index];
                return EventCard(event: event!, userId: ConversationState.self.id,);
              }),
        ],
      ),
    );

  }

}