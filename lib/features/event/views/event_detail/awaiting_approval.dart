import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/event/data/model/event_attendee_response_model.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/features/explore/search/widgets/user_widget.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

class AwaitingApproval extends ConsumerStatefulWidget {
  final String eventId;
  const AwaitingApproval({super.key, required this.eventId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AwaitingApprovalState();
}

class _AwaitingApprovalState extends ConsumerState<AwaitingApproval> {
  late final notifier = ref.read(eventVmProvider.notifier);
  bool isApproving = false;
  bool isRejecting = false;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(eventVmProvider);
    final wayaTheme = Theme.of(context);
    return Expanded(
        child: PaginatedDataView<Doc>(
      uniqueKey: 'awaiting-approval',
      loadingState: SizedBox(
        height: context.height * 0.2,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      emptyState: SizedBox(
        height: context.height * 0.2,
        child: Center(
          child: Text("No awaiting attendee for this event"),
        ),
      ),
      fetchData:
          ref.read(eventVmProvider.notifier).getAttendeesAwaitingApproval,
      result: (data, scroll) {
        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(4)),
                child: Column(
                  spacing: 3,
                  children: [
                    FollowUserWidget(
                      userId: data[index].userId,
                    ),
                    if (viewModel.isUserEvent)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: context.width * 0.45,
                            child: WayaButton(
                              callback: isApproving
                                  ? null
                                  : () async {
                                      setState(() {
                                        isRejecting = true;
                                      });
                                      await notifier.updateApproval(
                                          userId: data[index].userId,
                                          eventId: data[index].eventId,
                                          status: "reject");
                                      setState(() {
                                        isRejecting = false;
                                      });
                                    },
                              color: wayaTheme.colorScheme.transparent,
                              border: Border.all(
                                  width: 1,
                                  color: wayaTheme.colorScheme.customPrimary),
                              centerWidget: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Reject",
                                    style: wayaTheme.textTheme.bodyMedium
                                        ?.wayaCopyWith(
                                      fontWeight: FontWeight.w600,
                                      color:
                                          wayaTheme.colorScheme.customPrimary,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: context.width * 0.45,
                            child: WayaButton(
                              callback: isRejecting
                                  ? null
                                  : () async {
                                      setState(() {
                                        isApproving = true;
                                      });
                                      await notifier.updateApproval(
                                          userId: data[index].userId,
                                          eventId: data[index].eventId,
                                          status: "approve");
                                      setState(() {
                                        isApproving = false;
                                      });
                                    },
                              text: 'Approve',
                            ),
                          )
                        ],
                      )
                  ],
                ),
              );
            });
      },
    ));
  }
}
