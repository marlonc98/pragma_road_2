import 'package:portal_remoto/domain/core/async_state.dart';
import 'package:portal_remoto/domain/core/search_result.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/domain/repositories/character_repository.dart';

class SearchCharactersUseCase {
  final CharacterRepository characterRepository;

  SearchCharactersUseCase({required this.characterRepository});

  Future<AsyncState<SearchResult<CharacterEntity>>>
  searchCharacters({required int page, String? query}) =>
      characterRepository.searchCharacters(page: page, query: query?.trim());
}
