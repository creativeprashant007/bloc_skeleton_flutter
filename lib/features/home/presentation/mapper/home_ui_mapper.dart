import 'package:stock_control_master/features/home/domain/entities/team_mates/today_team_mates.dart';

import 'package:stock_control_master/features/home/domain/entities/today_shift_data.dart';
import 'package:stock_control_master/features/home/domain/entities/today_shift_item.dart'
    show TodayShiftItem;
import 'package:stock_control_master/features/home/domain/entities/today_shift_response.dart';
import 'package:stock_control_master/features/home/domain/models/teammate_ui_model.dart';
import 'package:stock_control_master/features/home/presentation/models/home_action_type.dart';
import 'package:stock_control_master/features/home/presentation/models/home_open_work_area_ui_model.dart';
import 'package:stock_control_master/features/home/presentation/models/home_shift_runtime_mode.dart';
import 'package:stock_control_master/features/home/presentation/models/home_ui_mapped_result.dart';
import 'package:stock_control_master/features/home/presentation/models/shift_ui_model.dart';

class HomeUiMapper {
  const HomeUiMapper._();

  static HomeUiMappedResult mapResponse(
    TodayShiftResponse response, {
    List<TodayTeammate>? team,
  }) {
    final data = response.data;

    final todayShift = _mapShift(data.todayShift);
    final nextShift = _mapShift(data.nextShift);

    return HomeUiMappedResult(
      todayShift: todayShift,
      nextShift: nextShift,
      activeSession: data.activeSession,
      actions: data.actions,
      runtimeMode: HomeShiftRuntimeModeX.fromApi(data.uiState.homeMode),
      primaryAction: HomeActionTypeX.fromApi(data.uiState.primaryAction),
      secondaryAction: HomeActionTypeX.fromApi(data.uiState.secondaryAction),
      openShiftWorkAreas: _buildOpenShiftAreas(data),
      availableShifts: _buildAvailableShifts(nextShift),
      teammates: team!,
    );
  }

  static ShiftUiModel? _mapShift(TodayShiftItem? item) {
    if (item == null) return null;

    final start = _combineDateAndTime(item.shiftDate, item.startTime);
    final end = _combineDateAndTime(item.shiftDate, item.endTime);

    return ShiftUiModel(
      id: item.id.toString(),
      apiShiftId: item.id,
      title: item.workAreaName,
      location: item.branchName,
      start: start,
      end: end,
      breakMinutes: item.breakDurationMins,
      isPublished: item.status.toLowerCase() == 'published',
      status: item.status,
    );
  }

  static DateTime _combineDateAndTime(String date, String time) {
    final cleanDate = date.trim();
    final cleanTime = time.trim();

    final fallbackDate = DateTime.now();

    if (cleanDate.isEmpty) {
      return DateTime(
        fallbackDate.year,
        fallbackDate.month,
        fallbackDate.day,
        _hourFromTime(cleanTime),
        _minuteFromTime(cleanTime),
      );
    }

    final safeTime = cleanTime.isEmpty ? '00:00:00' : cleanTime;
    final parsed = DateTime.tryParse('${cleanDate}T$safeTime');

    if (parsed != null) return parsed;

    return DateTime(
      fallbackDate.year,
      fallbackDate.month,
      fallbackDate.day,
      _hourFromTime(cleanTime),
      _minuteFromTime(cleanTime),
    );
  }

  static int _hourFromTime(String time) {
    if (time.isEmpty) return 0;

    final normalized = time.toUpperCase().trim();

    try {
      if (normalized.contains('AM') || normalized.contains('PM')) {
        final parts = normalized.replaceAll(RegExp(r'\s+'), ' ').split(' ');
        final hm = parts.first.split(':');
        var hour = int.tryParse(hm[0]) ?? 0;
        final isPm = parts.length > 1 && parts[1] == 'PM';

        if (isPm && hour != 12) hour += 12;
        if (!isPm && hour == 12) hour = 0;

        return hour;
      }

      return int.tryParse(normalized.split(':').first) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  static int _minuteFromTime(String time) {
    if (time.isEmpty) return 0;

    try {
      final normalized = time.toUpperCase().trim();
      final hm = normalized.split(' ').first.split(':');
      return hm.length > 1 ? int.tryParse(hm[1]) ?? 0 : 0;
    } catch (_) {
      return 0;
    }
  }

  static List<HomeOpenWorkAreaUiModel> _buildOpenShiftAreas(
    TodayShiftData data,
  ) {
    final results = <HomeOpenWorkAreaUiModel>[];

    void addArea({
      required int id,
      required String name,
      required int branchId,
      required String branchName,
    }) {
      final exists = results.any((e) => e.id == id && e.branchId == branchId);
      if (!exists) {
        results.add(
          HomeOpenWorkAreaUiModel(
            id: id,
            name: name,
            branchId: branchId,
            branchName: branchName,
          ),
        );
      }
    }

    final today = data.todayShift;
    if (today != null) {
      addArea(
        id: today.workAreaId,
        name: today.workAreaName,
        branchId: today.branchId,
        branchName: today.branchName,
      );
    }

    final next = data.nextShift;
    if (next != null) {
      addArea(
        id: next.workAreaId,
        name: next.workAreaName,
        branchId: next.branchId,
        branchName: next.branchName,
      );
    }

    final active = data.activeSession;
    if (active != null) {
      addArea(
        id: active.workAreaId,
        name: active.workAreaName,
        branchId: active.branchId,
        branchName: active.branchName,
      );
    }

    if (results.isEmpty) {
      results.add(
        const HomeOpenWorkAreaUiModel(
          id: 0,
          name: 'Open Shift',
          branchId: 0,
          branchName: 'Select work area',
        ),
      );
    }

    return results;
  }

  static List<ShiftUiModel> _buildAvailableShifts(ShiftUiModel? nextShift) {
    if (nextShift == null) return const [];
    return [nextShift];
  }

  static List<TeammateUiModel> _buildDemoTeammates() {
    return const [
      TeammateUiModel(
        name: 'Sujal',
        imageUrl:
            'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
        shiftTime: '09:00 - 17:00',
      ),
      TeammateUiModel(
        name: 'Andrew',
        imageUrl:
            'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
        shiftTime: '10:00 - 18:00',
      ),
      TeammateUiModel(
        name: 'Rew',
        imageUrl:
            'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
        shiftTime: '12:00 - 20:00',
      ),
    ];
  }
}
