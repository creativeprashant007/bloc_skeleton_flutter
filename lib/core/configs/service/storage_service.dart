import 'dart:convert' show jsonDecode;

import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import 'package:stock_control_master/core/constants/constant.dart'
    show AppConstants;

class StorageService {
  SharedPreferences? _prefs;

  Future<StorageService> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    return this;
  }

  Future<SharedPreferences> _ensurePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  SharedPreferences? get _safePrefs => _prefs;

  // ================= BOOL =================
  Future<bool> setBool(String key, bool value) async {
    final prefs = await _ensurePrefs();
    return prefs.setBool(key, value);
  }

  bool getBool(String key) {
    return _safePrefs?.getBool(key) ?? false;
  }

  Future<bool> getBoolAsync(String key) async {
    final prefs = await _ensurePrefs();
    return prefs.getBool(key) ?? false;
  }

  // ================= STRING =================
  Future<bool> setString(String key, String value) async {
    final prefs = await _ensurePrefs();
    return prefs.setString(key, value);
  }

  String? getString(String key) {
    return _safePrefs?.getString(key);
  }

  Future<String?> getStringAsync(String key) async {
    final prefs = await _ensurePrefs();
    return prefs.getString(key);
  }

  // ================= INT =================
  Future<bool> setInt(String key, int value) async {
    final prefs = await _ensurePrefs();
    return prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _safePrefs?.getInt(key);
  }

  Future<int?> getIntAsync(String key) async {
    final prefs = await _ensurePrefs();
    return prefs.getInt(key);
  }

  // ================= REMOVE =================
  Future<bool> remove(String key) async {
    final prefs = await _ensurePrefs();
    return prefs.remove(key);
  }

  // ================= LOGIN =================
  bool getIsLoggedIn() {
    final token = _safePrefs?.getString(AppConstants.STORAGE_TOKEN_KEY);
    return token != null && token.trim().isNotEmpty;
  }

  Future<bool> getIsLoggedInAsync() async {
    final prefs = await _ensurePrefs();
    final token = prefs.getString(AppConstants.STORAGE_TOKEN_KEY);
    return token != null && token.trim().isNotEmpty;
  }

  Future<bool> storeUserData(String userData) async {
    final prefs = await _ensurePrefs();
    return prefs.setString(AppConstants.STORAGE_USER_DATA_KEY, userData);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await _ensurePrefs();
    final jsonString = prefs.getString(AppConstants.STORAGE_USER_DATA_KEY);

    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      final decoded = jsonDecode(jsonString);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (e) {
      print('Error decoding user data: $e');
      return null;
    }
  }

  // ================= TOKEN =================
  String? getToken() {
    return _safePrefs?.getString(AppConstants.STORAGE_TOKEN_KEY);
  }

  Future<String?> getTokenAsync() async {
    final prefs = await _ensurePrefs();
    return prefs.getString(AppConstants.STORAGE_TOKEN_KEY);
  }

  Future<bool> setToken(String token) async {
    final prefs = await _ensurePrefs();
    return prefs.setString(AppConstants.STORAGE_TOKEN_KEY, token);
  }

  // ================= ACTIVE BRANCH =================
  Future<bool> setActiveBranchId(int branchId) async {
    return setInt(AppConstants.STORAGE_ACTIVE_BRANCH_ID_KEY, branchId);
  }

  int? getActiveBranchId() {
    return getInt(AppConstants.STORAGE_ACTIVE_BRANCH_ID_KEY);
  }

  Future<int?> getActiveBranchIdAsync() async {
    return getIntAsync(AppConstants.STORAGE_ACTIVE_BRANCH_ID_KEY);
  }

  Future<bool> clearActiveBranchId() async {
    return remove(AppConstants.STORAGE_ACTIVE_BRANCH_ID_KEY);
  }

  // ================= BRANCH PROMPT ONCE PER DAY =================
  String _todayKey() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');

    return '${now.year}-$month-$day';
  }

  bool wasBranchPromptShownToday() {
    final savedDate = getString(AppConstants.STORAGE_BRANCH_PROMPT_DATE_KEY);
    return savedDate == _todayKey();
  }

  Future<bool> wasBranchPromptShownTodayAsync() async {
    final savedDate = await getStringAsync(
      AppConstants.STORAGE_BRANCH_PROMPT_DATE_KEY,
    );

    return savedDate == _todayKey();
  }

  Future<bool> markBranchPromptShownToday() async {
    return setString(AppConstants.STORAGE_BRANCH_PROMPT_DATE_KEY, _todayKey());
  }

  Future<bool> clearBranchPromptDate() async {
    return remove(AppConstants.STORAGE_BRANCH_PROMPT_DATE_KEY);
  }

  // ================= CLEAR =================
  Future<bool> clearAll() async {
    final prefs = await _ensurePrefs();
    return prefs.clear();
  }

  Future<void> logout() async {
    final rememberMe = await getBoolAsync('remember_me');

    await remove(AppConstants.STORAGE_TOKEN_KEY);
    await remove(AppConstants.STORAGE_USER_DATA_KEY);
    await remove(AppConstants.STORAGE_ACTIVE_BRANCH_ID_KEY);
    await remove(AppConstants.STORAGE_BRANCH_PROMPT_DATE_KEY);

    if (!rememberMe) {
      await remove('remember_email');
      await remove('remember_password');
    }
  }
}
