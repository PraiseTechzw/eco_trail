import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/services/events_service.dart';
import '../../../../models/eco_location_model.dart';

// Events stream provider
final eventsProvider = StreamProvider<List<Event>>((ref) {
  return EventsService.getEventsStream();
});

// Upcoming events provider
final upcomingEventsProvider = FutureProvider<List<Event>>((ref) {
  return EventsService.getUpcomingEvents();
});

// Selected event provider
final selectedEventProvider = StateProvider<Event?>((ref) => null);

// Search query provider
final eventsSearchQueryProvider = StateProvider<String>((ref) => '');

// Filter category provider
final eventsFilterCategoryProvider = StateProvider<String?>((ref) => null);

// Selected date provider
final selectedDateProvider = StateProvider<DateTime?>((ref) => null);

// Filtered events provider
final filteredEventsProvider = FutureProvider<List<Event>>((ref) async {
  final searchQuery = ref.watch(eventsSearchQueryProvider);
  final filterCategory = ref.watch(eventsFilterCategoryProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  if (searchQuery.isNotEmpty) {
    return EventsService.searchEvents(searchQuery);
  } else if (filterCategory != null) {
    return EventsService.getEventsByCategory(filterCategory);
  } else if (selectedDate != null) {
    final startOfDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final endOfDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      23,
      59,
      59,
    );
    return EventsService.getEventsByDateRange(startOfDay, endOfDay);
  } else {
    return EventsService.getUpcomingEvents();
  }
});

// User bookings provider
final userBookingsProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((ref, userId) {
      return EventsService.getUserBookings(userId);
    });

// Event categories provider
final eventCategoriesProvider = Provider<List<String>>((ref) {
  return AppConstants.eventCategories;
});

// Helper function to get event status
String getEventStatus(Event event) {
  final now = DateTime.now();
  if (now.isBefore(event.startDate)) {
    return 'Upcoming';
  } else if (now.isAfter(event.startDate) && now.isBefore(event.endDate)) {
    return 'Ongoing';
  } else {
    return 'Ended';
  }
}

// Helper function to check if event is bookable
bool isEventBookable(Event event) {
  final now = DateTime.now();
  return now.isBefore(event.startDate) &&
      event.currentParticipants < event.maxParticipants;
}

// Helper function to get event availability status
String getEventAvailabilityStatus(Event event) {
  if (event.maxParticipants == 0) {
    return 'Unlimited';
  }

  final remaining = event.maxParticipants - event.currentParticipants;
  if (remaining <= 0) {
    return 'Fully Booked';
  } else if (remaining <= 5) {
    return 'Only $remaining spots left';
  } else {
    return '$remaining spots available';
  }
}
