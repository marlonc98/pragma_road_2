import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/data/dtos/character_dto.dart';
import 'package:portal_remoto/data/settings/rest_api.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';

Future<AsyncValue<CharacterEntity>> getCharacterByIdApiImpl(
  RestApi api,
  int id,
) async {
  final response = await api.get('/character/$id');
  if (response case AsyncError(:final error, :final stackTrace)) {
    return AsyncError(
      error == ErrorsConstants.notFound
          ? ErrorsConstants.characterNotFound
          : error,
      stackTrace,
    );
  }
  return AsyncValue.guard(
    () async => CharacterDto.fromJSON(jsonDecode(response.requireValue)),
  );
}
