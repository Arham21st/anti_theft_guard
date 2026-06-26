import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/glow_button.dart';

class EmergencySmsScreen extends StatefulWidget {
  const EmergencySmsScreen({super.key});
  @override
  State<EmergencySmsScreen> createState() => _EmergencySmsScreenState();
}

class _EmergencySmsScreenState extends State<EmergencySmsScreen> {
  bool _sendLocation = true;
  bool _sendBattery = true;
  bool _sendWipeCode = false;

  final List<_Contact> _contacts = [
    _Contact('Wife', '+1 234 567 8901', true),
    _Contact('Dad', '+1 987 654 3210', true),
    _Contact('Office', '+1 555 123 4567', false),
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
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppColors.textPrimary,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Emergency SMS', style: AppTextStyles.headlineMedium),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                _buildInfoHero(),
                const SectionHeader(title: 'TRUSTED CONTACTS'),
                ..._buildContactsList(),
                const SizedBox(height: 10),
                OutlineButton(
                  label: 'Add Contact',
                  icon: Icons.person_add_alt_1_rounded,
                  onPressed: () {},
                  borderColor: AppColors.borderHighlight,
                  textColor: AppColors.info,
                ).animate().fadeIn(delay: 260.ms),
                const SectionHeader(title: 'MESSAGE PAYLOAD'),
                GlassCard(
                  child: Column(
                    children: [
                      _buildToggleRow(
                        'GPS Location Link',
                        'Google Maps URL of current location',
                        _sendLocation,
                        (v) => setState(() => _sendLocation = v),
                      ),
                      Divider(color: AppColors.border, height: 24),
                      _buildToggleRow(
                        'Battery Status',
                        'Current battery % and state',
                        _sendBattery,
                        (v) => setState(() => _sendBattery = v),
                      ),
                      Divider(color: AppColors.border, height: 24),
                      _buildToggleRow(
                        'Remote Wipe Code',
                        'Include instructions to wipe device',
                        _sendWipeCode,
                        (v) => setState(() => _sendWipeCode = v),
                        isDanger: true,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 340.ms),
                const SectionHeader(title: 'MESSAGE PREVIEW'),
                _buildMessagePreview(),
                const SizedBox(height: 20),
                GlowButton(
                  label: 'Send Test SMS',
                  icon: Icons.send_rounded,
                  onPressed: () {},
                  gradient: AppColors.primaryGradient,
                  glowColor: AppColors.primary,
                ).animate().fadeIn(delay: 480.ms),
                const SizedBox(height: 28),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoHero() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.emergency_share_rounded,
              color: AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Silent Distress Signal', style: AppTextStyles.titleLarge),
                const SizedBox(height: 4),
                Text(
                  'Sends an SMS with critical info to your trusted contacts without leaving a trace in the messaging app.',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  List<Widget> _buildContactsList() {
    return _contacts.asMap().entries.map((e) {
      final contact = e.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.surfaceHighest,
                child: Text(
                  contact.name.substring(0, 1),
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contact.name, style: AppTextStyles.titleMedium),
                    Text(contact.number, style: AppTextStyles.mono),
                  ],
                ),
              ),
              Switch(
                value: contact.enabled,
                onChanged: (v) => setState(() => contact.enabled = v),
                activeTrackColor: AppColors.success,
                activeThumbColor: Colors.white,
                inactiveThumbColor: AppColors.textTertiary,
                inactiveTrackColor: AppColors.surfaceHighest,
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              ),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 150 + (e.key * 50))),
      );
    }).toList();
  }

  Widget _buildToggleRow(
    String title,
    String sub,
    bool val,
    ValueChanged<bool> onChange, {
    bool isDanger = false,
  }) {
    final color = isDanger ? AppColors.danger : AppColors.info;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleMedium),
              Text(sub, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
        Switch(
          value: val,
          onChanged: onChange,
          activeTrackColor: color,
          activeThumbColor: Colors.white,
          inactiveThumbColor: AppColors.textTertiary,
          inactiveTrackColor: AppColors.surfaceHighest,
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ],
    );
  }

  Widget _buildMessagePreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(4),
        ),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚠️ ANTI-THEFT ALERT',
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            'My phone was marked stolen.\n\n'
            '${_sendLocation ? '📍 Loc: https://maps.google.com/?q=24.8607,67.0011\n' : ''}'
            '${_sendBattery ? '🔋 Bat: 42% (Discharging)\n' : ''}'
            '${_sendWipeCode ? '🗑️ Text "WIPE_XYZ99" to factory reset this device.\n' : ''}'
            '\nDo not call. Silent mode is active.',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 420.ms);
  }
}

class _Contact {
  final String name;
  final String number;
  bool enabled;
  _Contact(this.name, this.number, this.enabled);
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
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
