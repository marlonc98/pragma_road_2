import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';
import 'package:portal_remoto/data/core/async_state_extension.dart';
import 'package:remote_data_kit/remote_data_kit.dart';

void main() {
  test('complete se convierte en AsyncData', () {
    final value = AsyncState<int>.success(data: 4).toAsyncValue();
    expect(value, isA<AsyncData<int>>());
    expect(value.requireValue, 4);
  });

  test('loading y notStarted se convierten en AsyncLoading', () {
    expect(AsyncState<int>.loading().toAsyncValue(), isA<AsyncLoading<int>>());
    expect(
      AsyncState<int>.notStarted().toAsyncValue(),
      isA<AsyncLoading<int>>(),
    );
  });

  test('cada AsyncStateError tiene su clave de traducción', () {
    final keys = {
      for (final error in AsyncStateError.values)
        error: AsyncState<int>.fromError(error).toAsyncValue().error,
    };
    expect(keys, {
      AsyncStateError.unauthorized: ErrorsConstants.unauthorized,
      AsyncStateError.noInternet: ErrorsConstants.noInternet,
      AsyncStateError.timeout: ErrorsConstants.timeout,
      AsyncStateError.notFound: ErrorsConstants.notFound,
      AsyncStateError.invalidResponse: ErrorsConstants.invalidResponse,
      AsyncStateError.unknown: ErrorsConstants.unknownError,
    });
  });

  test('errorKeys cambia la clave de un error', () {
    final value = AsyncState<int>.fromError(AsyncStateError.notFound)
        .toAsyncValue(
          errorKeys: {
            AsyncStateError.notFound: ErrorsConstants.characterNotFound,
          },
        );
    expect(value.error, ErrorsConstants.characterNotFound);
  });
}
