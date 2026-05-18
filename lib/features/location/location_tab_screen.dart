import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/pulse_indicator.dart';
import '../../core/widgets/section_header.dart';

class LocationTabScreen extends StatelessWidget {
  const LocationTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Text('Location', style: AppTextStyles.headlineLarge),
                    const Spacer(),
                    PulseIndicator(color: AppColors.info, size: 10, pulseSize: 22),
                    const SizedBox(width: 6),
                    Text('Tracking',
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.info)),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SectionHeader(title: 'LIVE TRACKING'),
                  GlassCard(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.liveLocation),
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: _MapPlaceholder(height: 180),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_rounded,
                                  color: AppColors.primary, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('24.8607° N, 67.0011° E',
                                        style: AppTextStyles.titleMedium),
                                    Text('Updated 2 mins ago',
                                        style: AppTextStyles.bodySmall),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('Open',
                                    style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms),
                  const SectionHeader(title: 'LOCATION HISTORY'),
                  ..._buildHistoryItems(context),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHistoryItems(BuildContext context) {
    final items = [
      ('2 mins ago', '24.8607° N, 67.0011° E', 'Karachi, Sindh'),
      ('1 hour ago', '24.8523° N, 67.0192° E', 'Saddar, Karachi'),
      ('3 hours ago', '24.8934° N, 66.9901° E', 'North Karachi'),
    ];
    return items.asMap().entries.map((e) {
      final (time, coords, address) = e.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GlassCard(
          onTap: () => Navigator.pushNamed(context, AppRoutes.locationHistory),
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.history_rounded, color: AppColors.info, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(address, style: AppTextStyles.titleMedium),
                    Text(coords, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              Text(time, style: AppTextStyles.bodySmall),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 150 * e.key + 200), duration: 400.ms),
      );
    }).toList();
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Container(color: const Color(0xFF0D1117)),
          CustomPaint(size: Size(double.infinity, height), painter: _GridPainter()),
          CustomPaint(size: Size(double.infinity, height), painter: _RoadPainter()),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 36),
                Container(width: 10, height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.3), shape: BoxShape.circle)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFF1A2030)..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }
  @override bool shouldRepaint(_) => false;
}

class _RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFF253040)..strokeWidth = 6..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height * 0.35), Offset(size.width, size.height * 0.35), p);
    canvas.drawLine(Offset(0, size.height * 0.65), Offset(size.width, size.height * 0.65), p);
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.3, size.height), p);
    canvas.drawLine(Offset(size.width * 0.7, 0), Offset(size.width * 0.7, size.height), p);
  }
  @override bool shouldRepaint(_) => false;
}
