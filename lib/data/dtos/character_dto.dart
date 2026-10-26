import 'package:portal_remoto/domain/entities/character_entity.dart';

class CharacterDto {
  static CharacterEntity fromJSON(Map<String, dynamic> json) {
    return CharacterEntity(
      id: json['id'],
      name: json['name'] ?? '',
      status: _status(json['status']),
      species: json['species'] ?? '',
      type: json['type'],
      gender: _gender(json['gender']),
      image: json['image'] ?? '',
      originName: _place(json['origin']),
      locationName: _place(json['location']),
      episodesCount: (json['episode'] as List?)?.length ?? 0,
    );
  }

  static CharacterStatus _status(String? value) =>
      switch (value?.toLowerCase()) {
        'alive' => CharacterStatus.alive,
        'dead' => CharacterStatus.dead,
        _ => CharacterStatus.unknown,
      };

  static CharacterGender _gender(String? value) =>
      switch (value?.toLowerCase()) {
        'female' => CharacterGender.female,
        'male' => CharacterGender.male,
        'genderless' => CharacterGender.genderless,
        _ => CharacterGender.unknown,
      };

  static String? _place(dynamic place) {
    final String? name = place?['name'];
    if (name == null || name.isEmpty || name == 'unknown') return null;
    return name;
  }
}
