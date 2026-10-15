import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/explore/widgets/event_card.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';

class Events extends ConsumerStatefulWidget {
  const Events({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventsState();
}

class _EventsState extends ConsumerState<Events>
    with SingleTickerProviderStateMixin {
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
      color: wayaTheme.colorScheme.greyColor50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewModel.fetchAllEventDocs?.length,
            itemBuilder: (_, index) {
              final event = viewModel.fetchAllEventDocs?[index];
              return EventCard(
                event: event!,
                userId: ConversationState.self.id,
              );
            },
          ),
        ],
      ),
    );
  }
}
