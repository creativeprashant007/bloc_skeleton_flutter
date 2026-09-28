abstract class LocalStorageService {
  Future<dynamic> read({
    required String boxName,
    required String key,
    dynamic defaultValue,
  });
  Future<void> write({
    required String boxName,
    required String key,
    required dynamic value,
  });
  Future<void> deleteAll();
  Future<void> deleteRecord({required String boxName, required String key});
  Future<void> deleteBox({required String boxName});
}
