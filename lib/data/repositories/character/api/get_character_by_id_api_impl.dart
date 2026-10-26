import 'dart:convert';

import 'package:portal_remoto/data/dtos/character_dto.dart';
import 'package:portal_remoto/data/settings/rick_and_morty_api.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';

Future<CharacterEntity> getCharacterByIdApiImpl(
  RickAndMortyApi api,
  int id,
) async {
  try {
    final responseText = await api.get('/character/$id');
    return CharacterDto.fromJSON(jsonDecode(responseText));
  } catch (error) {
    if (error == ErrorsConstants.notFound) {
      throw ErrorsConstants.characterNotFound;
    }
    rethrow;
  }
}
