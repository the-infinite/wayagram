import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/shared/features/profile/model/pages.dart';
import 'package:wayagram/shared/features/profile/repo/default.dart';
import 'package:wayagram/shared/features/profile/state/pages.dart';

class PagesNotifier extends StateNotifier<PagesState> {
  final repo = UserProfileRepository.instance;
  PagesNotifier(super.state);

  Future<List<PageModel>> getPagesForUser(String id) async {
    final result = <PageModel>[];

    try {
      // This is fine too.
      final response = await repo.getPagesForUser(id, state.nextPage ?? state.page, state.limit);

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];

        //? Parse the posts as they are in the response object...
        final docs = (data['docs'] as List).map((doc) => PageModel.fromJson(doc));

        //? Now, add these to what we have here.
        result.addAll(docs);

        //? If the previous page had a next page, offload them onto this place.
        if (state.hasNextPage) {
          result.addAll(state.pages);
        }

        //? This is fine.
        state = state.copyWith(
          pages: result,
          totalSize: data['totalDocs'],
          totalPages: int.tryParse(data['totalPages'].toString()) ?? 1,
          hasNextPage: data['hasNextPage'],
          page: int.tryParse(data['page'].toString()) ?? 1,
          nextPage: int.tryParse(data['nextPage'].toString()) ?? 1,
          hasLoaded: true,
        );
      }

      //? After getting these posts...
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    // That's fine.
    return result;
  }

  void reset() {
    state = PagesState.initial;
  }
}

final userPagesProvider = StateNotifierProvider<PagesNotifier, PagesState>((ref) => PagesNotifier(PagesState.initial));
