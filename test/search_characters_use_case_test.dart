import 'package:flutter_test/flutter_test.dart';
import 'package:portal_remoto/data/repositories/character/character_repository_mock.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';
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
    expect(response.requireValue.data.map((character) => character.name), [
      'Rick Sanchez',
    ]);
  });

  test('pagina los resultados de 20 en 20', () async {
    final first = (await searchUseCase.searchCharacters(page: 1)).requireValue;
    final last = (await searchUseCase.searchCharacters(page: first.lastpage))
        .requireValue;

    expect(first.data, hasLength(CharacterRepositoryMock.itemsPerPage));
    expect(first.lastpage, 3);
    expect(
      last.data.length,
      first.totalItems - CharacterRepositoryMock.itemsPerPage * 2,
    );
  });

  test('un id que no existe da characterNotFound', () async {
    final useCase = GetCharacterByIdUseCase(characterRepository: repository);
    final response = await useCase.getCharacterById(-1);
    expect(response.error, ErrorsConstants.characterNotFound);
  });
}
