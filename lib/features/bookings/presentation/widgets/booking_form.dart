import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/booking_provider.dart';

class BookingForm extends ConsumerWidget {
  final String eventId;
  final String eventTitle;
  final String eventType;
  final DateTime eventDate;
  final String eventLocation;
  final double totalAmount;
  final String currency;
  final VoidCallback? onBookingCreated;

  const BookingForm({
    super.key,
    required this.eventId,
    required this.eventTitle,
    required this.eventType,
    required this.eventDate,
    required this.eventLocation,
    required this.totalAmount,
    required this.currency,
    this.onBookingCreated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(bookingFormProvider);
    final formNotifier = ref.read(bookingFormProvider.notifier);

    // Initialize form with event details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      formNotifier.setEventDetails(
        eventId: eventId,
        eventTitle: eventTitle,
        eventType: eventType,
        eventDate: eventDate,
        eventLocation: eventLocation,
        totalAmount: totalAmount,
        currency: currency,
      );
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event details summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Details',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow('Event', eventTitle),
                  _buildDetailRow(
                    'Date',
                    DateFormat('MMM dd, yyyy').format(eventDate),
                  ),
                  _buildDetailRow('Location', eventLocation),
                  _buildDetailRow('Type', eventType.toUpperCase()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Number of guests
          Text(
            'Number of Guests',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: formState.numberOfGuests > 1
                    ? () => formNotifier.setNumberOfGuests(
                        formState.numberOfGuests - 1,
                      )
                    : null,
                icon: const Icon(Icons.remove),
              ),
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGray),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  formState.numberOfGuests.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => formNotifier.setNumberOfGuests(
                  formState.numberOfGuests + 1,
                ),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Notes
          Text(
            'Additional Notes (Optional)',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Any special requests or notes...',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) =>
                formNotifier.setNotes(value.isEmpty ? null : value),
          ),
          const SizedBox(height: 20),

          // Total amount
          Card(
            color: AppColors.primaryGreen.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGray,
                    ),
                  ),
                  Text(
                    '$currency ${(totalAmount * formState.numberOfGuests).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Error message
          if (formState.error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: AppColors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      formState.error!,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Create booking button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: formState.isLoading
                  ? null
                  : () => _createBooking(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: formState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Create Booking',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontSize: 14, color: AppColors.mediumGray),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.darkGray,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createBooking(BuildContext context, WidgetRef ref) async {
    final formNotifier = ref.read(bookingFormProvider.notifier);
    final bookingActions = ref.read(bookingActionsProvider);

    formNotifier.setLoading(true);

    try {
      final booking = await bookingActions.createBooking(
        eventId: eventId,
        eventTitle: eventTitle,
        eventType: eventType,
        eventDate: eventDate,
        eventLocation: eventLocation,
        numberOfGuests: ref.read(bookingFormProvider).numberOfGuests,
        totalAmount: totalAmount,
        currency: currency,
        notes: ref.read(bookingFormProvider).notes,
      );

      if (booking != null) {
        formNotifier.reset();
        if (onBookingCreated != null) {
          onBookingCreated!();
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking created successfully!'),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
        }
      }
    } catch (e) {
      formNotifier.setError(e.toString());
    }
  }
}
