import 'package:flutter/material.dart';
import '../../core/utils/formatters.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color? color;
  final bool isAtm;

  const StatusBadge({
    super.key,
    required this.text,
    this.color,
    this.isAtm = false,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ??
        (isAtm ? Formatters.getAtmStatusColor(text) : Formatters.getTicketStatusColor(text));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withOpacity(0.4), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
