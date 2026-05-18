import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';

class LocationHistoryScreen extends StatefulWidget {
  const LocationHistoryScreen({super.key});
  @override
  State<LocationHistoryScreen> createState() => _LocationHistoryScreenState();
}

class _LocationHistoryScreenState extends State<LocationHistoryScreen> {
  int _selectedFilter = 0;
  final _filters = ['All', 'Today', 'This Week'];

  final _groups = const [
    _HistoryGroup('TODAY — MAY 17, 2026', [
      _HistoryEntry('08:32 PM', '24.8607° N, 67.0011° E', 'Saddar, Karachi', '0.0 km'),
      _HistoryEntry('07:15 PM', '24.8523° N, 67.0192° E', 'Clifton, Karachi', '2.1 km'),
      _HistoryEntry('05:50 PM', '24.8701° N, 66.9901° E', 'Gulshan-e-Iqbal', '4.3 km'),
      _HistoryEntry('03:20 PM', '24.8934° N, 66.9780° E', 'North Karachi', '3.8 km'),
    ]),
    _HistoryGroup('YESTERDAY — MAY 16, 2026', [
      _HistoryEntry('09:45 PM', '24.8607° N, 67.0011° E', 'Saddar, Karachi', '0.0 km'),
      _HistoryEntry('06:30 PM', '24.8450° N, 67.0280° E', 'Defence, Karachi', '5.2 km'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: AppColors.textPrimary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Location History', style: AppTextStyles.headlineMedium),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.file_download_outlined,
                  size: 16, color: AppColors.textSecondary),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final sel = _selectedFilter == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = i),
                  child: AnimatedContainer(
                    duration: 200.ms,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.info : AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: sel ? AppColors.info : AppColors.border),
                    ),
                    child: Text(_filters[i],
                        style: AppTextStyles.labelMedium.copyWith(
                          color: sel ? Colors.white : AppColors.textSecondary,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                        )),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: _groups.asMap().entries.expand((ge) => [
                    SectionHeader(title: ge.value.date),
                    ..._buildTimeline(ge.value.entries, ge.key),
                  ]).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTimeline(List<_HistoryEntry> entries, int gi) {
    return entries.asMap().entries.map((e) {
      final isLast = e.key == entries.length - 1;
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 28,
              child: Column(
                children: [
                  Container(
                    width: 12, height: 12,
                    margin: const EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      color: e.key == 0 ? AppColors.info : AppColors.surfaceHighest,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: e.key == 0
                              ? AppColors.info.withOpacity(0.5)
                              : AppColors.border,
                          width: 2),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                        child: Container(
                            width: 2,
                            margin: const EdgeInsets.only(top: 4),
                            color: AppColors.border))
                  else
                    const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GlassCard(
                  onTap: () {},
                  child: Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.history_rounded,
                            color: AppColors.info, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.value.address, style: AppTextStyles.titleMedium),
                            Text(e.value.coords, style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(e.value.time, style: AppTextStyles.bodySmall),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.info.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(e.value.distance,
                                style: AppTextStyles.labelSmall
                                    .copyWith(color: AppColors.info)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(
                      delay: Duration(milliseconds: 80 * e.key + gi * 200),
                      duration: 350.ms),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class _HistoryGroup {
  final String date;
  final List<_HistoryEntry> entries;
  const _HistoryGroup(this.date, this.entries);
}

class _HistoryEntry {
  final String time;
  final String coords;
  final String address;
  final String distance;
  const _HistoryEntry(this.time, this.coords, this.address, this.distance);
}
