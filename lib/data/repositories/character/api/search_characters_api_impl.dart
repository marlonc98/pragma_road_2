import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/data/core/async_state_extension.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';
import 'package:remote_data_kit/remote_data_kit.dart';

Future<AsyncValue<SearchResult<CharacterEntity>>> searchCharactersApiImpl(
  RemoteDataKit kit, {
  required int page,
  String? query,
}) async {
  final result = await kit.characters.searchCharacters(
    page: page,
    query: query,
  );
  return result.toAsyncValue(
    errorKeys: const {
      AsyncStateError.invalidResponse: ErrorsConstants.errorGettingCharacters,
      AsyncStateError.unknown: ErrorsConstants.errorGettingCharacters,
    },
  );
}
