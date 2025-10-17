import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/booking_model.dart';
import '../../data/services/booking_service.dart';
import '../../data/services/payment_service.dart';

// User bookings stream
final userBookingsProvider = StreamProvider<List<Booking>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return BookingService.getUserBookings(user.uid);
});

// Upcoming bookings stream
final upcomingBookingsProvider = StreamProvider<List<Booking>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return BookingService.getUpcomingBookings(user.uid);
});

// Past bookings stream
final pastBookingsProvider = StreamProvider<List<Booking>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return BookingService.getPastBookings(user.uid);
});

// Bookings by status
final bookingsByStatusProvider =
    StreamProvider.family<List<Booking>, BookingStatus>((ref, status) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return Stream.value([]);

      return BookingService.getBookingsByStatus(user.uid, status);
    });

// Booking statistics
final bookingStatsProvider = FutureProvider<Map<String, int>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Future.value({});

  return BookingService.getBookingStats(user.uid);
});

// Selected booking
final selectedBookingProvider = StateProvider<Booking?>((ref) => null);

// Booking form state
final bookingFormProvider =
    StateNotifierProvider<BookingFormNotifier, BookingFormState>((ref) {
      return BookingFormNotifier();
    });

class BookingFormState {
  final String eventId;
  final String eventTitle;
  final String eventType;
  final DateTime? eventDate;
  final String eventLocation;
  final int numberOfGuests;
  final double totalAmount;
  final String currency;
  final String? notes;
  final bool isLoading;
  final String? error;

  const BookingFormState({
    this.eventId = '',
    this.eventTitle = '',
    this.eventType = 'event',
    this.eventDate,
    this.eventLocation = '',
    this.numberOfGuests = 1,
    this.totalAmount = 0.0,
    this.currency = 'USD',
    this.notes,
    this.isLoading = false,
    this.error,
  });

