class ErrorsConstants {
  static const String unauthorized = 'unauthorized';
  static const String unknownError = "unknownError";
  static const String noInternet = "noInternet";
  static const String timeout = "timeout";
  static const String notFound = "notFound";

  static const String noUserFound = "noUserFound";

  static const String errorGettingCharacters = "errorGettingCharacters";
  static const String errorGettingCharacter = "errorGettingCharacter";
  static const String characterNotFound = "characterNotFound";

  static bool existsKey(String key) {
    return [
      unauthorized,
      unknownError,
      noInternet,
      timeout,
      notFound,
      noUserFound,
      errorGettingCharacters,
      errorGettingCharacter,
      characterNotFound,
    ].contains(key);
  }
}
