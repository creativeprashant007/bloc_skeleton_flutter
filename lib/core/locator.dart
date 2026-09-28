import 'package:get_it/get_it.dart';

import 'package:stock_control_master/core/configs/service/storage_service.dart'
    show StorageService;

// ============================================================================
// CORE SERVICES
// ============================================================================

import 'package:stock_control_master/core/services/dialog_and_sheet_service/dialog_and_sheet_service.dart'
    show DialogAndSheetService;
import 'package:stock_control_master/core/services/dialog_and_sheet_service/i_dialog_and_sheet_service.dart'
    show IDialogAndSheetService;

import 'package:stock_control_master/core/services/local_storage_service/i_local_storage_service.dart'
    show ILocalStorageService;
import 'package:stock_control_master/core/services/local_storage_service/local_storage_service.dart'
    show LocalStorageService;

import 'package:stock_control_master/core/services/location_service/i_location_service.dart'
    show ILocationService;
import 'package:stock_control_master/core/services/location_service/location_service.dart'
    show LocationService;

import 'package:stock_control_master/core/services/navigation_service/i_navigation_service.dart'
    show INavigationService;
import 'package:stock_control_master/core/services/navigation_service/navigation_service.dart'
    show NavigationService;

import 'package:stock_control_master/core/services/network_service/i_network_service.dart'
    show INetworkService;
import 'package:stock_control_master/core/services/network_service/network_service.dart'
    show NetworkService;

// ============================================================================
// AUTH
// ============================================================================

import 'package:stock_control_master/features/auth/data/data_sources/remote_data_source/auth_remote_data_source.dart'
    show AuthRemoteDataSource;
import 'package:stock_control_master/features/auth/data/data_sources/remote_data_source/auth_remote_data_source_impl.dart'
    show AuthRemoteDataSourceImpl;
import 'package:stock_control_master/features/auth/data/repository/auth_repository_impl.dart'
    show AuthRepositoryImpl;
import 'package:stock_control_master/features/auth/domain/repository/auth_repository.dart'
    show AuthRepository;

// ============================================================================
// HOME
// ============================================================================

import 'package:stock_control_master/features/home/data/data_source/remote/home_remote_data_source.dart'
    show HomeShiftRemoteDataSource;
import 'package:stock_control_master/features/home/data/data_source/remote/home_remote_data_source_impl.dart'
    show HomeShiftRemoteDataSourceImpl;
import 'package:stock_control_master/features/home/data/repository/home_repository_impl.dart'
    show HomeShiftRepositoryImpl;
import 'package:stock_control_master/features/home/domain/repository/home_repository.dart'
    show HomeShiftRepository;

import 'package:stock_control_master/features/home/domain/usecases/upcoming_schedule_usecase.dart';
import 'package:stock_control_master/features/home/domain/usecases/working_people_today_usecase.dart';

import 'package:stock_control_master/features/home/domain/usecases/end_open_break_usecase.dart'
    show EndOpenBreakUseCase;
import 'package:stock_control_master/features/home/domain/usecases/end_open_shift_usecase.dart'
    show EndOpenShiftUseCase;
import 'package:stock_control_master/features/home/domain/usecases/end_scheduled_break_usecase.dart'
    show EndScheduledBreakUseCase;
import 'package:stock_control_master/features/home/domain/usecases/end_scheduled_shift_usecase.dart'
    show EndScheduledShiftUseCase;

import 'package:stock_control_master/features/home/domain/usecases/get_location_usecase.dart'
    show GetLocationsUseCase;
import 'package:stock_control_master/features/home/domain/usecases/get_today_shift_usecase.dart'
    show GetTodayShiftUseCase;

import 'package:stock_control_master/features/home/domain/usecases/start_open_break_usecase.dart'
    show StartOpenBreakUseCase;
import 'package:stock_control_master/features/home/domain/usecases/start_open_shift_usecase.dart'
    show StartOpenShiftUseCase;
import 'package:stock_control_master/features/home/domain/usecases/start_scheduled_break_usecase.dart'
    show StartScheduledBreakUseCase;
import 'package:stock_control_master/features/home/domain/usecases/start_scheduled_shift_usecase.dart'
    show StartScheduledShiftUseCase;

import 'package:stock_control_master/features/home/domain/usecases/switch_location_usecase.dart'
    show SwitchLocationUseCase;
import 'package:stock_control_master/features/home/domain/usecases/work_areas_usecase.dart'
    show WorkAreasUsecase;

// ============================================================================
// ACCOUNT
// ============================================================================

import 'package:stock_control_master/features/account/data/data_source/remote/account_remote_data_source.dart'
    show AccountRemoteDataSource;
import 'package:stock_control_master/features/account/data/data_source/remote/account_remote_data_source_impl.dart'
    show AccountRemoteDataSourceImpl;
import 'package:stock_control_master/features/account/data/repository/account_repository_impl.dart'
    show AccountRepositoryImpl;
