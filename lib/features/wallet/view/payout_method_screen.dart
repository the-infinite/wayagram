import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:wayagram/features/polls_and_voting/data/model/fetch_all_polls.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

import '../../polls_and_voting/views/my_polls.dart';

class PayoutMethodScreen extends ConsumerStatefulWidget {
  const PayoutMethodScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PayoutMethodScreenState();
}

class _PayoutMethodScreenState extends ConsumerState<PayoutMethodScreen> {

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     ref.read(createPollVotingProvider.notifier).getAllPolls(page: 1);
  //   });
  //
  //   super.initState();
  // }
  //
  //
  // @override
  // void reassemble() {
  //   super.reassemble();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //     ref.read(createPollVotingProvider.notifier).getAllPolls(page: 1);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPollVotingProvider);
    return Expanded(
      child: PaginatedDataView<Docs>(
          uniqueKey: 'payout-method',
          loadingState: SizedBox(
              height: context.height * 0.4,
              child: Center(
                child: CircularProgressIndicator(),
              )),
          emptyState: PollEmptyState(),
          fetchData: ref.read(createPollVotingProvider.notifier).getAllPolls,
          result: (data, s) {
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.fetchAllPols.length,
                itemBuilder: (context, index) {
                  final poll = viewModel.fetchAllPols[index];
                  int hoursLeft =
                      DateTime.parse('${poll.endDate}').difference(DateTime.parse('${poll.startDate}')).inHours;
                  int daysLeft =
                      DateTime.parse('${poll.endDate}').difference(DateTime.parse('${poll.startDate}')).inDays;

                  DateTime expirationDate = DateTime.parse("${poll.endDate}");
                  DateTime currentDate = DateTime.now(); // Get current date and time

                  return Container();
                });
          }),
    );
  }

}
