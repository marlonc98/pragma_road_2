import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/domain/core/async_state.dart';
import 'package:portal_remoto/domain/core/search_result.dart';

abstract class CharacterRepository {
  Future<AsyncState<SearchResult<CharacterEntity>>>
  searchCharacters({required int page, String? query});

  Future<AsyncState<CharacterEntity>> getCharacterById(int id);
}
