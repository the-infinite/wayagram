import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/general_settings/privacy_settings/widget/blocked_card.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

class BlockedUserPage extends StatefulHookConsumerWidget {
  static const route = '/blocked-user-page';
  const BlockedUserPage({super.key});

  @override
  _ForYouContestState createState() => _ForYouContestState();
}

class _ForYouContestState extends ConsumerState<BlockedUserPage> {
  final ScrollController _scrollController = ScrollController();
  double _previousScrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_scrollListener);
    });
  }

  void _scrollListener() {
    double currentOffset = _scrollController.position.pixels;

    // ✅ Fetch data only when scrolling **downward** and near the bottom
    if (currentOffset > _previousScrollOffset &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100) {
      // print("fetching .....${_scrollController.position.pixels}");
      ref.read(conversationProvider.notifier).getBlockedUsers();
    }
    _previousScrollOffset = currentOffset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener); // Remove listener safely
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    // final viewModel = ref.watch(roleAccessVm);

    final viewModelReal = ref.watch(conversationProvider);
    final viewModelNotifier = ref.read(conversationProvider.notifier);
    final isLoading = useState(false);
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModelNotifier.getBlockedUsers();
      });
      return null;
    }, []);

    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Blocked Users",
      onRefresh: () {
        return viewModelNotifier.getBlockedUsers();
      },
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Blocked Users"),
        leading: WayaBackButton(
            //onTap: onTapBackButton,
            ),
      ),
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (viewModelReal.isLoading == true)
              Center(child: CircularProgressIndicator()),
            if (viewModelReal.blocked.isEmpty) emptyWidget(),
            Expanded(
              // height: context.height - 200,
              child: ListView.builder(
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: viewModelReal.blocked.length,
                itemBuilder: (context, index) {
                 
                 

                  return BlockedCard( viewModelReal.blocked[index]);
                 
                },
              ),
            ),
            Gap(100)
          ],
        ),
      ),
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc: "No User added yet",
        title: "Blocked Users",
        buttonText: "",
        hideButton: false,
        onTap: () {});
  }
}
