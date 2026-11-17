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
  Future<SearchResult<CharacterEntity>> searchCharacters({
    required int page,
    String? query,
  }) async {
    final result = await _run(
      () => searchCharactersApiImpl(
        api,
        page: page,
        itemsPerPage: itemsPerPage,
        query: query,
      ),
      defaultError: ErrorsConstants.errorGettingCharacters,
    );
    for (final character in result.data) {
      _cache[character.id] = character;
    }
    return result;
  }

  @override
  Future<CharacterEntity> getCharacterById(int id) async {
    final cached = _cache[id];
    if (cached != null) return cached;
    final character = await _run(
      () => getCharacterByIdApiImpl(api, id),
      defaultError: ErrorsConstants.errorGettingCharacter,
    );
    return _cache[id] = character;
  }

  /// Deja pasar las claves de [ErrorsConstants] y cambia cualquier otro error
  /// (JSON inválido, HTTP 500…) por [defaultError].
  Future<T> _run<T>(
    Future<T> Function() call, {
    required String defaultError,
  }) async {
    try {
      return await call();
    } catch (error) {
      if (error is String && ErrorsConstants.existsKey(error)) rethrow;
      throw defaultError;
    }
  }
}
