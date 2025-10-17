import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/booking_model.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onComplete;

  const BookingCard({
    super.key,
    required this.booking,
    this.onTap,
    this.onCancel,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusChip(booking.status),
                  Text(
                    DateFormat('MMM dd, yyyy').format(booking.eventDate),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.mediumGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Event title
              Text(
                booking.eventTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGray,
                ),
              ),
              const SizedBox(height: 8),

              // Event details
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColors.mediumGray,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      booking.eventLocation,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              Row(
                children: [
                  Icon(Icons.people, size: 16, color: AppColors.mediumGray),
                  const SizedBox(width: 4),
                  Text(
                    '${booking.numberOfGuests} ${booking.numberOfGuests == 1 ? 'guest' : 'guests'}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.mediumGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Payment status and amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPaymentStatusChip(booking.paymentStatus),
                  Text(
                    '${booking.currency} ${booking.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),

              // Action buttons
              if (_shouldShowActions(booking)) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (booking.status == BookingStatus.confirmed) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onCancel,
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onComplete,
                          child: const Text('Complete'),
                        ),
                      ),
                    ] else if (booking.status == BookingStatus.pending) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onCancel,
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BookingStatus status) {
    Color color;
    String text;

    switch (status) {
      case BookingStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case BookingStatus.confirmed:
        color = AppColors.primaryGreen;
        text = 'Confirmed';
        break;
      case BookingStatus.cancelled:
        color = AppColors.error;
        text = 'Cancelled';
        break;
      case BookingStatus.completed:
        color = AppColors.secondaryGreen;
        text = 'Completed';
        break;
      case BookingStatus.refunded:
        color = AppColors.mediumGray;
        text = 'Refunded';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPaymentStatusChip(PaymentStatus status) {
    Color color;
    String text;

    switch (status) {
      case PaymentStatus.pending:
        color = Colors.orange;
        text = 'Payment Pending';
        break;
      case PaymentStatus.paid:
        color = AppColors.primaryGreen;
        text = 'Paid';
        break;
      case PaymentStatus.failed:
        color = AppColors.error;
        text = 'Payment Failed';
        break;
      case PaymentStatus.refunded:
        color = AppColors.mediumGray;
        text = 'Refunded';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  bool _shouldShowActions(Booking booking) {
    return booking.status == BookingStatus.pending ||
        booking.status == BookingStatus.confirmed;
  }
}
