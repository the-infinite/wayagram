import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/shared/features/profile/repo/default.dart';
import 'package:wayagram/shared/features/profile/state/event.dart';

class EventNotifier extends StateNotifier<EventState> {
  final repo = UserProfileRepository.instance;
  EventNotifier(super.state);

  /// An API used to fetch all the posts for a given user.
  Future<List<EventDoc>> getEventsForUser(String id) async {
    final result = <EventDoc>[];

    try {
      // This is fine too.
      final response = await repo.getEventsForUser(id, state.nextPage ?? state.page, state.limit);

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];

        //? Parse the posts as they are in the response object...
        final docs = (data['docs'] as List).map((doc) => EventDoc.fromJson(doc));

        //? Now, add these to what we have here.
        result.addAll(docs);

        //? If the previous page had a next page, offload them onto this place.
        if (state.hasNextPage) {
          result.addAll(state.docs);
        }

        //? This is fine.
        state = state.copyWith(
          docs: result,
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
        WayaDebugEventModule.events,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    // That's fine.
    return result;
  }

  /// Helper function used to reset the state of our entire post notifier.
  void reset() {
    state = EventState.initial;
  }
}

final userEventsProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
  return EventNotifier(EventState.initial);
});
