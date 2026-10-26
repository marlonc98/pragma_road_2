import 'package:flutter_test/flutter_test.dart';
import 'package:portal_remoto/data/dtos/character_dto.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';

void main() {
  test('convierte el JSON de la API en CharacterEntity', () {
    final character = CharacterDto.fromJSON({
      'id': 1,
      'name': 'Rick Sanchez',
      'status': 'Alive',
      'species': 'Human',
      'type': '',
      'gender': 'Male',
      'origin': {'name': 'Earth (C-137)', 'url': ''},
      'location': {'name': 'Citadel of Ricks', 'url': ''},
      'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
      'episode': ['e1', 'e2', 'e3'],
    });

    expect(character.id, 1);
    expect(character.name, 'Rick Sanchez');
    expect(character.status, CharacterStatus.alive);
    expect(character.gender, CharacterGender.male);
    expect(character.hasType, isFalse);
    expect(character.originName, 'Earth (C-137)');
    expect(character.locationName, 'Citadel of Ricks');
    expect(character.episodesCount, 3);
  });

  test('los valores "unknown" o inesperados quedan como desconocidos', () {
    final character = CharacterDto.fromJSON({
      'id': 2,
      'name': 'Alguien',
      'status': 'unknown',
      'gender': 'otro',
      'origin': {'name': 'unknown'},
      'image': '',
    });

    expect(character.status, CharacterStatus.unknown);
    expect(character.gender, CharacterGender.unknown);
    expect(character.originName, isNull);
    expect(character.locationName, isNull);
    expect(character.episodesCount, 0);
  });
}
