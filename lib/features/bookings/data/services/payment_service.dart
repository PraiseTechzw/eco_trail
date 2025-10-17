import '../models/booking_model.dart';
import '../../../../core/services/firebase_service.dart';

// Mock payment result for demo purposes
class PaymentResult {
  final String status;
  final String? paymentIntentId;
  final String? paymentMethodId;

  PaymentResult({
    required this.status,
    this.paymentIntentId,
    this.paymentMethodId,
  });
}

class PaymentService {
  // Initialize payment service
  static Future<void> initialize() async {
    // In a real app, you would initialize Stripe or other payment providers here
    // For demo purposes, we'll just print a message
    print('Payment service initialized');
  }

  // Create payment intent (mock implementation)
  static Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    required String bookingId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // In a real app, you would call your backend API to create a payment intent
      // For demo purposes, we'll create a mock payment intent

      final paymentIntent = {
        'id': 'pi_${DateTime.now().millisecondsSinceEpoch}',
        'amount': (amount * 100).round(), // Convert to cents
        'currency': currency.toLowerCase(),
        'status': 'requires_payment_method',
        'metadata': {'bookingId': bookingId, ...?metadata},
      };

      return paymentIntent;
    } catch (e) {
      throw Exception('Failed to create payment intent: $e');
    }
  }

  // Process payment (mock implementation)
  static Future<PaymentResult> processPayment({
    required String paymentIntentId,
    required String paymentMethodId,
  }) async {
    try {
      // In a real app, you would process the payment through Stripe or other providers
      // For demo purposes, we'll simulate a successful payment

      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simulate processing time

      final result = PaymentResult(
        status: 'succeeded',
        paymentIntentId: paymentIntentId,
        paymentMethodId: paymentMethodId,
      );

      return result;
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }

  // Create payment method (mock implementation)
  static Future<Map<String, dynamic>> createPaymentMethod({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvc,
    String? cardholderName,
  }) async {
    try {
      // In a real app, you would create a payment method through Stripe or other providers
      // For demo purposes, we'll create a mock payment method

      final paymentMethod = {
        'id': 'pm_${DateTime.now().millisecondsSinceEpoch}',
        'type': 'card',
        'card': {
          'last4': cardNumber.substring(cardNumber.length - 4),
          'brand': getCardBrand(cardNumber),
          'exp_month': int.parse(expiryMonth),
          'exp_year': int.parse(expiryYear),
        },
        'billing_details': {'name': cardholderName},
      };

      return paymentMethod;
    } catch (e) {
      throw Exception('Failed to create payment method: $e');
    }
  }

  // Save payment method for future use
  static Future<void> savePaymentMethod({
    required String userId,
    required String paymentMethodId,
    required String last4,
    required String brand,
  }) async {
    try {
      await FirebaseService.firestore
          .collection('users')
          .doc(userId)
          .collection('payment_methods')
          .add({
            'paymentMethodId': paymentMethodId,
            'last4': last4,
            'brand': brand,
            'createdAt': DateTime.now(),
            'isDefault': false,
          });
    } catch (e) {
      throw Exception('Failed to save payment method: $e');
    }
  }

  // Get saved payment methods
  static Future<List<Map<String, dynamic>>> getSavedPaymentMethods(
    String userId,
  ) async {
    try {
      final snapshot = await FirebaseService.firestore
          .collection('users')
          .doc(userId)
          .collection('payment_methods')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      throw Exception('Failed to get saved payment methods: $e');
    }
  }

  // Delete saved payment method
  static Future<void> deleteSavedPaymentMethod(
    String userId,
    String paymentMethodId,
  ) async {
    try {
      await FirebaseService.firestore
          .collection('users')
          .doc(userId)
          .collection('payment_methods')
          .doc(paymentMethodId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete saved payment method: $e');
    }
  }

  // Refund payment
  static Future<void> refundPayment({
    required String paymentIntentId,
    required String bookingId,
    double? amount,
    String? reason,
  }) async {
    try {
      // In a real app, you would call your backend API to process the refund
      // For demo purposes, we'll just update the booking status

      await FirebaseService.firestore
          .collection('bookings')
          .doc(bookingId)
          .update({
            'status': BookingStatus.refunded.name,
            'paymentStatus': PaymentStatus.refunded.name,
            'updatedAt': DateTime.now(),
            'refundReason': reason,
            'refundedAt': DateTime.now(),
          });
    } catch (e) {
      throw Exception('Failed to refund payment: $e');
    }
  }

  // Validate card number
  static bool isValidCardNumber(String cardNumber) {
    // Remove spaces and non-digits
    final cleaned = cardNumber.replaceAll(RegExp(r'\D'), '');

    // Check if it's a valid length (13-19 digits)
    if (cleaned.length < 13 || cleaned.length > 19) {
      return false;
    }

    // Luhn algorithm validation
    int sum = 0;
    bool alternate = false;

    for (int i = cleaned.length - 1; i >= 0; i--) {
      int digit = int.parse(cleaned[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  // Get card brand from number
  static String getCardBrand(String cardNumber) {
    final cleaned = cardNumber.replaceAll(RegExp(r'\D'), '');

    if (cleaned.startsWith('4')) {
      return 'Visa';
    } else if (cleaned.startsWith('5') || cleaned.startsWith('2')) {
      return 'Mastercard';
    } else if (cleaned.startsWith('3')) {
      return 'American Express';
    } else if (cleaned.startsWith('6')) {
      return 'Discover';
    } else {
      return 'Unknown';
    }
  }

  // Format card number for display
  static String formatCardNumber(String cardNumber) {
    final cleaned = cardNumber.replaceAll(RegExp(r'\D'), '');
    final groups = <String>[];

    for (int i = 0; i < cleaned.length; i += 4) {
      groups.add(cleaned.substring(i, (i + 4).clamp(0, cleaned.length)));
    }

    return groups.join(' ');
  }

  // Format expiry date
  static String formatExpiryDate(String month, String year) {
    return '$month/${year.substring(2)}';
  }
}
