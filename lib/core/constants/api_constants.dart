class ApiConstants {
  static const String login = "/login";
  static const String getScheduleList = "/weekly-schedule";
  static const String register = "/employee/registration";
  static const String verifyOtp = "";
  static const String timesheet = "/timesheet";
  static const String detail = "/detail";
  static const String getAllTimesheet = "/get/all-employees/timesheet";
  static const String todayShift = "/today-shift";
  static const String shiftIn = "/shift-in";
  static const String shiftOut = "/shift-out";
  static const String startBreak = "/break-start";
  static const String endBreak = "/break-end";
  static const String openShiftIn = "/open-shift-in";
  static const String openShiftOut = "/open-shift-out";
  static const String openBreakIn = "/open-break-in";
  static const String openBreakOut = "/open-break-out";
  static const String workArea = "/work-areas";
  static const String branch = "/fetch/assigned-branches";
  static const String getAllBranch = "/all-branches";
  static const String branchCheckout = "/checkout";
  static const String todayWorkingPeople = "/today-working-people";
  static const String upcomingSchedule = "/upcoming-shifts";
  static const String notifications = "/get/notifications";
  static const String readAllNotification = '/notifications/read-all';
  static const String employeeDocuments = "/user/documents";
  static const String employees = "/employees";
  static const String createShift = "/create-shift";
  static const String publishAllShift = "/publish-all-shift";
  static const String publishIndividualShift = "/publish-individual-shift";
  static const String scheduleDetails = "/schedule-details";
  static const String copyShift = "/copy-shifts";
  static const String updateShift = "/update-shift";
  static const String forceEndShift = "/force-end/shift";
  static const String deleteShift = "/delete";
  static const String statusCount = "/fetch/status/count";
  static const String leaveOverview = "/leave/overview";
  static const String leaveApprover = "/leave/approvers";
  static const String applyLeave = "/leave/apply";
  static const String updateLeave = "/leave";
  static const String appliedLeave = "/list/leaves";
  static const String assignedLeave = "/leave/assigned-requests";
  static const String approveTimeSheet = "/approve-timesheet";
  static const String timeSheetManual = "/timesheet/manual-entry";
  static const String notificationCount = "/notifcation/unread/count";
  static const String userImage = "/user/image";
  static const String updateImage = "/update/image";
  static const String inviteUser = "/invite/user";
  static const String basicDetails = "/basic/details";
  static const String employee = "/employee";
  static const String userUnavailability = "/user/unavailability";
  static const String userUnavailabilityUpdate = "/update/user/unavailability";
  static const String allPeoples = "/people";
  static const String updateUserDocuments = "/update/user/documents";
  static const String pendingInvitations = '/staff/pending-invitations';
  static String resendInvitation(int id) => '/staff/invitations/$id/resend';
  static const String userUnavailabilityDateRanges =
      '/user/unavailability/date-ranges';

  static const String userUnavailabilityDateRangeUpdate =
      '/update/user/unavailability/date-range';

  static String deleteUserUnavailabilityDateRange(int id) {
    return '/user/unavailability/$id';
  }

  static String shiftHistory(String id) {
    return '/shift/$id/history';
  }
}
