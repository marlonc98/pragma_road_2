import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:portal_remoto/domain/constants/errors_constants.dart';

class RestApi {
  final String hostUrl;
  final Duration timeout;

  RestApi({required this.hostUrl, this.timeout = const Duration(seconds: 30)});

  Future<Map<String, String>> headers() async {
    return {"Content-Type": "application/json; charset=utf-8"};
  }

  /// Devuelve el cuerpo de la respuesta en [AsyncData] o una clave de
  /// [ErrorsConstants] en [AsyncError]. No lanza excepciones.
  Future<AsyncValue<String>> get(
    String relativeUrl, {
    Map<String, String>? query,
  }) async {
    final url = Uri.parse(
      hostUrl + relativeUrl,
    ).replace(queryParameters: query == null || query.isEmpty ? null : query);
    try {
      final response = await http
          .get(url, headers: await headers())
          .timeout(timeout);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return AsyncData(response.body);
      }
      if (response.statusCode == 401) {
        return _error(ErrorsConstants.unauthorized);
      }
      if (response.statusCode == 404) return _error(ErrorsConstants.notFound);
      return _error(
        response.body.isEmpty ? 'HTTP ${response.statusCode}' : response.body,
      );
    } on TimeoutException catch (_) {
      return _error(ErrorsConstants.timeout);
    } on SocketException catch (_) {
      return _error(ErrorsConstants.noInternet);
    } on http.ClientException catch (_) {
      return _error(ErrorsConstants.noInternet);
    } catch (error, stackTrace) {
      return AsyncError(error, stackTrace);
    }
  }

  AsyncError<T> _error<T>(Object error) =>
      AsyncError(error, StackTrace.current);
}
