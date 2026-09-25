import 'package:dartz/dartz.dart';
import 'package:stock_control_master/features/index/domain/repository/index_repository.dart';
import 'package:stock_control_master/features/index/domain/entity/notification_count_response.dart'
    show NotificationCountResponse;

import 'package:stock_control_master/core/locator.dart';
import 'package:stock_control_master/shared/failure.dart';
import 'package:stock_control_master/shared/usecase.dart';

class NotificationCountUseCase
    with UseCases<NotificationCountResponse, NoParams> {
  final IndexRepository _repository = locator<IndexRepository>();

  @override
  Future<Either<Failure, NotificationCountResponse>> call(NoParams params) {
    return _repository.getNotificationCount();
  }

  Future<Either<Failure, NotificationCountResponse>> callNoParams() {
    return _repository.getNotificationCount();
  }
}
