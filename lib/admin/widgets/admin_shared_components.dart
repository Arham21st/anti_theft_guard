import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../models/admin_device.dart';
import 'admin_ui_components.dart';

class AdminInfoLine extends StatelessWidget {
  const AdminInfoLine({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AdminTextStyles.small)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            style: AdminTextStyles.cardTitle,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class AdminMetricData {
  const AdminMetricData(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;
}

class AdminMetricGrid extends StatelessWidget {
  const AdminMetricGrid({super.key, required this.metrics});

  final List<AdminMetricData> metrics;

  @override
  Widget build(BuildContext context) {
    return AdminResponsiveGrid(
      minItemWidth: 128,
      spacing: 10,
      children: metrics.map((metric) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(metric.label, style: AdminTextStyles.small),
              const SizedBox(height: 6),
              Text(
                metric.value,
                style: AdminTextStyles.cardTitle.copyWith(color: metric.color),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class AdminAvatar extends StatelessWidget {
  const AdminAvatar({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderHighlight),
      ),
      child: Text(
        initial,
        style: AdminTextStyles.label.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}

class AdminDeviceIdentity extends StatelessWidget {
  const AdminDeviceIdentity({
    super.key,
    required this.device,
    this.compact = false,
  });

  final AdminDevice device;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!compact) ...[
          AdminAvatar(name: device.ownerName),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                device.ownerName,
                style: AdminTextStyles.cardTitle,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                device.deviceName,
                style: AdminTextStyles.small,
                overflow: TextOverflow.ellipsis,
              ),
              if (!compact) ...[
                const SizedBox(height: 3),
                Text(
                  device.ownerEmail,
                  style: AdminTextStyles.small,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class AdminEmptyState extends StatelessWidget {
  const AdminEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.textTertiary, size: 30),
          const SizedBox(height: 10),
          Text(title, style: AdminTextStyles.cardTitle),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AdminTextStyles.small,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class AdminResponsiveGrid extends StatelessWidget {
  const AdminResponsiveGrid({
    super.key,
    required this.children,
    required this.minItemWidth,
    this.spacing = 14,
    this.maxColumns,
  });

  final List<Widget> children;
  final double minItemWidth;
  final double spacing;
  final int? maxColumns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final estimated = (constraints.maxWidth / minItemWidth).floor();
        final columns = math.max(
          1,
          maxColumns == null ? estimated : math.min(maxColumns!, estimated),
        );
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children.map((child) {
            return SizedBox(width: itemWidth, child: child);
          }).toList(),
        );
      },
    );
  }
}
