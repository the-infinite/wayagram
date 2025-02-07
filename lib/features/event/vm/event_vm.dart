import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/data/model/event_state.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/data/repo/event_repository.dart';
import 'package:wayagram/features/event/views/event_detail/event_detail.dart';
import 'package:wayagram/features/event/views/event_view.dart';
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

  Future<void> joinEvent(
      {required String eventId,
      required BuildContext context,
      required EventDoc event}) async {
    try {
      state = state.copyWith(isJoiningEvent: true);
      final userId = await _secureDataSource.getUserId();
      final response =
          await _eventRepository.joinEvent(userId: userId!, eventId: eventId);
      if (response.success && context.mounted) {
        Navigator.of(context).pop();
        await WayaUtils.showNotice(
            context: context,
            buttonText: 'View Event Details',
            secondButtonText: 'Explore more event',
            icon: Image.asset(
              WayaAssets.images.createEventSuccess.path,
              scale: 1.5,
            ),
            title: "You've successfully joined the event",
            message:
                'Your spot is confirmed. Stay tuned for update and get ready for an amazing experience',
            onPress: () => Navigator.of(context).pop(),
            onCancel: () => WayaNav.toNamed(EventView.route));
        print(response.data);
      }
    } catch (error) {
      print(error);
    } finally {
      state = state.copyWith(isJoiningEvent: false);
    }
  }

  Future<void> reportEvent(
      {required String eventId,
      required String reason,
      String? comment,
      required BuildContext context}) async {
    try {
      state = state.copyWith(isReportingEvent: true);
      final userId = await _secureDataSource.getUserId();
      final response = await _eventRepository.reportEvent(
          userId: userId!, eventId: eventId, reason: reason);
      if (response.success && context.mounted) {
        // show success modal
        Navigator.of(context);
        await WayaUtils.showNotice(
            context: context,
            title: "Thank you for reporting",
            onPress: () {
              WayaNav.offNamed(EventView.route);
            },
            icon: Image.asset(
              WayaAssets.images.eCheckEvent.path,
              scale: 1.5,
            ),
            message:
                'Your report has been submitted. Our team will review the issue and take appropriate action.',
            buttonText: 'Go to Event Page');
        print(response.data);
      }
    } catch (error) {
      print(error);
    } finally {
      state = state.copyWith(isReportingEvent: false);
    }
  }
}

final eventVmProvider = StateNotifierProvider<EventVm, EventState>((ref) {
  return EventVm(WayaSecureDataSource(), EventRepository(), ref);
});
