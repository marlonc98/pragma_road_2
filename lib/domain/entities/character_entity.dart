enum CharacterStatus { alive, dead, unknown }

enum CharacterGender { female, male, genderless, unknown }

class CharacterEntity {
  final int id;
  final String name;
  final CharacterStatus status;
  final String species;
  final String? type;
  final CharacterGender gender;
  final String image;
  final String? originName;
  final String? locationName;
  final int episodesCount;

  CharacterEntity({
    required this.id,
    required this.name,
    required this.image,
    this.status = CharacterStatus.unknown,
    this.species = '',
    this.type,
    this.gender = CharacterGender.unknown,
    this.originName,
    this.locationName,
    this.episodesCount = 0,
  });

  bool get hasType => type?.trim().isNotEmpty ?? false;
}
