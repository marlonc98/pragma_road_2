import 'package:portal_remoto/domain/entities/character_entity.dart';

class CharacterFilterEntity {
  final String? name;
  final String? species;
  final String? type;
  final CharacterStatus? status;
  final CharacterGender? gender;

  const CharacterFilterEntity({
    this.name,
    this.species,
    this.type,
    this.status,
    this.gender,
  });

  bool matches(CharacterEntity character) =>
      _contains(character.name, name) &&
      _contains(character.species, species) &&
      _contains(character.type, type) &&
      (status == null || character.status == status) &&
      (gender == null || character.gender == gender);

  static bool _contains(String? value, String? search) =>
      search == null ||
      (value?.toLowerCase().contains(search.toLowerCase()) ?? false);
}
