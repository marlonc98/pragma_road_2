import 'package:portal_remoto/domain/core/search_result.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';

/// Los métodos lanzan una clave de [ErrorsConstants] cuando fallan.
abstract class CharacterRepository {
  Future<SearchResult<CharacterEntity>> searchCharacters({
    required int page,
    String? query,
  });

  Future<CharacterEntity> getCharacterById(int id);
}
