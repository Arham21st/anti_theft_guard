import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'admin_ui_components.dart';

class AdminDataTable extends StatelessWidget {
  const AdminDataTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  final List<DataColumn> columns;
  final List<DataRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: AppColors.border,
            dataTableTheme: DataTableThemeData(
              headingRowColor: WidgetStateProperty.all(AppColors.surfaceHighest),
              headingTextStyle: AdminTextStyles.label.copyWith(color: AppColors.textSecondary),
              dataTextStyle: AdminTextStyles.body.copyWith(color: AppColors.textPrimary),
              dataRowColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                if (states.contains(WidgetState.hovered)) {
                  return AppColors.primary.withOpacity(0.04);
                }
                return Colors.transparent;
              }),
              horizontalMargin: 16,
              columnSpacing: 24,
              headingRowHeight: 48,
              dataRowMinHeight: 48,
              dataRowMaxHeight: 56,
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.5,
              ),
              child: DataTable(
                columns: columns,
                rows: rows,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