import 'package:stock_control_master/features/account/domain/repository/account_repository.dart'
    show AccountRepository;

import 'package:stock_control_master/features/account/domain/usecase/invite_user_usecase.dart';
import 'package:stock_control_master/features/account/domain/usecase/get_pending_invitations.dart'
    show GetPendingInvitationsUseCase;
import 'package:stock_control_master/features/account/domain/usecase/resend_invitation_usecase.dart'
    show ResendInvitationUseCase;
import 'package:stock_control_master/features/account/domain/usecase/user_image_update_usecase.dart'
    show UserImageUpdateUseCase;
import 'package:stock_control_master/features/account/domain/usecase/user_image_usecase.dart'
    show UserImageUseCase;

// ============================================================================
// INDEX
// ============================================================================

import 'package:stock_control_master/features/index/data/data_source/remote/index_remote_data_source.dart';
import 'package:stock_control_master/features/index/data/data_source/remote/index_data_source_impl.dart'
    show IndexRemoteDataSourceImpl;
import 'package:stock_control_master/features/index/data/repository/index_repository_impl.dart';
import 'package:stock_control_master/features/index/domain/repository/index_repository.dart';
import 'package:stock_control_master/features/index/domain/usecase/notification_count_usecase.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // ===========================================================================
  // STORAGE
  // ===========================================================================

  locator.registerLazySingleton<StorageService>(() => StorageService());

  // ===========================================================================
  // CORE SERVICES
  // ===========================================================================

  locator.registerLazySingleton<NavigationService>(() => INavigationService());

  locator.registerLazySingleton<NetworkService>(() => INetworkService());

  locator.registerLazySingleton<DialogAndSheetService>(
    () => IDialogAndSheetService(),
  );

  locator.registerLazySingleton<LocalStorageService>(
    () => ILocalStorageService(),
  );

  locator.registerLazySingleton<LocationService>(() => ILocationService());

  // ===========================================================================
  // AUTH
  // ===========================================================================

  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // ===========================================================================
  // HOME
  // ===========================================================================

  locator.registerLazySingleton<HomeShiftRemoteDataSource>(
    () => HomeShiftRemoteDataSourceImpl(),
  );

  locator.registerLazySingleton<HomeShiftRepository>(
    () => HomeShiftRepositoryImpl(),
  );

  locator.registerFactory<GetTodayShiftUseCase>(() => GetTodayShiftUseCase());

  locator.registerFactory<StartScheduledShiftUseCase>(
    () => StartScheduledShiftUseCase(),
  );

  locator.registerFactory<EndScheduledShiftUseCase>(
    () => EndScheduledShiftUseCase(),
  );

  locator.registerFactory<StartScheduledBreakUseCase>(
    () => StartScheduledBreakUseCase(),
  );

  locator.registerFactory<EndScheduledBreakUseCase>(
    () => EndScheduledBreakUseCase(),
  );

  locator.registerFactory<StartOpenShiftUseCase>(() => StartOpenShiftUseCase());

  locator.registerFactory<EndOpenShiftUseCase>(() => EndOpenShiftUseCase());

  locator.registerFactory<StartOpenBreakUseCase>(() => StartOpenBreakUseCase());

  locator.registerFactory<EndOpenBreakUseCase>(() => EndOpenBreakUseCase());

  locator.registerFactory<WorkAreasUsecase>(() => WorkAreasUsecase());

  locator.registerFactory<WorkingPeopleTodayUsecase>(
    () => WorkingPeopleTodayUsecase(),
  );

  locator.registerFactory<UpcomingScheduleUsecase>(
    () => UpcomingScheduleUsecase(),
  );

  locator.registerFactory<GetLocationsUseCase>(() => GetLocationsUseCase());

  locator.registerFactory<SwitchLocationUseCase>(() => SwitchLocationUseCase());

  // ===========================================================================
  // ACCOUNT
  // ===========================================================================

  locator.registerLazySingleton<AccountRemoteDataSource>(
    () => AccountRemoteDataSourceImpl(),
  );

  locator.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(),
  );

  locator.registerFactory<UserImageUseCase>(() => UserImageUseCase());

  locator.registerFactory<UserImageUpdateUseCase>(
    () => UserImageUpdateUseCase(),
  );

  locator.registerFactory<InviteUserUseCase>(() => InviteUserUseCase());

  locator.registerFactory<GetPendingInvitationsUseCase>(
    () => GetPendingInvitationsUseCase(),
  );

  locator.registerFactory<ResendInvitationUseCase>(
    () => ResendInvitationUseCase(),
  );

  // ===========================================================================
  // INDEX
  // ===========================================================================

  locator.registerLazySingleton<IndexRemoteDataSource>(
    () => IndexRemoteDataSourceImpl(),
  );

  locator.registerLazySingleton<IndexRepository>(() => IndexRepositoryImpl());

  locator.registerFactory<NotificationCountUseCase>(
    () => NotificationCountUseCase(),
  );
}
