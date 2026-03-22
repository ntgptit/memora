abstract final class UrlUtils {
  static bool isAbsolute(String value) {
    final uri = Uri.tryParse(value);
    return uri != null && uri.hasScheme;
  }

  static Uri appendQueryParameters(
    String value,
    Map<String, String> queryParameters,
  ) {
    final uri = Uri.parse(value);
    return uri.replace(
      queryParameters: <String, String>{
        ...uri.queryParameters,
        ...queryParameters,
      },
    );
  }
}
