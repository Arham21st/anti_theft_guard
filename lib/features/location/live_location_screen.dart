import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/glow_button.dart';
import '../../core/widgets/pulse_indicator.dart';

class LiveLocationScreen extends StatefulWidget {
  const LiveLocationScreen({super.key});

  @override
  State<LiveLocationScreen> createState() => _LiveLocationScreenState();
}

class _LiveLocationScreenState extends State<LiveLocationScreen> {
  bool _isRefreshing = false;

  void _refresh() {
    setState(() => _isRefreshing = true);
    Future.delayed(const Duration(seconds: 1),
        () => setState(() => _isRefreshing = false));
  }

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
        title: Text('Live Location', style: AppTextStyles.headlineMedium),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                PulseIndicator(
                    color: AppColors.info, size: 8, pulseSize: 18),
                const SizedBox(width: 6),
                Text('LIVE',
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.info)),
              ],
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Map view
                _buildMapCard(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Coordinate card
                      _buildCoordinateCard(),
                      const SizedBox(height: 12),
                      // Accuracy + address
                      _buildInfoRow(),
                      const SizedBox(height: 16),
                      // Action buttons
                      _buildActionButtons(),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.info.withOpacity(0.08),
            blurRadius: 20,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Map background
            Container(color: const Color(0xFF0D1117)),
            CustomPaint(
                size: const Size(double.infinity, 280),
                painter: _GridPainter()),
            CustomPaint(
                size: const Size(double.infinity, 280),
                painter: _RoadPainter()),
            // Center marker with pulse
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.info.withOpacity(0.4), width: 2),
                    ),
                    child: const Icon(Icons.my_location_rounded,
                        color: AppColors.info, size: 24),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('You are here',
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.info)),
                  ),
                ],
              ),
            ),
            // Accuracy circle overlay
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.06),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.info.withOpacity(0.2), width: 1),
                ),
              ),
            ),
            // Top overlay: live indicator
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PulseIndicator(
                        color: AppColors.info, size: 6, pulseSize: 14),
                    const SizedBox(width: 6),
                    Text('Real-time GPS',
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.info)),
                  ],
                ),
              ),
            ),
            // Refresh button
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: _refresh,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.background.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: _isRefreshing
                      ? const Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.info),
                        )
                      : const Icon(Icons.refresh_rounded,
                          color: AppColors.textSecondary, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildCoordinateCard() {
    return GlassCard(
      glowColor: AppColors.info,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.location_on_rounded,
                color: AppColors.info, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('24.8607° N, 67.0011° E',
                    style: AppTextStyles.titleLarge
                        .copyWith(fontFamily: 'monospace')),
                Text('Updated just now', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Text('COPY',
                  style:
                      AppTextStyles.labelSmall.copyWith(color: AppColors.info)),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        Expanded(
          child: _InfoChip(
            icon: Icons.gps_fixed_rounded,
            label: '±5m',
            sublabel: 'Accuracy',
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _InfoChip(
            icon: Icons.speed_rounded,
            label: '0 km/h',
            sublabel: 'Speed',
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _InfoChip(
            icon: Icons.terrain_rounded,
            label: '12m',
            sublabel: 'Altitude',
            color: AppColors.secondary,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        GlassCard(
          child: Row(
            children: [
              const Icon(Icons.location_city_rounded,
                  color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Saddar, Karachi, Sindh',
                        style: AppTextStyles.titleMedium),
                    Text('Pakistan', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 360.ms),
        const SizedBox(height: 16),
        GlowButton(
          label: 'Share Location',
          icon: Icons.share_location_rounded,
          onPressed: () {},
          gradient: AppColors.primaryGradient,
          glowColor: AppColors.primary,
        ).animate().fadeIn(delay: 420.ms),
        const SizedBox(height: 10),
        OutlineButton(
          label: 'View on Map',
          icon: Icons.open_in_new_rounded,
          onPressed: () {},
          borderColor: AppColors.border,
          textColor: AppColors.textSecondary,
        ).animate().fadeIn(delay: 460.ms),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 5),
          Text(label,
              style: AppTextStyles.labelLarge.copyWith(color: color),
              overflow: TextOverflow.ellipsis),
          Text(sublabel, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF1A2030)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF253040)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(0, size.height * 0.35), Offset(size.width, size.height * 0.35), p);
    canvas.drawLine(
        Offset(0, size.height * 0.65), Offset(size.width, size.height * 0.65), p);
    canvas.drawLine(
        Offset(size.width * 0.3, 0), Offset(size.width * 0.3, size.height), p);
    canvas.drawLine(
        Offset(size.width * 0.72, 0), Offset(size.width * 0.72, size.height), p);
  }

  @override
  bool shouldRepaint(_) => false;
}

class OutlineButton extends StatelessWidget {
  const OutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.borderColor = AppColors.border,
    this.textColor = AppColors.textPrimary,
    this.width = double.infinity,
    this.height = 52,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color borderColor;
  final Color textColor;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label,
                  style:
                      AppTextStyles.labelLarge.copyWith(color: textColor)),
            ],
          ),
        ),
      ),
    );
  }
}
