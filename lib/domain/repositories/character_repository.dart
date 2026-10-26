import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/domain/entities/petition_status_entity.dart';
import 'package:portal_remoto/domain/entities/search_result_entity.dart';

abstract class CharacterRepository {
  Future<PetitionStatusEntity<SearchResultEntity<CharacterEntity>>>
  searchCharacters({required int page, String? query});

  Future<PetitionStatusEntity<CharacterEntity>> getCharacterById(int id);
}
