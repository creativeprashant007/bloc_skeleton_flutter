import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import 'package:stock_control_master/core/services/local_storage_service/local_storage_service.dart';

class ILocalStorageService extends LocalStorageService {
  @override
  Future<void> deleteBox({required String boxName}) async {
    try {
      await Hive.deleteBoxFromDisk(boxName);
      Logger().i('$boxName Hive Box deleted');
    } on Exception catch (e) {
      Logger().e(e);
    }
  }

  @override
  Future<void> deleteAll() async {
    await Hive.deleteFromDisk();
  }

  @override
  Future read({
    required String boxName,
    required String key,
    dynamic defaultValue,
  }) async {
    try {
      var box = await Hive.openBox(boxName);
      return box.get(key, defaultValue: defaultValue);
    } on Exception catch (e) {
      Logger().e(e);
      return defaultValue;
    }
  }

  @override
  Future<void> write({
    required String boxName,
    required String key,
    value,
  }) async {
    var box = await Hive.openBox(boxName);
    return box.put(key, value);
  }

  @override
  Future<void> deleteRecord({required String boxName, required String key}) {
    throw UnimplementedError();
  }
}
