class AppConstants {
  static const String STORAGE_USER_DATA_KEY = 'user_data';
  static const String STORAGE_TOKEN_KEY = 'auth_token';
  static const String STORAGE_TOKEN_TYPE_KEY = 'auth_token_type';
  static const String STORAGE_DEVICE_OPEN_FIRST_TIME = 'device_open_first_time';

  static const String STORAGE_ACTIVE_BRANCH_ID_KEY = 'active_branch_id';
  static const String STORAGE_BRANCH_PROMPT_DATE_KEY =
      'branch_prompt_shown_date';

  //dev
  static const String baseUrl = "https://deputy.appsite.com.np";

  //live
  // static const String baseUrl = "https://hrmaster.co.uk";

  //office
  // static const String baseUrl = "http://192.168.1.169:8000";

  //home
  // static const String baseUrl = "http://192.168.0.185:8000";
  //me
  // static const String baseUrl = "http://172.20.10.13:8000";

  static const String SERVER_API_URL = "$baseUrl/api";

  static const String LOGIN = "/login";
  static const String currencySymbol = "£";
}
