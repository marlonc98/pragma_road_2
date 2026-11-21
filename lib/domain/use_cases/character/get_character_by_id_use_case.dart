import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/domain/repositories/character_repository.dart';
import 'package:remote_data_kit/remote_data_kit.dart' hide CharacterRepository;

class GetCharacterByIdUseCase {
  final CharacterRepository characterRepository;

  GetCharacterByIdUseCase({required this.characterRepository});

  Future<AsyncValue<CharacterEntity>> getCharacterById(int id) =>
      characterRepository.getCharacterById(id);
}
