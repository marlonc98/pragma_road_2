import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote_data_kit/remote_data_kit.dart' hide CharacterRepository;

/// Los métodos no lanzan: si fallan devuelven [AsyncError] con una clave de
/// [ErrorsConstants].
abstract class CharacterRepository {
  Future<AsyncValue<SearchResult<CharacterEntity>>> searchCharacters({
    required int page,
    String? query,
  });

  Future<AsyncValue<CharacterEntity>> getCharacterById(int id);
}
