import 'package:flutter/material.dart';

import 'admin_ui_components.dart';

class AdminStatCard extends StatelessWidget {
  const AdminStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.change,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String change;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AdminPanel(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AdminTextStyles.small),
                const SizedBox(height: 4),
                Text(value, style: AdminTextStyles.metric),
                const SizedBox(height: 4),
                Text(
                  change,
                  style: AdminTextStyles.small.copyWith(color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
