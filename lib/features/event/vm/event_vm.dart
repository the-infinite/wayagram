import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/features/event/data/model/event_state.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/data/repo/event_repository.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';

class EventVm extends StateNotifier<EventState> {
  final Ref ref;
  final WayaSecureDataSource _secureDataSource;
  final EventRepository _eventRepository;

  EventVm(this._secureDataSource, this._eventRepository, this.ref)
      : super(EventState());

  Future<void> getEvents() async {
    try {
      final response = await _eventRepository.getEvents();

      if (response.success) {
        print(response.data);
      }
    } catch (error) {
      print(error);
    }
  }

  // Future<void> fetchEventsWithStatus() async {
  //   try {
  //     state = state.copyWith(isLoadingEventWithStatus: true);
  //     final results = await Future.wait([
  //       getEventWithStatus(status: "upcoming"),
  //       getEventWithStatus(status: "past"),
  //     ]);
  //     print(results);
  //   } catch (error) {
  //     print("Error fetching events: $error");
  //   } finally {
  //     state = state.copyWith(isLoadingEventWithStatus: false);
  //   }
  // }

  Future<PaginatedResult<EventDoc>?> getEventWithStatus() async {
    try {
      state = state.copyWith(isLoadingEventWithStatus: true);
      final response =
          await _eventRepository.getEventWithStatus(status: "upcoming");

      List<EventDoc> upcoming = [];
      bool hasNextPage = false;
      if (response.success) {
        EventResponse eventResponse = EventResponse.fromJson(response.data);
        upcoming = eventResponse.data.docs;
        hasNextPage = eventResponse.data.hasNextPage;
        state = state.copyWith(upcomingEvents: upcoming);
      }

      return PaginatedResult(hasNextPage: hasNextPage, items: upcoming);
    } catch (error) {
      print(error);
      return null;
    } finally {
      state = state.copyWith(isLoadingEventWithStatus: false);
    }
  }

  void getSingleEvent(EventDoc event) async {
    state = state.copyWith(singleEvent: event);
    final userId = await _secureDataSource.getUserId();
    state = state.copyWith(isUserEvent: event.userId == userId);
    //
  }

  Future<PaginatedResult<EventDoc>?> getUserEvents(int page) async {
    try {
      state = state.copyWith(isLoadingUserEvents: true);

      final userId = await _secureDataSource.getUserId();
      final response =
          await _eventRepository.getUserEvents(userId: userId!, page: page);
      List<EventDoc> myEvents = [];
      bool hasNextPage = false;
      if (response.success) {
        EventResponse eventResponse = EventResponse.fromJson(response.data);
        myEvents = eventResponse.data.docs;
        hasNextPage = eventResponse.data.hasNextPage;
        state = state.copyWith(myEvents: myEvents);
      }

      return PaginatedResult(hasNextPage: hasNextPage, items: myEvents);
    } catch (error) {
      print(error);
      return null;
    } finally {
      state = state.copyWith(isLoadingUserEvents: false);
    }
  }
}

final eventVmProvider = StateNotifierProvider<EventVm, EventState>((ref) {
  return EventVm(WayaSecureDataSource(), EventRepository(), ref);
});
