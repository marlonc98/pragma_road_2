import 'dart:convert';

import 'package:portal_remoto/data/dtos/character_dto.dart';
import 'package:portal_remoto/dependency_injection.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';

Future<CharacterEntity> getCharacterByIdApiImpl(int id) async {
  try {
    final responseText = await di
        .read(rickAndMortyApiProvider)
        .get('/character/$id');
    return CharacterDto.fromJSON(jsonDecode(responseText));
  } catch (error) {
    if (error == ErrorsConstants.notFound) {
      throw ErrorsConstants.characterNotFound;
    }
    rethrow;
  }
}
