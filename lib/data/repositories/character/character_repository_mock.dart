import 'package:portal_remoto/domain/constants/errors_constants.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/domain/core/async_state.dart';
import 'package:portal_remoto/domain/core/search_result.dart';
import 'package:portal_remoto/domain/repositories/character_repository.dart';

String _avatar(int id) =>
    'https://rickandmortyapi.com/api/character/avatar/$id.jpeg';

final List<CharacterEntity> _fakeCharacters = [
  CharacterEntity(
    id: 1,
    name: 'Rick Sanchez',
    status: CharacterStatus.alive,
    species: 'Human',
    gender: CharacterGender.male,
    image: _avatar(1),
    originName: 'Earth (C-137)',
    locationName: 'Citadel of Ricks',
    episodesCount: 51,
  ),
  CharacterEntity(
    id: 2,
    name: 'Morty Smith',
    status: CharacterStatus.alive,
    species: 'Human',
    gender: CharacterGender.male,
    image: _avatar(2),
    locationName: 'Citadel of Ricks',
    episodesCount: 51,
  ),
  CharacterEntity(
    id: 3,
    name: 'Summer Smith',
    status: CharacterStatus.alive,
    species: 'Human',
    gender: CharacterGender.female,
    image: _avatar(3),
    originName: 'Earth (Replacement Dimension)',
    locationName: 'Earth (Replacement Dimension)',
    episodesCount: 42,
  ),
  CharacterEntity(
    id: 4,
    name: 'Beth Smith',
    status: CharacterStatus.alive,
    species: 'Human',
    gender: CharacterGender.female,
    image: _avatar(4),
    originName: 'Earth (Replacement Dimension)',
    locationName: 'Earth (Replacement Dimension)',
    episodesCount: 42,
  ),
  CharacterEntity(
    id: 5,
    name: 'Jerry Smith',
    status: CharacterStatus.alive,
    species: 'Human',
    gender: CharacterGender.male,
    image: _avatar(5),
    originName: 'Earth (Replacement Dimension)',
    locationName: 'Earth (Replacement Dimension)',
    episodesCount: 39,
  ),
  CharacterEntity(
    id: 8,
    name: 'Adjudicator Rick',
    status: CharacterStatus.dead,
    species: 'Human',
    gender: CharacterGender.male,
    image: _avatar(8),
    locationName: 'Citadel of Ricks',
    episodesCount: 1,
  ),
  CharacterEntity(
    id: 15,
    name: 'Alien Rick',
    status: CharacterStatus.unknown,
    species: 'Alien',
    gender: CharacterGender.male,
    image: _avatar(15),
    episodesCount: 1,
  ),
  CharacterEntity(
    id: 242,
    name: 'Mr. Meeseeks',
    status: CharacterStatus.unknown,
    species: 'Humanoid',
    type: 'Meeseeks',
    gender: CharacterGender.male,
    image: _avatar(242),
    originName: "Mr. Meeseeks Box",
    episodesCount: 3,
  ),
  ...List.generate(
    40,
    (index) => CharacterEntity(
      id: 100 + index,
      name: 'Morty ${index + 1}',
      status: CharacterStatus.values[index % CharacterStatus.values.length],
      species: index.isEven ? 'Human' : 'Alien',
      gender: CharacterGender.values[index % CharacterGender.values.length],
      image: _avatar(100 + index),
      episodesCount: index % 5 + 1,
    ),
  ),
];

class CharacterRepositoryMock extends CharacterRepository {
  static const int itemsPerPage = 20;

  final Duration _delay = const Duration(milliseconds: 400);

  @override
  Future<AsyncState<SearchResult<CharacterEntity>>>
  searchCharacters({required int page, String? query}) async {
    await Future.delayed(_delay);
    final search = query?.toLowerCase() ?? '';
    final characters = _fakeCharacters
        .where((character) => character.name.toLowerCase().contains(search))
        .toList();
    return AsyncState.success(
      data: SearchResult(
        currentPage: page,
        totalItems: characters.length,
        data: characters
            .skip((page - 1) * itemsPerPage)
            .take(itemsPerPage)
            .toList(),
        itemsPerPage: itemsPerPage,
        lastpage: (characters.length / itemsPerPage).ceil(),
      ),
    );
  }

  @override
  Future<AsyncState<CharacterEntity>> getCharacterById(int id) async {
    await Future.delayed(_delay);
    final index = _fakeCharacters.indexWhere((element) => element.id == id);
    if (index == -1) {
      return AsyncState.fromError(ErrorsConstants.characterNotFound);
    }
    return AsyncState.success(data: _fakeCharacters[index]);
  }
}
