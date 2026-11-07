import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:portal_remoto/data/settings/rest_api.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';

class _FakeConnectionApi extends RestApi {
  final bool connected;

  _FakeConnectionApi({required this.connected})
    : super(
        hostUrl: 'https://example.test',
        timeout: const Duration(milliseconds: 20),
      );

  @override
  Future<bool> hasInternetConnection() async => connected;
}

Future<Object?> errorOf(RestApi api) => http.runWithClient(
  () async {
    try {
      await api.get('/slow');
      return null;
    } catch (error) {
      return error;
    }
  },
  () => MockClient((_) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return http.Response('{}', 200);
  }),
);

void main() {
  test('si se vence el tiempo y hay conexión, es timeout', () async {
    expect(
      await errorOf(_FakeConnectionApi(connected: true)),
      ErrorsConstants.timeout,
    );
  });

  test('si se vence el tiempo y no hay conexión, es noInternet', () async {
    expect(
      await errorOf(_FakeConnectionApi(connected: false)),
      ErrorsConstants.noInternet,
    );
  });
}
