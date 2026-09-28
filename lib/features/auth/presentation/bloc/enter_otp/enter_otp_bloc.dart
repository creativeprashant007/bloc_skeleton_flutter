import 'dart:async';

import 'package:stock_control_master/core/locator.dart' show locator;
import 'package:stock_control_master/features/auth/domain/params/verify_otp_params.dart'
    show VerifyOtpParams;
import 'package:stock_control_master/features/auth/domain/usecases/verify_otp_usecase.dart'
    show VerifyOtpUsecase;
import 'package:stock_control_master/shared/widgets/organisms/error_dialog.dart'
    show ErrorDialog;
import 'package:stock_control_master/shared/widgets/organisms/loading_dialog.dart'
    show LoadingDialog;
import 'package:stock_control_master/core/services/dialog_and_sheet_service/dialog_and_sheet_service.dart'
    show DialogAndSheetService;
import 'package:stock_control_master/core/services/navigation_service/navigation_service.dart'
    show NavigationService;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'enter_otp_event.dart';
part 'enter_otp_state.dart';

class EnterOtpBloc extends Bloc<EnterOtpEvent, EnterOtpState> {
  EnterOtpBloc() : super(EnterOtpInitial()) {
    on<EnterOtpEvent>((event, emit) {});
    on<SubmitOtpEvent>(_submitOtp);
    on<ResendOtpEvent>(_resendOtp);
    on<NotYouEvent>(_notYou);
  }

  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogAndSheetService>();

  Future<void> _submitOtp(
    SubmitOtpEvent event,
    Emitter<EnterOtpState> emit,
  ) async {
    _dialogService.showAppDialog(child: LoadingDialog(message: "Verifying..."));

    final res = await VerifyOtpUsecase().call(
      VerifyOtpParams(email: event.email, otp: event.otp),
    );

    res.fold(
      (failure) {
        _navigationService.back();
        _dialogService.showAppDialog(
          child: ErrorDialog(errorMessage: failure.message),
        );
      },
      (success) {
        // _navigationService.navigateToOffAllNamed(
        //   IndexScreen.routeName,
        //   (_) => false,
        // );
      },
    );
  }

  FutureOr<void> _resendOtp(
    ResendOtpEvent event,
    Emitter<EnterOtpState> emit,
  ) {}

  FutureOr<void> _notYou(NotYouEvent event, Emitter<EnterOtpState> emit) {
    _navigationService.back();
  }
}
