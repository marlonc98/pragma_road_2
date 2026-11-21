import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';
import 'package:remote_data_kit/remote_data_kit.dart';

/// Convierte el [AsyncState] de `remote_data_kit` en el [AsyncValue] de
/// Riverpod que usa la app.
extension AsyncStateToAsyncValue<T> on AsyncState<T> {
  /// - `complete` → [AsyncData] con [AsyncState.data].
  /// - `failed` → [AsyncError] con una clave de [ErrorsConstants], lista para
  ///   traducir en la vista.
  /// - `loading` y `notStarted` → [AsyncLoading].
  ///
  /// [errorKeys] permite cambiar la clave de algunos errores según el caso de
  /// uso, por ejemplo `notFound` → `characterNotFound`.
  AsyncValue<T> toAsyncValue({
    Map<AsyncStateError, String> errorKeys = const {},
  }) {
    return switch (status) {
      PetitionStatus.complete => AsyncData(data as T),
      PetitionStatus.failed => AsyncError(
        errorKeys[error] ??
            ErrorsConstants.fromAsyncStateError(
              error ?? AsyncStateError.unknown,
            ),
        StackTrace.current,
      ),
      PetitionStatus.loading || PetitionStatus.notStarted => AsyncLoading<T>(),
    };
  }
}
