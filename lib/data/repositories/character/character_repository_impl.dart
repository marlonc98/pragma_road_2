import 'package:portal_remoto/data/repositories/character/api/get_character_by_id_api_impl.dart';
import 'package:portal_remoto/data/repositories/character/api/search_characters_api_impl.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/domain/entities/petition_status_entity.dart';
import 'package:portal_remoto/domain/entities/search_result_entity.dart';
import 'package:portal_remoto/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl extends CharacterRepository {
  static const int itemsPerPage = 20;

  @override
  Future<PetitionStatusEntity<SearchResultEntity<CharacterEntity>>>
  searchCharacters({required int page, String? query}) => _run(
    () => searchCharactersApiImpl(
      page: page,
      itemsPerPage: itemsPerPage,
      query: query,
    ),
    defaultError: ErrorsConstants.errorGettingCharacters,
  );

  @override
  Future<PetitionStatusEntity<CharacterEntity>> getCharacterById(int id) =>
      _run(
        () => getCharacterByIdApiImpl(id),
        defaultError: ErrorsConstants.errorGettingCharacter,
      );

  Future<PetitionStatusEntity<T>> _run<T>(
    Future<T> Function() call, {
    String? defaultError,
  }) async {
    try {
      return PetitionStatusEntity.success(data: await call());
    } catch (error) {
      return PetitionStatusEntity.fromError(error, defaultError: defaultError);
    }
  }
}
