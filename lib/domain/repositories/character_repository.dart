import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/domain/core/search_result.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';

/// Los métodos no lanzan: si fallan devuelven [AsyncError] con una clave de
/// [ErrorsConstants].
abstract class CharacterRepository {
  Future<AsyncValue<SearchResult<CharacterEntity>>> searchCharacters({
    required int page,
    String? query,
  });

  Future<AsyncValue<CharacterEntity>> getCharacterById(int id);
}
