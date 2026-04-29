import 'package:flutter/material.dart';
import 'package:salon/project_specific/stylist_appointment_overview_card.dart';

class AcceptBookingOverViewWidget extends StatelessWidget {
  final String customerName;
  final String startTime;
  final int serviceCount;
  final VoidCallback onPress;

  const AcceptBookingOverViewWidget({
    super.key,
    required this.customerName,
    required this.startTime,
    required this.serviceCount,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return StylistAppointmentOverviewCard(
      customerName: customerName,
      startTimeIso: startTime,
      serviceCount: serviceCount,
      onView: onPress,
    );
  }
}
