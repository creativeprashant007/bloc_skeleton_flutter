import 'package:dartz/dartz.dart' show Either;
import 'package:stock_control_master/features/index/domain/entity/notification_count_response.dart';

import 'package:stock_control_master/shared/failure.dart' show Failure;

abstract class IndexRepository {
  Future<Either<Failure, NotificationCountResponse>> getNotificationCount();
}
