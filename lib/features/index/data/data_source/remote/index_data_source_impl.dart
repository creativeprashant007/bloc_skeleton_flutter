import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:stock_control_master/features/index/data/data_source/remote/index_remote_data_source.dart';
import 'package:stock_control_master/features/index/domain/entity/notification_count_response.dart';
import 'package:logger/web.dart' show Logger;

import 'package:stock_control_master/core/constants/api_constants.dart'
    show ApiConstants;
import 'package:stock_control_master/core/locator.dart' show locator;
import 'package:stock_control_master/core/services/network_service/network_service.dart'
    show NetworkService;
import 'package:stock_control_master/shared/failure.dart' show Failure;

class IndexRemoteDataSourceImpl implements IndexRemoteDataSource {
  final NetworkService _networkService = locator<NetworkService>();
  final Logger _logger = Logger();

  @override
  Future<Either<Failure, NotificationCountResponse>>
  getNotificationCount() async {
    try {
      final url = Uri.parse(ApiConstants.notificationCount);

      final res = await _networkService.get(url.toString());

      _logger.i('Notification Count list response status: ${res.status}');
      _logger.i('Notification Count list response message: ${res.message}');
      _logger.i('Notification Count list response data: ${res.data}');

      final rawData = res.data;
      if (rawData == null) {
        return Left(Failure('Notification Count data is empty.'));
      }

      if (rawData is! Map<String, dynamic>) {
        return Left(Failure('Invalid Notification Count response format.'));
      }

      final response = NotificationCountResponse(
        status: res.status == true,
        message: res.message ?? '',
        data: NotificationCountData.fromJson(rawData),
      );

      if (!response.status) {
        return Left(
          Failure(
            response.message.isEmpty
                ? 'Failed to fetch Notification Count list.'
                : response.message,
          ),
        );
      }

      return Right(response);
    } on Failure catch (e) {
      _logger.e('fetch Notification Count list failure: ${e.message}');
      return Left(e);
    } catch (e, stackTrace) {
      _logger.e(
        'fetch Notification Count list remote exception',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(Failure('Something went wrong: $e'));
    }
  }
}
