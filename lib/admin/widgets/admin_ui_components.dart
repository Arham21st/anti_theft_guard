import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

class AdminTextStyles {
  AdminTextStyles._();

  static TextStyle get pageTitle => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  static TextStyle get sectionTitle => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  static TextStyle get cardTitle => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  static TextStyle get body => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 0,
  );

  static TextStyle get small => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.35,
    letterSpacing: 0,
  );

  static TextStyle get label => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    letterSpacing: 0,
  );

  static TextStyle get metric => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  static TextStyle get mono => GoogleFonts.sourceCodePro(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.success,
    letterSpacing: 0,
  );
}

class AdminPanel extends StatelessWidget {
  const AdminPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.header,
    this.trailing,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final String? header;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null || trailing != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
              child: Row(
                children: [
                  if (header != null)
                    Text(header!, style: AdminTextStyles.sectionTitle),
                  const Spacer(),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}

class AdminIconButton extends StatelessWidget {
  const AdminIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, color: color ?? AppColors.textSecondary, size: 18),
        ),
      ),
    );
  }
}

class AdminPrimaryButton extends StatelessWidget {
  const AdminPrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.color = AppColors.primary,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 17),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: AdminTextStyles.label,
      ),
    );
  }
}

class AdminPageHeader extends StatelessWidget {
  const AdminPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.actions = const [],
  });

  final String title;
  final String subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AdminTextStyles.pageTitle),
              const SizedBox(height: 5),
              Text(subtitle, style: AdminTextStyles.body),
            ],
          ),
        ),
        if (actions.isNotEmpty)
          Wrap(spacing: 8, runSpacing: 8, children: actions),
      ],
    );
  }
}

class AdminSectionTitle extends StatelessWidget {
  const AdminSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AdminTextStyles.sectionTitle),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: AdminTextStyles.small),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class AdminSearchField extends StatelessWidget {
  const AdminSearchField({
    super.key,
    this.hint = 'Search demo data',
    this.width = 280,
  });

  final String hint;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        enabled: false,
        style: AdminTextStyles.body,
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: AdminTextStyles.small,
          prefixIcon: const Icon(Icons.search_rounded, size: 18),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          filled: true,
          fillColor: AppColors.surfaceElevated,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
      ),
    );
  }
}

class AdminEmptyMediaTile extends StatelessWidget {
  const AdminEmptyMediaTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 154,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _GridPainter(color: color)),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 30),
                const SizedBox(height: 10),
                Text(title, style: AdminTextStyles.cardTitle),
                const SizedBox(height: 4),
                Text(subtitle, style: AdminTextStyles.small),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminToggleRow extends StatefulWidget {
  const AdminToggleRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.initialValue,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool initialValue;

  @override
  State<AdminToggleRow> createState() => _AdminToggleRowState();
}

class _AdminToggleRowState extends State<AdminToggleRow> {
  late bool value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: value
                ? widget.color.withOpacity(0.12)
                : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            widget.icon,
            color: value ? widget.color : AppColors.textTertiary,
            size: 19,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: AdminTextStyles.cardTitle),
              const SizedBox(height: 3),
              Text(widget.subtitle, style: AdminTextStyles.small),
            ],
          ),
        ),
        Switch(
          value: value,
          activeColor: Colors.white,
          activeTrackColor: widget.color,
          inactiveThumbColor: AppColors.textTertiary,
          inactiveTrackColor: AppColors.surfaceHighest,
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          onChanged: (next) => setState(() => value = next),
        ),
      ],
    );
  }
}

class AdminSegmentedControl extends StatefulWidget {
  const AdminSegmentedControl({
    super.key,
    required this.options,
    required this.color,
    this.initialIndex = 0,
  });

  final List<String> options;
  final Color color;
  final int initialIndex;

  @override
  State<AdminSegmentedControl> createState() => _AdminSegmentedControlState();
}

class _AdminSegmentedControlState extends State<AdminSegmentedControl> {
  late int selected = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.options.asMap().entries.map((entry) {
        final isSelected = selected == entry.key;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: entry.key == widget.options.length - 1 ? 0 : 8,
            ),
            child: InkWell(
              onTap: () => setState(() => selected = entry.key),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? widget.color.withOpacity(0.14)
                      : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? widget.color.withOpacity(0.45)
                        : AppColors.border,
                  ),
                ),
                child: Text(
                  entry.value,
                  style: AdminTextStyles.label.copyWith(
                    color: isSelected ? widget.color : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.06)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