  BookingFormState copyWith({
    String? eventId,
    String? eventTitle,
    String? eventType,
    DateTime? eventDate,
    String? eventLocation,
    int? numberOfGuests,
    double? totalAmount,
    String? currency,
    String? notes,
    bool? isLoading,
    String? error,
  }) {
    return BookingFormState(
      eventId: eventId ?? this.eventId,
      eventTitle: eventTitle ?? this.eventTitle,
      eventType: eventType ?? this.eventType,
      eventDate: eventDate ?? this.eventDate,
      eventLocation: eventLocation ?? this.eventLocation,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class BookingFormNotifier extends StateNotifier<BookingFormState> {
  BookingFormNotifier() : super(const BookingFormState());

  void setEventDetails({
    required String eventId,
    required String eventTitle,
    required String eventType,
    required DateTime eventDate,
    required String eventLocation,
    required double totalAmount,
    String? currency,
  }) {
    state = state.copyWith(
      eventId: eventId,
      eventTitle: eventTitle,
      eventType: eventType,
      eventDate: eventDate,
      eventLocation: eventLocation,
      totalAmount: totalAmount,
      currency: currency ?? 'USD',
    );
  }

  void setNumberOfGuests(int numberOfGuests) {
    state = state.copyWith(numberOfGuests: numberOfGuests);
  }

  void setNotes(String? notes) {
    state = state.copyWith(notes: notes);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading, error: null);
  }

  void setError(String? error) {
    state = state.copyWith(isLoading: false, error: error);
  }

  void reset() {
    state = const BookingFormState();
  }
}

// Payment form state
final paymentFormProvider =
    StateNotifierProvider<PaymentFormNotifier, PaymentFormState>((ref) {
      return PaymentFormNotifier();
    });

class PaymentFormState {
  final String cardNumber;
  final String expiryMonth;
  final String expiryYear;
  final String cvc;
  final String cardholderName;
  final bool savePaymentMethod;
  final bool isLoading;
  final String? error;

  const PaymentFormState({
    this.cardNumber = '',
    this.expiryMonth = '',
    this.expiryYear = '',
    this.cvc = '',
    this.cardholderName = '',
    this.savePaymentMethod = false,
    this.isLoading = false,
    this.error,
  });

  PaymentFormState copyWith({
    String? cardNumber,
    String? expiryMonth,
    String? expiryYear,
    String? cvc,
    String? cardholderName,
    bool? savePaymentMethod,
    bool? isLoading,
    String? error,
  }) {
    return PaymentFormState(
      cardNumber: cardNumber ?? this.cardNumber,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      cvc: cvc ?? this.cvc,
      cardholderName: cardholderName ?? this.cardholderName,
      savePaymentMethod: savePaymentMethod ?? this.savePaymentMethod,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class PaymentFormNotifier extends StateNotifier<PaymentFormState> {
  PaymentFormNotifier() : super(const PaymentFormState());

  void setCardNumber(String cardNumber) {
    state = state.copyWith(cardNumber: cardNumber);
  }

  void setExpiryMonth(String expiryMonth) {
    state = state.copyWith(expiryMonth: expiryMonth);
  }

  void setExpiryYear(String expiryYear) {
    state = state.copyWith(expiryYear: expiryYear);
  }

  void setCvc(String cvc) {
    state = state.copyWith(cvc: cvc);
  }

  void setCardholderName(String cardholderName) {
    state = state.copyWith(cardholderName: cardholderName);
  }

  void setSavePaymentMethod(bool savePaymentMethod) {
    state = state.copyWith(savePaymentMethod: savePaymentMethod);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading, error: null);
  }

  void setError(String? error) {
    state = state.copyWith(isLoading: false, error: error);
  }

  void reset() {
    state = const PaymentFormState();
  }
}

// Saved payment methods
final savedPaymentMethodsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Future.value([]);

  return PaymentService.getSavedPaymentMethods(user.uid);
});

// Booking actions
final bookingActionsProvider = Provider<BookingActions>((ref) {
  return BookingActions();
});

class BookingActions {
  // Create booking
  Future<Booking?> createBooking({
    required String eventId,
    required String eventTitle,
    required String eventType,
    required DateTime eventDate,
    required String eventLocation,
    required int numberOfGuests,
    required double totalAmount,
    required String currency,
    String? notes,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      return await BookingService.createBooking(
        eventId: eventId,
        eventTitle: eventTitle,
        eventType: eventType,
        eventDate: eventDate,
        eventLocation: eventLocation,
        numberOfGuests: numberOfGuests,
        totalAmount: totalAmount,
        currency: currency,
        notes: notes,
        metadata: metadata,
      );
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId, String reason) async {
    try {
      await BookingService.cancelBooking(bookingId, reason);
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  // Complete booking
  Future<void> completeBooking(String bookingId) async {
    try {
      await BookingService.completeBooking(bookingId);
    } catch (e) {
      throw Exception('Failed to complete booking: $e');
    }
  }

  // Process payment
  Future<void> processPayment({
    required String bookingId,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvc,
    required String cardholderName,
    required double amount,
    required String currency,
    bool savePaymentMethod = false,
  }) async {
    try {
      // Create payment method
      final paymentMethod = await PaymentService.createPaymentMethod(
        cardNumber: cardNumber,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        cvc: cvc,
        cardholderName: cardholderName,
      );

      // Create payment intent
      final paymentIntent = await PaymentService.createPaymentIntent(
        amount: amount,
        currency: currency,
        bookingId: bookingId,
      );

      // Process payment
      final result = await PaymentService.processPayment(
        paymentIntentId: paymentIntent['id'],
        paymentMethodId: paymentMethod['id'],
      );

      if (result.status == 'succeeded') {
        // Update booking payment status
        await BookingService.updatePaymentStatus(
          bookingId,
          PaymentStatus.paid,
          paymentIntentId: paymentIntent['id'],
          paymentMethodId: paymentMethod['id'],
        );

        // Save payment method if requested
        if (savePaymentMethod) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await PaymentService.savePaymentMethod(
              userId: user.uid,
              paymentMethodId: paymentMethod['id'],
              last4: cardNumber.substring(cardNumber.length - 4),
              brand: PaymentService.getCardBrand(cardNumber),
            );
          }
        }
      } else {
        throw Exception('Payment failed: ${result.status}');
      }
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }

  // Refund payment
  Future<void> refundPayment({
    required String bookingId,
    required String paymentIntentId,
    double? amount,
    String? reason,
  }) async {
    try {
      await PaymentService.refundPayment(
        paymentIntentId: paymentIntentId,
        bookingId: bookingId,
        amount: amount,
        reason: reason,
      );
    } catch (e) {
      throw Exception('Failed to refund payment: $e');
    }
  }
}
