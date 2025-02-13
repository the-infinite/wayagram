import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/data/repo/event_repository.dart';
import 'package:wayagram/shared/engagement/model/default.dart';
import 'package:wayagram/shared/engagement/provider/default.dart';

class States {
  final List<EventDoc> events;
  final String userId;

  States({this.events = const [], this.userId = ''});

  States copyWith({List<EventDoc>? events, String? userId}) {
    return States(events: events ?? this.events, userId: userId ?? this.userId);
  }
}

class ServicesProvider extends StateNotifier<States> {
  final Ref ref;
  final EventRepository _eventRepository;
  final EngagementNotifier _engagementNotifier;
  final WayaSecureDataSource _secureDataSource;
  ServicesProvider(this._secureDataSource, this._engagementNotifier,
      this._eventRepository, this.ref)
      : super(States());

  Future<void> getEvents() async {
    try {
      final userId = await _secureDataSource.getUserId();
      state = state.copyWith(userId: userId);
      final response = await _eventRepository.getEvents();

      if (response.success) {
        EventResponse eventResponse = EventResponse.fromJson(response.data);
        List<EventDoc> allEvents = eventResponse.data.docs;

        if (allEvents.isEmpty) return;

        // Get rankings for event type and location
        Map<String, int> locationRanks = _engagementNotifier
                .state[ServiceType.events]
                ?.getAllEventLocation() ??
            {};
        Map<String, int> typeRanks =
            _engagementNotifier.state[ServiceType.events]?.getAllEventTypee() ??
                {};

        // If no rankings exist, return the first 3 events
        if (locationRanks.isEmpty && typeRanks.isEmpty) {
          state = state.copyWith(events: allEvents.take(3).toList());
          return;
        }

        // Sort events separately by location rank
        List<EventDoc> sortedByLocation = List.from(allEvents)
          ..sort((a, b) => (locationRanks[b.location] ?? 0)
              .compareTo(locationRanks[a.location] ?? 0));

        // Sort events separately by type rank
        List<EventDoc> sortedByType = List.from(allEvents)
          ..sort((a, b) => (typeRanks[b.eventType] ?? 0)
              .compareTo(typeRanks[a.eventType] ?? 0));

        // Select top 5 from each category
        List<EventDoc> topLocationEvents = sortedByLocation.take(5).toList();
        List<EventDoc> topTypeEvents = sortedByType.take(5).toList();

        // Merge both lists while ensuring uniqueness
        Map<String, EventDoc> uniqueEvents = {
          for (var event in [...topLocationEvents, ...topTypeEvents])
            event.id: event
        };

        // Convert back to list
        List<EventDoc> filteredEvents = uniqueEvents.values.toList();

        state = state.copyWith(events: filteredEvents);
      }
    } catch (error) {
      print(error);
    }
  }
}

final servicesprovider = StateNotifierProvider<ServicesProvider, States>((ref) {
  return ServicesProvider(
      WayaSecureDataSource(), EngagementNotifier(), EventRepository(), ref);
});
