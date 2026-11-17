import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/domain/repositories/character_repository.dart';

class GetCharacterByIdUseCase {
  final CharacterRepository characterRepository;

  GetCharacterByIdUseCase({required this.characterRepository});

  Future<AsyncValue<CharacterEntity>> getCharacterById(int id) =>
      characterRepository.getCharacterById(id);
}
