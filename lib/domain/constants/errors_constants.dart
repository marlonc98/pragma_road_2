import 'package:remote_data_kit/remote_data_kit.dart';

/// Claves de traducción de los errores que muestra la app.
class ErrorsConstants {
  static const String unauthorized = 'unauthorized';
  static const String invalidResponse = 'invalidResponse';
  static const String unknownError = "unknownError";
  static const String noInternet = "noInternet";
  static const String timeout = "timeout";
  static const String notFound = "notFound";

  static const String noUserFound = "noUserFound";

  static const String errorGettingCharacters = "errorGettingCharacters";
  static const String errorGettingCharacter = "errorGettingCharacter";
  static const String characterNotFound = "characterNotFound";

  /// Clave de traducción por defecto para cada error de `remote_data_kit`.
  static String fromAsyncStateError(AsyncStateError error) => switch (error) {
    AsyncStateError.unauthorized => unauthorized,
    AsyncStateError.noInternet => noInternet,
    AsyncStateError.timeout => timeout,
    AsyncStateError.notFound => notFound,
    AsyncStateError.invalidResponse => invalidResponse,
    AsyncStateError.unknown => unknownError,
  };
}
