import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/data/repositories/character/api/get_character_by_id_api_impl.dart';
import 'package:portal_remoto/data/repositories/character/api/search_characters_api_impl.dart';
import 'package:portal_remoto/data/settings/rest_api.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/domain/core/search_result.dart';
import 'package:portal_remoto/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl extends CharacterRepository {
  static const int itemsPerPage = 20;

  final RestApi api;
  final Map<int, CharacterEntity> _cache = {};

  CharacterRepositoryImpl(this.api);

  @override
  Future<AsyncValue<SearchResult<CharacterEntity>>> searchCharacters({
    required int page,
    String? query,
  }) async {
    final result = await searchCharactersApiImpl(
      api,
      page: page,
      itemsPerPage: itemsPerPage,
      query: query,
    );
    if (result case AsyncData(:final value)) {
      for (final character in value.data) {
        _cache[character.id] = character;
      }
    }
    return _withDefaultError(result, ErrorsConstants.errorGettingCharacters);
  }

  @override
  Future<AsyncValue<CharacterEntity>> getCharacterById(int id) async {
    final cached = _cache[id];
    if (cached != null) return AsyncData(cached);
    final result = await getCharacterByIdApiImpl(api, id);
    if (result case AsyncData(:final value)) _cache[id] = value;
    return _withDefaultError(result, ErrorsConstants.errorGettingCharacter);
  }

  /// Deja pasar las claves de [ErrorsConstants] y cambia cualquier otro error
  /// (JSON inválido, HTTP 500…) por [defaultError].
  AsyncValue<T> _withDefaultError<T>(
    AsyncValue<T> result,
    String defaultError,
  ) {
    if (result case AsyncError(:final error, :final stackTrace)
        when !(error is String && ErrorsConstants.existsKey(error))) {
      return AsyncError(defaultError, stackTrace);
    }
    return result;
  }
}
