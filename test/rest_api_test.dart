import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:portal_remoto/data/settings/rest_api.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';

final api = RestApi(
  hostUrl: 'https://example.test',
  timeout: const Duration(milliseconds: 20),
);

Future<Object?> errorOf(Future<http.Response> Function() respond) =>
    http.runWithClient(() async {
      try {
        await api.get('/character');
        return null;
      } catch (error) {
        return error;
      }
    }, () => MockClient((_) => respond()));

void main() {
  test('si se vence el tiempo es timeout', () async {
    final error = await errorOf(() async {
      await Future.delayed(const Duration(milliseconds: 200));
      return http.Response('{}', 200);
    });
    expect(error, ErrorsConstants.timeout);
  });

  test('si no se puede abrir la conexión es noInternet', () async {
    final error = await errorOf(
      () => throw const SocketException('Failed host lookup'),
    );
    expect(error, ErrorsConstants.noInternet);
  });

  test('si el cliente http falla es noInternet', () async {
    final error = await errorOf(
      () => throw http.ClientException('Connection closed'),
    );
    expect(error, ErrorsConstants.noInternet);
  });
}
