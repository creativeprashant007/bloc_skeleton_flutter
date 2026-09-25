import 'package:dartz/dartz.dart' show Either;
import 'package:stock_control_master/core/locator.dart' show locator;
import 'package:stock_control_master/features/index/data/data_source/remote/index_remote_data_source.dart';
import 'package:stock_control_master/features/index/domain/entity/notification_count_response.dart';
import 'package:stock_control_master/features/index/domain/repository/index_repository.dart';

import 'package:stock_control_master/shared/failure.dart' show Failure;

class IndexRepositoryImpl implements IndexRepository {
  final IndexRemoteDataSource _remote = locator<IndexRemoteDataSource>();

  @override
  Future<Either<Failure, NotificationCountResponse>> getNotificationCount() {
    return _remote.getNotificationCount();
  }
}
