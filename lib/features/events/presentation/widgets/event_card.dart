import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/eco_location_model.dart';
import '../providers/events_provider.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;

  const EventCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    final status = getEventStatus(event);
    final isBookable = isEventBookable(event);
    final availabilityStatus = getEventAvailabilityStatus(event);

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
              // Header row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGray,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.category,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(status),
                ],
              ),
              const SizedBox(height: 12),

              // Date and time
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Text(
                    _formatEventDateTime(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.darkGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Location
              Row(
                children: [
                  Icon(
                    (event.latitude == 0.0 && event.longitude == 0.0)
                        ? Icons.computer
                        : Icons.location_on,
                    size: 16,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      event.location,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                event.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.mediumGray,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Tags
              if (event.tags.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: event.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.lightGreen,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],

              // Footer
              Row(
                children: [
                  // Price
                  if (event.price > 0) ...[
                    Text(
                      '\$${event.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'FREE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],

                  // Availability status
                  Expanded(
                    child: Text(
                      availabilityStatus,
                      style: TextStyle(
                        fontSize: 12,
                        color: isBookable
                            ? AppColors.mediumGray
                            : AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Book button
                  if (isBookable)
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement booking
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('Book'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'upcoming':
        chipColor = AppColors.info;
        break;
      case 'ongoing':
        chipColor = AppColors.success;
        break;
      case 'ended':
        chipColor = AppColors.mediumGray;
        break;
      default:
        chipColor = AppColors.mediumGray;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: chipColor, width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: chipColor,
        ),
      ),
    );
  }

  String _formatEventDateTime() {
    final startDate = DateFormat('MMM dd, yyyy').format(event.startDate);
    final startTime = DateFormat('HH:mm').format(event.startDate);
    final endTime = DateFormat('HH:mm').format(event.endDate);

    return '$startDate at $startTime - $endTime';
  }
}
