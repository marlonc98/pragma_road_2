import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/domain/entities/petition_status_entity.dart';
import 'package:portal_remoto/domain/entities/search_result_entity.dart';
import 'package:portal_remoto/domain/repositories/character_repository.dart';

class SearchCharactersUseCase {
  final CharacterRepository characterRepository;

  SearchCharactersUseCase({required this.characterRepository});

  Future<PetitionStatusEntity<SearchResultEntity<CharacterEntity>>>
  searchCharacters({required int page, String? query}) =>
      characterRepository.searchCharacters(page: page, query: query?.trim());
}
