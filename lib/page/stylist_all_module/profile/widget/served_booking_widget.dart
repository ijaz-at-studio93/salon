import 'package:flutter/material.dart';
import 'package:salon/project_specific/stylist_appointment_overview_card.dart';

/// Served / completed booking row; optional [onView] shows the purple View button.
class ServedBookingWidget extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String image;
  final String id;
  final String name;
  final double price;
  final int serviceComplete;
  final VoidCallback? onView;

  const ServedBookingWidget({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.image,
    required this.name,
    required this.id,
    required this.serviceComplete,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return StylistAppointmentOverviewCard(
      customerName: name,
      startTimeIso: startTime,
      serviceCount: serviceComplete,
      onView: onView,
    );
  }
}
