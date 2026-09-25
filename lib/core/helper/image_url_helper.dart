import 'package:stock_control_master/core/constants/constant.dart'
    show AppConstants;

class ImageUrlHelper {
  static String resolve(String? url) {
    if (url == null || url.trim().isEmpty) return '';

    final cleanUrl = url.trim();
    final baseUri = Uri.parse(AppConstants.baseUrl);

    try {
      // Relative path: /userprofile/3/profile-image
      if (cleanUrl.startsWith('/')) {
        return _joinBase(baseUri, cleanUrl);
      }

      // Relative path: userprofile/3/profile-image
      if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
        return _joinBase(baseUri, '/$cleanUrl');
      }

      final originalUri = Uri.parse(cleanUrl);

      // Already same base
      if (_sameBase(originalUri, baseUri)) {
        return cleanUrl;
      }

      // Replace any wrong base with AppConstants.baseUrl
      return Uri(
        scheme: baseUri.scheme,
        host: baseUri.host,
        port: baseUri.hasPort ? baseUri.port : null,
        path: originalUri.path,
        query: originalUri.query.isEmpty ? null : originalUri.query,
      ).toString();
    } catch (_) {
      return _joinBase(
        baseUri,
        cleanUrl.startsWith('/') ? cleanUrl : '/$cleanUrl',
      );
    }
  }

  static bool _sameBase(Uri url, Uri base) {
    final urlPort = url.hasPort ? url.port : _defaultPort(url.scheme);
    final basePort = base.hasPort ? base.port : _defaultPort(base.scheme);

    return url.scheme == base.scheme &&
        url.host == base.host &&
        urlPort == basePort;
  }

  static int? _defaultPort(String scheme) {
    if (scheme == 'http') return 80;
    if (scheme == 'https') return 443;
    return null;
  }

  static String _joinBase(Uri baseUri, String path) {
    return Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      port: baseUri.hasPort ? baseUri.port : null,
      path: path,
    ).toString();
  }
}
