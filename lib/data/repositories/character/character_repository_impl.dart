import 'package:portal_remoto/data/repositories/character/api/get_character_by_id_api_impl.dart';
import 'package:portal_remoto/data/repositories/character/api/search_characters_api_impl.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/domain/core/async_state.dart';
import 'package:portal_remoto/domain/core/search_result.dart';
import 'package:portal_remoto/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl extends CharacterRepository {
  static const int itemsPerPage = 20;

  final Map<int, CharacterEntity> _cache = {};

  @override
  Future<AsyncState<SearchResult<CharacterEntity>>>
  searchCharacters({required int page, String? query}) async {
    final response = await _run(
      () => searchCharactersApiImpl(
        page: page,
        itemsPerPage: itemsPerPage,
        query: query,
      ),
      defaultError: ErrorsConstants.errorGettingCharacters,
    );
    for (final character in response.data?.data ?? <CharacterEntity>[]) {
      _cache[character.id] = character;
    }
    return response;
  }

  @override
  Future<AsyncState<CharacterEntity>> getCharacterById(int id) async {
    final cached = _cache[id];
    if (cached != null) return AsyncState.success(data: cached);
    final response = await _run(
      () => getCharacterByIdApiImpl(id),
      defaultError: ErrorsConstants.errorGettingCharacter,
    );
    if (response.data != null) _cache[id] = response.data!;
    return response;
  }

  Future<AsyncState<T>> _run<T>(
    Future<T> Function() call, {
    String? defaultError,
  }) async {
    try {
      return AsyncState.success(data: await call());
    } catch (error) {
      return AsyncState.fromError(error, defaultError: defaultError);
    }
  }
}
