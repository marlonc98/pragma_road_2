import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/data/repositories/character/api/get_character_by_id_api_impl.dart';
import 'package:portal_remoto/data/repositories/character/api/search_characters_api_impl.dart';
import 'package:portal_remoto/domain/repositories/character_repository.dart';
import 'package:remote_data_kit/remote_data_kit.dart' hide CharacterRepository;

/// Datos de prueba sin red, usando el entorno `mock` de `remote_data_kit`.
class CharacterRepositoryMock extends CharacterRepository {
  static const int itemsPerPage = 20;

  final RemoteDataKit _kit = RemoteDataKit(
    config: const RemoteDataKitConfig(
      environment: RemoteDataKitEnvironment.mock,
    ),
  );

  @override
  Future<AsyncValue<SearchResult<CharacterEntity>>> searchCharacters({
    required int page,
    String? query,
  }) => searchCharactersApiImpl(_kit, page: page, query: query);

  @override
  Future<AsyncValue<CharacterEntity>> getCharacterById(int id) =>
      getCharacterByIdApiImpl(_kit, id);
}
