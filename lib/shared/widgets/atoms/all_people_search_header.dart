import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/theme_extension.dart';

class AllPeopleSearchHeader extends StatelessWidget {
  final TextEditingController controller;
  final int totalItems;
  final String filterLabel;
  final bool showFilterLabel;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  const AllPeopleSearchHeader({
    super.key,
    required this.controller,
    required this.totalItems,
    required this.filterLabel,
    required this.showFilterLabel,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: appColors.pageBackground,
        border: Border(
          bottom: BorderSide(
            color: appColors.divider.withValues(alpha: isDark ? .35 : .55),
          ),
        ),
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            textInputAction: TextInputAction.search,
            style: context.text.bodyMedium?.copyWith(
              color: appColors.primaryText,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: 'Search people by name',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: appColors.secondaryText,
              ),
              suffixIcon: controller.text.trim().isEmpty
                  ? null
                  : IconButton(
                      onPressed: onClear,
                      icon: Icon(
                        Icons.close_rounded,
                        color: appColors.secondaryText,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  showFilterLabel
                      ? filterLabel
                      : totalItems > 0
                      ? '$totalItems people found'
                      : 'All people',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.labelMedium?.copyWith(
                    color: showFilterLabel
                        ? appColors.warning
                        : appColors.secondaryText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                'Press enter to search',
                style: context.text.labelSmall?.copyWith(
                  color: appColors.secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
