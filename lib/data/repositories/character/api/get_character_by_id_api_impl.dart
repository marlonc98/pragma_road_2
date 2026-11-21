import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/data/core/async_state_extension.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';
import 'package:remote_data_kit/remote_data_kit.dart';

Future<AsyncValue<CharacterEntity>> getCharacterByIdApiImpl(
  RemoteDataKit kit,
  int id,
) async {
  final result = await kit.characters.getCharacterById(id);
  return result.toAsyncValue(
    errorKeys: const {
      AsyncStateError.notFound: ErrorsConstants.characterNotFound,
      AsyncStateError.invalidResponse: ErrorsConstants.errorGettingCharacter,
      AsyncStateError.unknown: ErrorsConstants.errorGettingCharacter,
    },
  );
}
