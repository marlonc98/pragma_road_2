import 'package:flutter_test/flutter_test.dart';
import 'package:portal_remoto/data/repositories/character/character_repository_mock.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/domain/use_cases/character/get_character_by_id_use_case.dart';
import 'package:portal_remoto/domain/use_cases/character/search_characters_use_case.dart';

void main() {
  final repository = CharacterRepositoryMock();
  final searchUseCase = SearchCharactersUseCase(
    characterRepository: repository,
  );

  test('quita los espacios del texto antes de buscar', () async {
    final response = await searchUseCase.searchCharacters(
      page: 1,
      query: '  rick sanchez  ',
    );
    expect(response.data!.data.map((character) => character.name), [
      'Rick Sanchez',
    ]);
  });

  test('pagina los resultados de 20 en 20', () async {
    final first = await searchUseCase.searchCharacters(page: 1);
    final last = await searchUseCase.searchCharacters(
      page: first.data!.lastpage,
    );

    expect(first.data!.data, hasLength(CharacterRepositoryMock.itemsPerPage));
    expect(first.data!.lastpage, 3);
    expect(
      last.data!.data.length,
      first.data!.totalItems - CharacterRepositoryMock.itemsPerPage * 2,
    );
  });

  test('un id que no existe da characterNotFound', () async {
    final useCase = GetCharacterByIdUseCase(characterRepository: repository);
    final response = await useCase.getCharacterById(-1);
    expect(response.error, ErrorsConstants.characterNotFound);
  });

  test('la palabra clave busca también por especie, sin repetir', () async {
    final response = await searchUseCase.searchCharacters(
      page: 1,
      query: 'Alien',
    );
    final characters = response.data!.data;
    final ids = characters.map((character) => character.id);

    expect(characters.first.name, 'Alien Rick');
    expect(ids.toSet(), hasLength(ids.length));
    expect(
      characters.every((character) => character.species == 'Alien'),
      isTrue,
    );
    expect(response.data!.lastpage, 2);
  });

  test('la palabra clave en español busca por estado', () async {
    final response = await searchUseCase.searchCharacters(
      page: 1,
      query: 'muerto',
    );
    final characters = response.data!.data;

    expect(characters, isNotEmpty);
    expect(
      characters.every((character) => character.status == CharacterStatus.dead),
      isTrue,
    );
  });

  test('arma un filtro por campo para la palabra clave', () {
    final filters = SearchCharactersUseCase.keywordFilters('desconocido');

    expect(filters.map((filter) => filter.name), [
      'desconocido',
      null,
      null,
      null,
      null,
    ]);
    expect(filters[3].status, CharacterStatus.unknown);
    expect(filters[4].gender, CharacterGender.unknown);
  });
}
