import 'dart:math';

import 'package:portal_remoto/domain/constants/errors_constants.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/domain/entities/character_filter_entity.dart';
import 'package:portal_remoto/domain/entities/petition_status_entity.dart';
import 'package:portal_remoto/domain/entities/search_result_entity.dart';
import 'package:portal_remoto/domain/repositories/character_repository.dart';

class SearchCharactersUseCase {
  static const Map<String, CharacterStatus> statusKeywords = {
    'alive': CharacterStatus.alive,
    'vivo': CharacterStatus.alive,
    'viva': CharacterStatus.alive,
    'dead': CharacterStatus.dead,
    'muerto': CharacterStatus.dead,
    'muerta': CharacterStatus.dead,
    'unknown': CharacterStatus.unknown,
    'desconocido': CharacterStatus.unknown,
    'desconocida': CharacterStatus.unknown,
  };

  static const Map<String, CharacterGender> genderKeywords = {
    'female': CharacterGender.female,
    'femenino': CharacterGender.female,
    'mujer': CharacterGender.female,
    'male': CharacterGender.male,
    'masculino': CharacterGender.male,
    'hombre': CharacterGender.male,
    'genderless': CharacterGender.genderless,
    'sin género': CharacterGender.genderless,
    'sin genero': CharacterGender.genderless,
    'unknown': CharacterGender.unknown,
    'desconocido': CharacterGender.unknown,
    'desconocida': CharacterGender.unknown,
  };

  final CharacterRepository characterRepository;

  SearchCharactersUseCase({required this.characterRepository});

  Future<PetitionStatusEntity<SearchResultEntity<CharacterEntity>>>
  searchCharacters({required int page, String? query}) async {
    final keyword = query?.trim().toLowerCase() ?? '';
    if (keyword.isEmpty) {
      return characterRepository.searchCharacters(page: page);
    }

    final filters = keywordFilters(keyword);
    final responses = await Future.wait(
      filters.map(
        (filter) =>
            characterRepository.searchCharacters(page: page, filter: filter),
      ),
    );
    final failed = responses.where((response) => !response.isSuccess);
    if (failed.isNotEmpty) {
      return PetitionStatusEntity.fromError(
        failed.first.error ?? ErrorsConstants.errorGettingCharacters,
      );
    }

    final results = responses.map((response) => response.data!).toList();
    final characters = <CharacterEntity>[];
    for (var i = 0; i < filters.length; i++) {
      final previousFilters = filters.take(i);
      characters.addAll(
        results[i].data.where(
          (character) =>
              !previousFilters.any((filter) => filter.matches(character)),
        ),
      );
    }
    return PetitionStatusEntity.success(
      data: SearchResultEntity(
        currentPage: page,
        totalItems: results.fold(
          0,
          (total, result) => total + result.totalItems,
        ),
        data: characters,
        itemsPerPage: results.first.itemsPerPage,
        lastpage: results.map((result) => result.lastpage).reduce(max),
      ),
    );
  }

  static List<CharacterFilterEntity> keywordFilters(String keyword) {
    final status = statusKeywords[keyword];
    final gender = genderKeywords[keyword];
    return [
      CharacterFilterEntity(name: keyword),
      CharacterFilterEntity(species: keyword),
      CharacterFilterEntity(type: keyword),
      if (status != null) CharacterFilterEntity(status: status),
      if (gender != null) CharacterFilterEntity(gender: gender),
    ];
  }
}
