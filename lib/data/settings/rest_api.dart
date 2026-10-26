import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:portal_remoto/domain/constants/errors_constants.dart';

class RestApi {
  final String hostUrl;
  final http.Client client;
  final Duration timeout;

  RestApi({
    required this.hostUrl,
    http.Client? client,
    this.timeout = const Duration(seconds: 30),
  }) : client = client ?? http.Client();

  Future<Map<String, String>> headers() async {
    return {"Content-Type": "application/json; charset=utf-8"};
  }

  Future<String> get(String relativeUrl, {Map<String, String>? query}) async {
    final url = Uri.parse(
      hostUrl + relativeUrl,
    ).replace(queryParameters: query == null || query.isEmpty ? null : query);
    try {
      final response = await client
          .get(url, headers: await headers())
          .timeout(timeout);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return response.body;
      }
      if (response.statusCode == 401) throw ErrorsConstants.unauthorized;
      if (response.statusCode == 404) throw ErrorsConstants.notFound;
      throw response.body.isEmpty
          ? 'HTTP ${response.statusCode}'
          : response.body;
    } on TimeoutException catch (_) {
      throw ErrorsConstants.timeout;
    } on SocketException catch (_) {
      throw ErrorsConstants.noInternet;
    } on http.ClientException catch (_) {
      throw ErrorsConstants.noInternet;
    }
  }
}
