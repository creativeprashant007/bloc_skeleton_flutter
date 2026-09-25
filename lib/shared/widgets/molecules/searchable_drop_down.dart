import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stock_control_master/core/theme/theme_extension.dart'
    show ThemeX;

class AppSearchablePickerField<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T> onSelected;

  final IconData icon;
  final IconData? prefixIcon;
  final bool searchable;
  final bool enabled;
  final bool isError;
  final String? label;
  final String? helperText;
  final String searchHint;
  final String emptyText;
  final String? sheetTitle;

  const AppSearchablePickerField({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onSelected,
    this.icon = Icons.keyboard_arrow_down_rounded,
    this.prefixIcon,
    this.searchable = true,
    this.enabled = true,
    this.isError = false,
    this.label,
    this.helperText,
    this.searchHint = 'Search',
    this.emptyText = 'No items found',
    this.sheetTitle,
  });

  Future<void> _showPicker(BuildContext context) async {
    if (!enabled) return;

    final selectedItem = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _SearchablePickerSheet<T>(
          hint: hint,
          value: value,
          items: items,
          itemLabel: itemLabel,
          prefixIcon: prefixIcon,
          searchable: searchable,
          label: label,
          searchHint: searchHint,
          emptyText: emptyText,
          sheetTitle: sheetTitle,
        );
      },
    );

    if (selectedItem != null) {
      onSelected(selectedItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    final selectedText = value == null ? hint : itemLabel(value as T);

    final borderColor = isError
        ? appColors.error
        : appColors.divider.withValues(alpha: isDark ? .48 : .70);

    final activeColor = isError ? appColors.error : appColors.accent;

    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: enabled ? () => _showPicker(context) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: enabled
              ? appColors.cardBackground.withValues(alpha: isDark ? .76 : 1)
              : appColors.divider.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            if (prefixIcon != null) ...[
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: activeColor.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Icon(prefixIcon, size: 18.sp, color: activeColor),
              ),
              SizedBox(width: 11.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null && label!.trim().isNotEmpty) ...[
                    Text(
                      label!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: appColors.secondaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                  Text(
                    selectedText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: value == null
                          ? appColors.secondaryText
                          : appColors.primaryText,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      height: 1.18,
                    ),
                  ),
                  if (helperText != null && helperText!.trim().isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(
                      helperText!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: appColors.secondaryText.withValues(alpha: .82),
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp,
                        height: 1.18,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              icon,
              color: appColors.secondaryText.withValues(alpha: .75),
              size: 21.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchablePickerSheet<T> extends StatefulWidget {
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T item) itemLabel;

  final IconData? prefixIcon;
  final bool searchable;
  final String? label;
  final String searchHint;
  final String emptyText;
  final String? sheetTitle;

  const _SearchablePickerSheet({
    required this.hint,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.prefixIcon,
    required this.searchable,
    required this.label,
    required this.searchHint,
    required this.emptyText,
    required this.sheetTitle,
  });

  @override
  State<_SearchablePickerSheet<T>> createState() =>
      _SearchablePickerSheetState<T>();
}

class _SearchablePickerSheetState<T> extends State<_SearchablePickerSheet<T>> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late List<T> _filteredItems;

  static const double _sheetHorizontalMargin = 12;

  static const double _dragHandleHeight = 5;
  static const double _topPadding = 12;
  static const double _bottomPadding = 14;
  static const double _handleToHeaderGap = 14;

  static const double _headerHeight = 44;
  static const double _searchGap = 12;
  static const double _searchHeight = 48;
  static const double _listGap = 12;

  static const double _itemHeight = 44;
  static const double _itemGap = 6;
  static const double _emptyHeight = 74;

  @override
  void initState() {
    super.initState();
    _filteredItems = List<T>.from(widget.items);
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final query = value.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredItems = List<T>.from(widget.items);
        return;
      }

      _filteredItems = widget.items.where((item) {
        return widget.itemLabel(item).trim().toLowerCase().contains(query);
      }).toList();
    });
  }

  void _close() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  void _selectItem(T item) {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(item);
  }

  double _fixedContentHeight() {
    return _topPadding.h +
        _dragHandleHeight.h +
        _handleToHeaderGap.h +
        _headerHeight.h +
        (widget.searchable ? (_searchGap.h + _searchHeight.h) : 0) +
        _listGap.h +
        _bottomPadding.h;
  }

  double _wantedListHeight(int itemCount) {
    if (itemCount <= 0) return _emptyHeight.h;

    final itemHeights = itemCount * _itemHeight.h;
    final gapHeights = math.max(0, itemCount - 1) * _itemGap.h;

    return itemHeights + gapHeights;
  }

  double _maxSheetHeight(BuildContext context, double keyboardBottom) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    if (keyboardBottom > 0) {
      return screenHeight * 0.58;
    }

    return screenHeight * 0.72;
  }

  double _listHeight({
    required BuildContext context,
    required double keyboardBottom,
    required int itemCount,
  }) {
    final maxSheetHeight = _maxSheetHeight(context, keyboardBottom);
    final fixedHeight = _fixedContentHeight();

    final maxListHeight = math.max(90.h, maxSheetHeight - fixedHeight);

    final wantedListHeight = _wantedListHeight(itemCount);

    return math.min(wantedListHeight, maxListHeight);
  }

  bool _shouldListScroll({
    required BuildContext context,
    required double keyboardBottom,
    required int itemCount,
  }) {
    final wanted = _wantedListHeight(itemCount);
    final actual = _listHeight(
      context: context,
      keyboardBottom: keyboardBottom,
      itemCount: itemCount,
    );

    return wanted > actual + 1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    final keyboardBottom = MediaQuery.viewInsetsOf(context).bottom;

    final listHeight = _listHeight(
      context: context,
      keyboardBottom: keyboardBottom,
      itemCount: _filteredItems.length,
    );

    final shouldListScroll = _shouldListScroll(
      context: context,
      keyboardBottom: keyboardBottom,
      itemCount: _filteredItems.length,
    );

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: keyboardBottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.fromLTRB(
            _sheetHorizontalMargin.w,
            0,
            _sheetHorizontalMargin.w,
            12.h,
          ),
          decoration: BoxDecoration(
            color: appColors.cardBackground,
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(
              color: appColors.divider.withValues(alpha: isDark ? .42 : .60),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? .22 : .09),
                blurRadius: 22.r,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16.w,
                _topPadding.h,
                16.w,
                _bottomPadding.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 46.w,
                    height: _dragHandleHeight.h,
                    decoration: BoxDecoration(
                      color: appColors.divider,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                  SizedBox(height: _handleToHeaderGap.h),
                  SizedBox(
                    height: _headerHeight.h,
                    child: Row(
                      children: [
                        Container(
                          width: 38.w,
                          height: 38.w,
                          decoration: BoxDecoration(
                            color: appColors.accent.withValues(alpha: .11),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Icon(
                            widget.prefixIcon ?? Icons.list_alt_rounded,
                            color: appColors.accent,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            widget.sheetTitle ?? widget.label ?? widget.hint,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: appColors.primaryText,
                              fontWeight: FontWeight.w700,
                              fontSize: 17.sp,
                              height: 1.18,
                            ),
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: _close,
                          icon: Icon(
                            Icons.close_rounded,
                            color: appColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.searchable) ...[
                    SizedBox(height: _searchGap.h),
                    SizedBox(
                      height: _searchHeight.h,
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: _onSearchChanged,
                        scrollPadding: EdgeInsets.only(bottom: 180.h),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: appColors.primaryText,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.searchHint,
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: appColors.secondaryText.withValues(
                              alpha: .70,
                            ),
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: appColors.secondaryText,
                            size: 20.sp,
                          ),
                          filled: true,
                          fillColor: appColors.pageBackground.withValues(
                            alpha: isDark ? .42 : .75,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 12.h,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color: appColors.divider.withValues(
                                alpha: isDark ? .45 : .65,
                              ),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color: appColors.accent.withValues(alpha: .75),
                              width: 1.2.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: _listGap.h),
                  SizedBox(
                    height: listHeight,
                    child: _filteredItems.isEmpty
                        ? Center(
                            child: Text(
                              widget.emptyText,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: appColors.secondaryText,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.zero,
                            physics: shouldListScroll
                                ? const BouncingScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: _filteredItems.length,
                            separatorBuilder: (_, _) =>
                                SizedBox(height: _itemGap.h),
                            itemBuilder: (context, index) {
                              final item = _filteredItems[index];
                              final isSelected = widget.value == item;

                              return SizedBox(
                                height: _itemHeight.h,
                                child: Material(
                                  color: isSelected
                                      ? appColors.accent.withValues(alpha: .10)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(14.r),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(14.r),
                                    onTap: () => _selectItem(item),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          14.r,
                                        ),
                                        border: Border.all(
                                          color: isSelected
                                              ? appColors.accent.withValues(
                                                  alpha: .24,
                                                )
                                              : appColors.divider.withValues(
                                                  alpha: .35,
                                                ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              widget.itemLabel(item),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: theme.textTheme.titleSmall
                                                  ?.copyWith(
                                                    color:
                                                        appColors.primaryText,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12.5.sp,
                                                    height: 1.2,
                                                  ),
                                            ),
                                          ),
                                          if (isSelected)
                                            Icon(
                                              Icons.check_circle_rounded,
                                              color: appColors.accent,
                                              size: 16.sp,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
